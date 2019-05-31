local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules
local settings = main.settings



-- << VARIABLES >>
local commandDebounce = main.settings.CommandDebounce
local loopRank
function module:UpdateLoopRank()
	loopRank = modules.cf:GetRankId(settings.LoopCommands)
end
main.functionsInLoop = {}



-- << LOCAL FUNCTIONS >>
local function checkPrefix(character, pdata)
	local incorrectPrefixes = {
		[":"] = true;
	}
	if main.infoOnAllCommands.Prefixes[character] or character == pdata.Prefix or (settings.WarnIncorrectPrefix and incorrectPrefixes[character]) then --Included the last argument as new players confuse ; with :
		return true
	else
		return false
	end
end



-- << FUNCTIONS >>
function module:ParseMessage(speaker, originalMessage, directlyFromChat, extraDetails)
	if directlyFromChat then
		coroutine.wrap(function() table.insert(main.logs.chat, {speakerName = speaker.Name, timeAdded = os.time(), message = modules.cf:FilterBroadcast(originalMessage, speaker)}) end)()
	end
	local message = string.lower(originalMessage)
	
	--Silent commands
	if string.sub(message,1,3) == "/e " then
		message = string.sub(message,4)
	end
	
	--Check if first character is a valid prefix
	local speakerData = main.pd[speaker]
	if checkPrefix(string.sub(message,1,1), speakerData) then
		
		--Convert message into batches
		local batches = {}
		local batchStarts = {1}
		local batchKeyLength = #settings.BatchKey
		if batchKeyLength < 1 then
			batchKeyLength = 1
		end
		for i = 1, #message do
			local character = string.sub(message,i,i)
			if i > 2 and checkPrefix(character, speakerData) then
				local batchCharacter = string.sub(message, i-1-batchKeyLength, i-2)
				if settings.BatchKey == "" or batchCharacter then
					table.insert(batchStarts, i)
				end
			end
		end
		for i, bStart in pairs(batchStarts) do
			local bEnd = batchStarts[i+1]
			if bEnd then
				if settings.BatchKey == "" then
					bEnd = bEnd - 2
				else
					bEnd = bEnd - 3 - #settings.BatchKey
				end
			else
				bEnd = #message
			end
			local batch = string.sub(message, bStart, bEnd)
			table.insert(batches, batch)
		end
		
		--Check and execute each batch
		for batchPos, msg in pairs(batches) do
			wait()
			
			--Split message into commandName and arguments
			local args = {}
			msg:gsub('([^'..settings.SplitKey..']+)',function(c) args[#args+1] = string.lower(c) end);
			local commandPrefix, commandName = string.sub(args[1],1,1), string.sub(args[1],2)
			table.remove(args,1)
			
			--Loop commands
			local loops = 1
			local finalArg = tonumber(args[#args])
			if string.sub(commandName,1,4) == "loop" then
				commandName = string.sub(commandName,5)
				if finalArg then
					loops = finalArg
				end
				if loops > 100 or not finalArg then
					loops = 100
				end
			end
			
			-- Check if alias and convert to commandName
			local originalAlias
			local commandNameFromAlias = main.infoOnAllCommands["Aliases"][commandName]
			if commandNameFromAlias then
				originalAlias = commandName
				commandName = string.lower(commandNameFromAlias)
			end
			
			--Check if UnFunction
			local unFunction = false
			if string.sub(commandName,1,2) == "un" then
				local unCommandName = string.sub(commandName,3)
				local unCommandNameFromAlias = main.infoOnAllCommands["Aliases"][unCommandName]
				if unCommandNameFromAlias then
					originalAlias = unCommandName
					unCommandName = string.lower(unCommandNameFromAlias)
				end
				local unCommand = main.validCommands[unCommandName]
				if unCommand and (type(unCommand.UnFunction) == "function" or unCommand.ClientCommand or unCommand.ClientCommandToActivate) then
					unFunction = true
					commandName = unCommandName
					loops = 1
				end
			end
			
			local errorNotice
			local command = main.validCommands[commandName]
			if not command then
				if modules.cf:CheckRankExists(commandName) then
					errorNotice = modules.cf:FormatNotice("ParserInvalidCommandRank", commandName, settings.Prefix, commandName)
				elseif #commandName > 3 then
					errorNotice = modules.cf:FormatNotice("ParserInvalidCommandNormal", commandName)
				end
			else
				if not command.Loopable and loops > 1 then
					loops = 1
				end
				
				--Setup debounces
				local commandDebounceName = commandName
				if command.OriginalName then
					commandDebounceName = command.OriginalName
				end
				if main.functionsInLoop[commandDebounceName] == nil then
					main.functionsInLoop[commandDebounceName] = {}
				end
				
				--Check if using right prefix for the command
				local tryPrefix = speakerData.Prefix
				local tryName = commandName
				if command.Prefixes[1] == main.settings.UniversalPrefix then
					tryPrefix = main.settings.UniversalPrefix
				end
				if commandPrefix ~= speakerData.Prefix and commandPrefix ~= main.settings.UniversalPrefix then
					if originalAlias then
						tryName = originalAlias
					end
					errorNotice = modules.cf:FormatNotice("ParserInvalidPrefix", tryPrefix, tryName)
				
				--Check if VIPServer and using permRank
				elseif game.VIPServerOwnerId ~= 0 and modules.cf:FindValue(settings.VIPServerCommandBlacklist, command.Name) then
					errorNotice = modules.cf:FormatNotice("ParserInvalidVipServer", command.Name)
						
				--Check if Donor command and Speaker has Donor OR rank >= 4
				elseif command.Rank == "Donor" and (not speakerData.Donor or (commandPrefix ~= main.settings.UniversalPrefix and speakerData.Rank < 4)) then
					errorNotice = modules.cf:FormatNotice("ParserInvalidDonor")
					main.signals.ShowPage:FireClient(speaker, {"Special", "Donor"})
						
				--Check if Loop command and Speaker has permission to use
				elseif loops > 1 and speakerData.Rank < loopRank then
					errorNotice = modules.cf:FormatNotice("ParserInvalidLoop")
				
				--Check if speaker has permission to use command
				elseif command.Rank ~= "Donor" and speakerData.Rank < command.Rank then
					errorNotice = modules.cf:FormatNotice("ParserInvalidRank", commandName)
				
				--Check for command block
				elseif not unFunction and main.commandBlocks[speaker] then
					errorNotice = modules.cf:FormatNotice("ParserCommandBlock")
				
				else
									
					--Record in logs
					coroutine.wrap(function()
						local messageToRecord = commandName--msg
						if loops > 1 then
							messageToRecord = "loop"..messageToRecord
						end
						if unFunction then
							messageToRecord = "un"..messageToRecord
						end
						messageToRecord = tryPrefix..messageToRecord
						local restOfMessage = string.sub(msg, #messageToRecord+1)
						restOfMessage = modules.cf:FilterBroadcast(restOfMessage, speaker)
						messageToRecord = messageToRecord.. restOfMessage
						table.insert(main.logs.command, {speakerName = speaker.Name, timeAdded = os.time(), message = messageToRecord})
					end)()
					
					--Process arguments (e.g. rank, color, text, etc)
					local commandArgs = command.Args
					originalAlias = originalAlias or commandName
					args = modules.Arguments:Process(commandArgs, args, commandPrefix, command.Name, speaker, speakerData, originalMessage, originalAlias, batches, batchPos)
					
					
					--Decide how to execute the command (and on which plrs if applicable)
					if commandArgs[1] == "player" and (commandName ~= "directban" or not unFunction) then
						local targetPlayers = modules.Qualifiers:GetTargetPlayers(speaker, args, commandPrefix, command.Prefixes, commandName)
						
						if command.Teleport then
							
							local individual
							if commandName == "bring" then
								individual = speaker
							else
								individual = modules.Qualifiers:GetTargetPlayers(speaker, {args[1]}, commandPrefix, command.Prefixes, commandName, true)
							end
							local targetPlayersTable = {}
							for plr, _ in pairs(targetPlayers) do
								if plr ~= individual then
									table.insert(targetPlayersTable, plr)
								end
							end
							command.Function(speaker, {targetPlayersTable, individual})
							
						else
							local plrChangeInfo = {
								Ranked = {};
								Unranked = {};
							}
							local totalPlrs = 0
							for plr, _ in pairs(targetPlayers) do
								totalPlrs = totalPlrs + 1
							end
							local plrsRemaining = 0
							
							for plr, _ in pairs(targetPlayers) do
								
								--Check Rig
								local humanoid = modules.cf:GetHumanoid(plr)
								local rr = command.RequiresRig
								if humanoid and rr and humanoid.RigType ~= rr then
									local rrName = "R15"
									if rr == Enum.HumanoidRigType.R6 then
										rrName = "R6"
									end
									errorNotice = modules.cf:FormatNotice("ParserInvalidRigType", plr.Name, rrName)
									
								--Check if punished
								elseif command.BlockWhenPunished and modules.cf:IsPunished(plr) then
									errorNotice = modules.cf:FormatNotice("ParserPlrPunished", plr.Name)
								
								else
									local plrData = main.pd[plr]
									
									-- Check for RankLock. If so, is plr's rank greater than speaker's?
									if not command.RankLock or (plrData and speakerData.Rank > plrData.Rank) then
										
										--Only the run command if not already running (and commandDebounce enabled)
										if not commandDebounce or not main.functionsInLoop[commandDebounceName][plr] then
											
											--Add in 'plr' argument to args
											local plrArgs = {plr}
											for i,v in pairs(args) do
												table.insert(plrArgs, v)
											end
											
											coroutine.wrap(function()
												main.functionsInLoop[commandDebounceName][plr] = 0
												plrsRemaining = plrsRemaining + 1
												for i = 1, loops do
													------------------------------------
													local other = {ExtraDetails = extraDetails, UnFunction = unFunction}
													local returnInfo = modules.cf:ExecuteCommand(speaker, plrArgs, command, other)
													------------------------------------
													if returnInfo == "Ranked" or returnInfo == "Unranked" then
														table.insert(plrChangeInfo[returnInfo], plr)
													end
													wait(0.1)
													local humanoid = modules.cf:GetHumanoid(plr)
													if humanoid and humanoid.Health < 1 then					
														plr.CharacterAdded:Wait()
														wait(0.1)
													end
													if plr == nil or not main.functionsInLoop[commandDebounceName][plr] then
														break
													end
												end
												plrsRemaining = plrsRemaining - 1
												main.functionsInLoop[commandDebounceName][plr] = nil
											end)()
										end
										
									elseif totalPlrs <= 1 then
										if commandName == "directban" then
											commandName = "ban"
										end
										modules.cf:FormatAndFireError(speaker, "ParserPlayerRankBlocked", commandName, plr.Name)
										
									end
								end
							end
							spawn(function()
								repeat wait(0.1) until plrsRemaining == 0
								if #plrChangeInfo.Ranked > 0 then
									local targetRankName = modules.cf:GetRankName(args[1])
									local amount = "1 person"
									if #plrChangeInfo.Ranked > 1 then
										amount = #plrChangeInfo.Ranked.." people"
									end
									local notice = modules.cf:FormatNotice("ParserSpeakerRank", command.Name, amount, targetRankName)
									main.signals.Notice:FireClient(speaker, notice)
								end	
								if #plrChangeInfo.Unranked > 0 then
									local amount = "1 person."
									if #plrChangeInfo.Unranked > 1 then
										amount = #plrChangeInfo.Unranked.." people."
									end
									local notice = modules.cf:FormatNotice("ParserSpeakerUnrank", amount)
								end
								--main.playersRanked[speaker] = nil
								--main.playersUnranked[speaker] = nil
							end)
						end
						
					elseif not main.functionsInLoop[commandDebounceName][speaker] or unFunction then
						main.functionsInLoop[commandDebounceName][speaker] = true
						-------------------------------
						local other = {ExtraDetails = extraDetails, UnFunction = unFunction}
						local returnInfo = modules.cf:ExecuteCommand(speaker, args, command, other)
						-------------------------------
						main.functionsInLoop[commandDebounceName][speaker] = nil
						
					end
				
				end
				
			end
			
			--Speaker error message
			if errorNotice then
				main.signals.Error:FireClient(speaker, errorNotice)
			end
			
		end
	
	end
		
end









return module
