-- !! Referenced using 'main.modules.cf'

local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = require(game:GetService("ReplicatedStorage").HDAdminContainer.SharedModules.MainFramework) local modules = main.modules



-- << FUNCTIONS >>
function module:ExecuteCommand(speaker, args, command, other)
	other = other or {}
	local returnInfo
	local extraDetails = other.ExtraDetails
	extraDetails = extraDetails or {}
	local unFunction = other.UnFunction
	local clientCommand = command.ClientCommand
	local clientCommandToActivate = command.ClientCommandToActivate
	local commandName = command.Name
	
	--Decide if Undo or Normal function
	local functionTypes = {Function = "Function", PreFunction = "PreFunction"}
	if unFunction then
		for funcType, value in pairs(functionTypes) do
			functionTypes[funcType] = "Un"..value
		end
	end
	
	--Check for PreFunctions
	local PreFunction = command[functionTypes.PreFunction]
	if PreFunction then
		local newArgs, newExtraDetails = PreFunction(speaker, args, command, extraDetails)
		args = newArgs or args
		extraDetails = newExtraDetails or extraDetails
	end
	
	--Client Commands
	local plrToFireTo = speaker
	local checkForPlr = args[1]
	if checkForPlr and type(checkForPlr) == "userdata" and checkForPlr.Parent == main.players and not command.FireToSpeaker then
		plrToFireTo = checkForPlr
	end
	if clientCommand then
		if command.FireAllClients then
			main.network.ExecuteClientCommand:FireAllClients{speaker, args, command.Name, other}
		else
			main.network.ExecuteClientCommand:FireClient(plrToFireTo, {speaker, args, command.Name, other})
		end
	elseif clientCommandToActivate then
		if unFunction then
			main.pd[plrToFireTo].CommandsActive[commandName] = nil
			main.network.DeactivateClientCommand:FireClient(plrToFireTo, {commandName})
		else
			extraDetails.Speed = tonumber(args[2])
			main.pd[plrToFireTo].CommandsActive[commandName] = true
			main.network.ActivateClientCommand:FireClient(plrToFireTo, {commandName, extraDetails})
		end
	end
	
	--Execute Command Function
	local Function = command[functionTypes.Function]
	if Function then
		returnInfo = Function(speaker, args, command, extraDetails)
	end
	
	return returnInfo
end

function module:FormatAndFireError2(plr, noticeName, extraDetails, ...)
	local notice = modules.cf:FormatNotice2(noticeName, extraDetails, ...)
	main.network.Error:FireClient(plr, notice)
end

function module:FormatAndFireError(plr, noticeName, ...)
	local notice = modules.cf:FormatNotice(noticeName, ...)
	main.network.Error:FireClient(plr, notice)
end

function module:FormatAndFireNotice2(plr, noticeName, extraDetails, ...)
	local notice = modules.cf:FormatNotice2(noticeName, extraDetails, ...)
	main.network.Notice:FireClient(plr, notice)
end

function module:FormatAndFireNotice(plr, noticeName, ...)
	local notice = modules.cf:FormatNotice(noticeName, ...)
	main.network.Notice:FireClient(plr, notice)
end

function module:GetAmountOfServers()
	local topicId = "GetServers".. math.random(1,100000)
	local totalServers = 0
	local subFunc = main.messagingService:SubscribeAsync(topicId, function(message)
		totalServers = totalServers + 1
	end)
	main.messagingService:PublishAsync("GetAmountOfServers", topicId)
	wait(0.5)
	subFunc:Disconnect()
	return totalServers
end

function module:DisplayPollResults(plr, data)
	main.network.CreateMenu:FireClient(plr, {MenuName = "pollResults", Data = data, TemplateId = 11})
end
function module:BeginPoll(data, participants)
	if participants == nil then
		participants = {}
		for i,plr in pairs(main.players:GetChildren()) do
			table.insert(participants, plr)
		end
	end
	
	local validPlayers = {}
	local votes = {}
	local totalParticipants = #participants
	
	--Setup remote
	local remote = Instance.new("RemoteEvent")
	remote.Name = "HDAdminPoll"..data.PollId
	remote.OnServerEvent:Connect(function(plr, answerId)
		if validPlayers[plr] then
			votes[plr] = answerId
		end
	end)
	remote.Parent = workspace
	data.Remote = remote
	
	--Vote players
	for i, plr in pairs(participants) do
		validPlayers[plr] = true
		main.network.CreateMenu:FireClient(plr, {MenuName = "poll", Data = data, TemplateId = 10})
	end
	for i = 1, (data.VoteTime + 1) do
		wait(1)
		local totalVotes = 0
		for plr, answerId in pairs(votes) do
			totalVotes = totalVotes + 1
		end
		if totalVotes >= totalParticipants then
			break
		end
	end
	
	--Calculate results
	local scores = {}
	for i = 1, #data.Answers do
		table.insert(scores, 0)
	end
	data.Results = {}
	local totalVotes = 0
	local highestScore = 0
	for plr, answerId in pairs(votes) do
		local score = scores[answerId] + 1
		if score > highestScore then
			highestScore = score
		end
		scores[answerId] = score
		totalVotes = totalVotes + 1
	end
	local didNotVote = totalParticipants - totalVotes
	if didNotVote > highestScore then
		highestScore = didNotVote
	end
	for i,answer in pairs(data.Answers) do
		local answerVotes = scores[i]
		table.insert(data.Results, {
				Answer = answer;
				Votes = answerVotes;
				Percentage = answerVotes/highestScore;
			}
		)
	end
	table.insert(scores, didNotVote)
	table.insert(data.Results, {
		Answer = "Did Not Vote";
		Votes = didNotVote;
		Percentage = didNotVote/highestScore;
	})
	
	--Clean up
	remote:Destroy()
	
	--Return data
	return data, scores
		
end

function module:GetBannedUserDetails(plrArg)
	local targetName, targetId, targetReason
	local toScan = {main.serverBans, main.sd.Banland.Records}
	local timeNow = os.time()
	for section, records in pairs(toScan) do
		for i, record in pairs(records) do
			local banTime = record.BanTime
			if not tonumber(banTime) or timeNow < (banTime-30) then
				local userName = modules.cf:GetName(record.UserId)
				if string.sub(string.lower(userName), 1, #plrArg) == plrArg then
					return {userName, record.UserId, record.Reason, record.BannedBy}, record
				end
			end
		end
	end
end

function module:BanPlayer(plr, record)
	--Check if ban expired
	local banTime = record.BanTime
	if tonumber(banTime) and os.time() > (banTime-30) then
		local server = record.Server
		if server == "Current" then
			local recordToRemovePos = modules.cf:FindUserIdInRecord(main.serverBans, record.UserId)
			if recordToRemovePos then
				table.remove(main.serverBans, recordToRemovePos)
			end
		else
			modules.SystemData:InsertStat("Banland", "RecordsToRemove", record)
		end
	-- Ban player
	else
		local untilString = "."
		local banDateString = "Ban Length: Infinite"
		if record.BanTime ~= "Infinite" then
			local banTime = record.BanTime
			local serverDate = os.date("*t", banTime)
			local date
			coroutine.wrap(function()
				local success, clientDate = pcall(function() return main.network.GetLocalDate:InvokeClient(plr, banTime) end)
				if success then
					date = clientDate
				else
					return
				end
			end)()
			local startTick = tick()
			repeat wait(0.1) until date or tick() - startTick > 2
			if type(date) ~= "table" then
				date = {}
			end
			banDateString = modules.cf:GetBanDateString(date, serverDate)
			untilString = ", until:"
		end
		local serverType = "all servers"
		if record.Server == "Current" then
			serverType = "this server"
		end
		local reason = record.Reason
		if reason == "" or reason == " " then
			reason = "Empty"
		else
			reason = "'".. reason.."'"
		end
		local finalBanMessage = "You're banned from "..serverType..untilString.." \n\n"..banDateString.."\n\nReason: ".. reason.."\n"
		plr:Kick(finalBanMessage)
	end
end

function module:FindUserIdInRecord(records, userId)
	for i,record in pairs(records) do
		if tostring(record["UserId"]) == tostring(userId) then
			return i
		end
	end
	return false
end

function module:GetLog(logName)
	local log = {}
	for _,record in pairs(main.logs[logName]) do
		local newRecord = {}
		for detailName, detail in pairs(record) do
			newRecord[detailName] = detail
		end
		table.insert(log, 1, newRecord)
	end
	return log
end

function module:PrivateMessage(sender, targetPlr, message)
	local senderPerms = main.permissionToReplyToPrivateMessage[sender]
	if senderPerms == nil then
		main.permissionToReplyToPrivateMessage[sender] = {}
	end
	main.permissionToReplyToPrivateMessage[sender][targetPlr] = true
	modules.cf:FormatAndFireNotice2(targetPlr, "ReceivedPM", {"PM", sender, message}, sender.Name)
end

function module:GetStat(plr, statName)
	if statName then
		local leaderstats = plr:FindFirstChild("leaderstats")
		if leaderstats then
			local stat = leaderstats:FindFirstChild(statName)
			if stat then
				return stat
			end
		end
	end
end

function module:GetColorFromString(argToProcess)
	local finalColor
	if argToProcess then
		argToProcess = string.lower(argToProcess)
		for i, colorInfo in pairs(main.settings.Colors) do
			local shortName = string.lower(colorInfo[1])
			if (argToProcess == shortName) then
				finalColor = colorInfo[3]
				break
			end
		end
		if not finalColor then
			for i, colorInfo in pairs(main.settings.Colors) do
				local fullName = string.lower(colorInfo[2])
				if (argToProcess == string.sub(fullName,1,#argToProcess)) then
					finalColor = colorInfo[3]
					break
				end
			end
		end
	end
	return finalColor
end

function module:RemoveControlPlr(controller)
	if controller and main.pd[controller] then
		local controlPlr = main.pd[controller].Items["ControlPlr"]
		if controlPlr then
			local originalCFrame = controlPlr.FakePlayer.Head.CFrame
			controlPlr:Destroy()
			main.pd[controller].Items["ControlPlr"] = nil
			modules.MorphHandler:BecomeTargetPlayer(controller, controller.UserId)
			local controllerHead = modules.cf:GetHead(controller)
			local fakeName = modules.cf:GetFakeName(controller)
			if controllerHead and fakeName then
				fakeName:Destroy()
				controllerHead.Transparency = 0
				controllerHead.CFrame = originalCFrame
			end
		end
	end
end

function module:RemoveUnderControl(plr)
	local underControl = main.pd[plr].Items["UnderControl"]
	if underControl then
		underControl:Destroy()
		main.pd[plr].Items["UnderControl"] = nil
		local plrHumanoid = modules.cf:GetHumanoid(plr)
		if plrHumanoid then
			main.network.ChangeCameraSubject:FireClient(plr, (plrHumanoid))
			--modules.cf:SetTransparency(plr.Character, 0, true)
			--modules.cf:Movement(true, plr)
			plr.Character.Parent = workspace
		end
	end
end

function module:TeleportPlayers(plrsToTeleport, targetPlr)
	local targetHead = modules.cf:GetHead(targetPlr)
	if targetHead then
		local totalPlrs = #plrsToTeleport
		local gap = 2
		for i,plr in pairs(plrsToTeleport) do
			local head = modules.cf:GetHead(plr)
			local targetCFrame = targetHead.CFrame * CFrame.new(-(totalPlrs*(gap/2))+(i*gap)-(gap/2), 0, -4) * CFrame.Angles(0, math.rad(180), 0)
			if head then
				modules.cf:UnSeatPlayer(plr)
				head.CFrame = targetCFrame
			end
		end
	end
end

function module:ConvertCharacterToRig(plr, rigType)
	--
	local humanoid = modules.cf:GetHumanoid(plr)
	local head = modules.cf:GetHead(plr)
	if humanoid and head then
		local newRig = main.assets["Rig"..rigType]:Clone()
		local newHumanoid = newRig.Humanoid
		local originalCFrame = head.CFrame
		newRig.Name = plr.Name
		for a,b in pairs(plr.Character:GetChildren()) do
			if b:IsA("Accessory") or b:IsA("Pants") or b:IsA("Shirt") or b:IsA("ShirtGraphic") or b:IsA("BodyColors") then
				b.Parent = newRig
			elseif b.Name == "Head" and b:FindFirstChild("face") then
				newRig.Head.face.Texture = b.face.Texture
			end
		end
		plr.Character = newRig
		newRig.Parent = workspace
		newRig.Head.CFrame = originalCFrame
		--local desc = main.players:GetHumanoidDescriptionFromUserId(plr.UserId)
		--newHumanoid:ApplyDescription(desc)
	end
	--
end

function module:GetFakeName(plr)
	for a,b in pairs(plr.Character:GetChildren()) do
		if b:IsA("Model") and b:FindFirstChild("FakeHumanoid") then
			return b
		end
	end
end

function module:CreateFakeName(plr, name)
	local head = modules.cf:GetHead(plr)
	if head then
		local fakeName = module:GetFakeName(plr)
		if not fakeName then
			fakeName = Instance.new("Model")
			local fakeHead = head:Clone()
			fakeHead.Name = "Head"
			fakeHead.Parent = fakeName
			fakeHead.face.Transparency = 1
			local weld = Instance.new("WeldConstraint")
			weld.Part0 = fakeHead
			weld.Part1 = head
			weld.Parent = fakeHead
			local fakeHumanoid = Instance.new("Humanoid")
			fakeHumanoid.Name = "FakeHumanoid"
			fakeHumanoid.Parent = fakeName
			fakeName.Parent = plr.Character
			head.Transparency = 1
		end
		if name then
			fakeName.Name = name
		end
	end
end

function module:RemoveEffect(plr, effectType)
	local effectName = "HDAdmin"..effectType
	if plr.Character then
		for a,b in pairs(plr.Character:GetDescendants()) do
			if b.Name == effectName then
				b:Destroy()
				break
			end
		end
	end
end

function module:CreateEffect(plr, effectType)
	local hrp = modules.cf:GetHRP(plr)
	local targetParent = hrp
	if effectType == "ForceField" then
		targetParent = plr.Character
	end
	if hrp then
		local effectName = "HDAdmin"..effectType
		local effect = targetParent:FindFirstChild(effectName)
		if not effect then
			effect = Instance.new(effectType)
			effect.Name = effectName
			effect.Parent = targetParent
		end
	end
end

function module:UnFreeze(args)
	local plr = args[1]
	local itemName = "FreezeBlock"
	local item = main.pd[plr].Items[itemName]
	if item then
		main.pd[plr].Items[itemName] = nil
		modules.cf:Movement(true, plr)
		modules.cf:SetTransparency(plr.Character, 0)
		local head = modules.cf:GetHead(plr)
		if head then
			head.CFrame = item.FreezeClone.Head.CFrame
		end
		local humanoid = modules.cf:GetHumanoid(plr)
		if humanoid then
			main.network.ChangeCameraSubject:FireClient(plr, (humanoid))
		end
		item:Destroy()
	end
end

function module:FilterString(text, fromPlayer, playerTo)
	local filteredText = ""
	local success, message = pcall(function()
		filteredText = main.chat:FilterStringAsync(text, fromPlayer, playerTo)
	end)
	if not success then
		filteredText = "####"
	end
	return filteredText
end

function module:FilterBroadcast(text, fromPlayer)
	local filteredText = ""
	local success, message = pcall(function()
		filteredText = main.chat:FilterStringForBroadcast(text, fromPlayer)
	end)
	if not success then
		filteredText = "####"
	end
	return filteredText
end

function module:DonorNotice(player, pdata)
	if not pdata.PromptedDonor then
		modules.PlayerData:ChangeStat(player, "PromptedDonor", true)
		modules.cf:FormatAndFireNotice(player, "WelcomeDonor")
	end
end

function module:CheckAndRankToDonor(player, pdata, gamepassId)
	gamepassId = tostring(gamepassId)
	if not pdata.Donor and (gamepassId == tostring(main.products.Donor) or gamepassId == tostring(main.products.OldDonor)) then
		modules.PlayerData:ChangeStat(player, "Donor", true)
		module:DonorNotice(player, pdata)
	end
end

function module:Unrank(plr)
	modules.PlayerData:ChangeStat(plr, "Rank", 0)
	main.serverAdmins[plr.Name] = nil
	modules.PlayerData:ChangeStat(plr, "SaveRank", false)
	modules.cf:FormatAndFireNotice(plr, "UnRank")
	return("Unranked")
end

function module:GetRankType(plr)
	local rankType = "Server"
	local pdata = main.pd[plr]
	if pdata then
		if pdata.AutomaticRank then
			rankType ="Auto"
		elseif pdata.SaveRank == true then
			rankType = "Perm"
		elseif main.serverAdmins[plr.Name] == nil then
			rankType = "Temp"
		end
	end
	return rankType
end

function module:SetRank(plr, speakerUserId, rankId, rankType)
	modules.PlayerData:ChangeStat(plr, "Rank", rankId)
	modules.PlayerData:ChangeStat(plr, "AutomaticRank", false)
	local stringRankType = "rank"
	if rankType == "Server" then
		main.serverAdmins[plr.Name] = true
	elseif rankType == "Perm" then
		modules.PlayerData:ChangeStat(plr, "PermRankedBy", speakerUserId)
		modules.PlayerData:ChangeStat(plr, "SaveRank", true)
		main.serverAdmins[plr.Name] = nil
		stringRankType = "permRank"
	elseif rankType == "Temp" then
		main.serverAdmins[plr.Name] = nil
		stringRankType = "tempRank"
	end
	local targetRankName = modules.cf:GetRankName(rankId)
	modules.cf:FormatAndFireNotice(plr, "SetRank", stringRankType, targetRankName)
end

function module:RankPlayerCommand(speaker, args, commandRankType)
	local plr = args[1]
	local targetRankId = args[2]
	local plrRank = main.pd[plr].Rank
	local speakerRank = main.pd[speaker].Rank
	if targetRankId == 0 then
		module:Unrank(plr)
		return("Unranked")
	elseif speakerRank > targetRankId then
		module:SetRank(plr, speaker.UserId, targetRankId, commandRankType)
		return("Ranked")
	end
end

function module:RankPlayerSimple(player, newRank, automaticRank)
	local pdata = main.pd[player]
	if tonumber(newRank) == nil then
		newRank = modules.cf:GetRankId(newRank)
	end
	if pdata.Rank <= newRank then
		if automaticRank then
			modules.PlayerData:ChangeStat(player, "AutomaticRank", newRank)
		end
		if pdata.Rank < newRank then
			modules.PlayerData:ChangeStat(player, "Rank", newRank)
		end
	end
end

function module:SetupCommands(commandsModule, customCommands)
	local commandsToAdd = require(commandsModule)
	for i, command in pairs(commandsToAdd) do
		if type(command) == "table" then
			--ChangeRankRequiredToUseCommand
			local commandName = string.lower(command.Name)
			local changeRank = main.settings.ChangeRankRequiredToUseCommand[command.Name] or main.settings.ChangeRankRequiredToUseCommand[commandName]
			if changeRank then
				if tonumber(changeRank) == nil then
					changeRank = modules.cf:GetRankId(changeRank)
				end
				command.Rank = changeRank
			elseif commandName == "cmdbar" or commandName == "cmdbar2"  then
				local settingName = commandName:gsub("^%a", function(c) return(string.upper(c)) end)
				local setting = main.settings[settingName]
				if setting then
					if tonumber(setting) == nil then
						setting = modules.cf:GetRankId(setting)
					end
					command.Rank = setting
					main.settings[settingName] = setting
				end
			end
			--
			if commandName ~= "" then
				local function getCommandTables()
					local template, modified = {},{}
					for dataName, data in pairs(command) do
						if modules.cf:FindValue(main.commandInfoToShowOnClient, dataName) then
							template[dataName] = data
						elseif dataName == "UnFunction" and type(data) == "function" then
							template["UnFunction"] = "un".. string.gsub(command.Name, "%a", function(c) return string.upper(c) end, 1)
						end
						modified[dataName] = data 
					end
					--
					local lowerCaseArgs = {}
					if command.Args then
						for i,v in pairs(command.Args) do
							table.insert(lowerCaseArgs, string.lower(v))
						end
					end
					template.RankName = modules.cf:GetRankName(command.Rank)
					template.Args = lowerCaseArgs
					modified.Args = lowerCaseArgs
					--
					return template, modified	
				end
				local infoTemplate, modifiedCommand = getCommandTables()
				table.insert(main.commandInfo, infoTemplate)
				main.validCommands[commandName] = modifiedCommand
				--Special Colors
				if command.SpecialColors then
					for i,v in pairs(main.settings.Colors) do
						local shortName = v[1]
						if shortName ~= "w" then
							local newTemplate, newModifiedCommand = getCommandTables()
							local commandColorName = command.Name..shortName
							local color = v[3]
							newTemplate.SpecialColor = color
							newTemplate.SpecialColorName = shortName
							newTemplate.OriginalName = command.Name
							newTemplate.Name = commandColorName
							newModifiedCommand.SpecialColor = color
							newModifiedCommand.Name = commandColorName
							newModifiedCommand.OriginalName = command.Name
							table.insert(main.commandInfo, newTemplate)
							main.validCommands[commandColorName] = newModifiedCommand
						end
					end
				end
				--
				for infoName, infoTable in pairs(main.infoOnAllCommands) do
					local commandStat = command[infoName]
					if type(commandStat) == "table" then
						for i,v in pairs(commandStat) do
							if infoName ~= "Contributors" then
								v = string.lower(v)
							end
							if infoName == "Contributors" or infoName == "Tags" then
								if infoName == "Contributors" and tonumber(v) then
									v = main.modules.cf:GetName(v)
								end
								local statCount = main.infoOnAllCommands[infoName][v]
								if statCount == nil then
									if infoName ~= "Contributors" or not customCommands then
										main.infoOnAllCommands[infoName][v] = 1
									end
								else
									main.infoOnAllCommands[infoName][v] = statCount + 1
								end
							elseif infoName == "Aliases" then
								main.infoOnAllCommands[infoName][v] = commandName
							else
								main.infoOnAllCommands[infoName][v] = true
							end
						end
					end
				end
				main.commandRanks[commandName] = command.Rank
			end
		end
	end
end



return module
