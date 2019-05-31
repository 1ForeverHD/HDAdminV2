local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules



-- << LOCAL VARIABLES >>
local requestsLimit = 20
local sanityChecks = {}
local broadcastData = {}
local pollData = {}
local alertData = {}
local pollCount = 0
local topics = {
	DisplayPollResultsToServer = "DisplayPollResultsToServer";
	BeginPoll = "BeginPoll";
	GetAmountOfServers = "GetAmountOfServers";
	GlobalAlert = "GlobalAlert";
}



-- << SETUP >>
--Refresh Sanity Checks
spawn(function()
	while wait(5) do
		sanityChecks = {}
	end
end)

--Setup RemoteFunctions and RemoteEvents
for _, object in pairs(main.signals:GetChildren()) do
	
	--Remove functions
	if object:IsA("RemoteFunction") then
		local rfunction = object
		function rfunction.OnServerInvoke(player,args,...)
			local pdata = main.pd[player]
			if pdata then
				
				--Sanity Checks
				if not sanityChecks[player] then
					sanityChecks[player] = {}
				end
				local requests = sanityChecks[player][rfunction]
				if not requests then
					requests = 1
					sanityChecks[player][rfunction] = requests
				else
					sanityChecks[player][rfunction] = requests + 1
				end
				if requests > requestsLimit then
					modules.cf:FormatAndFireError(player, "RequestsLimit")
					wait(1)
				end
				
				---------------------------------------------
				if rfunction.Name == "RetrieveData" then
					
					if not main.initialized then
						main.signals.Initialized.Event:Wait()
					end
					if not pdata or not pdata.SetupData then
						repeat wait(0.1) pdata = main.pd[player] until (pdata and pdata.SetupData) or not player
					end
					local dataToReturn = {
						["pdata"] = pdata;
						permissions = main.permissions;
						commandInfo = main.commandInfo;
						commandRanks = main.commandRanks;
						infoOnAllCommands = main.infoOnAllCommands;
						settings = {
							Ranks = main.settings.Ranks;
							UniversalPrefix = main.settings.UniversalPrefix;
							Colors = main.settings.Colors;
							ThemeColors = main.settings.ThemeColors;
							Cmdbar = main.settings.Cmdbar;
							Cmdbar2 = main.settings.Cmdbar2;
							ViewBanland = main.settings.ViewBanland;
							DisableAllNotices = main.settings.DisableAllNotices;
							RankRequiredToViewPage = main.settings.RankRequiredToViewPage;
							OnlyShowUsableCommands = main.settings.OnlyShowUsableCommands;
							};
						morphNames = main.morphNames;
						toolNames = main.toolNames;
						ownerName = main.ownerName;
						ownerId = main.ownerId;
						gameName = main.gameName;
						};
					return dataToReturn
				
				
				---------------------------------------------	
				elseif rfunction.Name == "RequestCommand" then
					modules.Parser:ParseMessage(player, args, false, ...)
				
				
				---------------------------------------------
				elseif rfunction.Name == "ChangeSetting" then
					local settingName = args[1]
					local settingValue = main.settings[settingName]
					local newValue = args[2]
					if modules.cf:FindValue(main.validSettings, settingName) then
						if settingName == "Prefix" then
							if #newValue ~= 1 then
								return "Prefix can only be 1 character!"
							elseif newValue == main.settings.UniversalPrefix then
								return "Cannot set to the UniversalPrefix!"
							end
						elseif string.sub(settingName, -7) == "SoundId" and not modules.cf:CheckIfValidSound(newValue) then
							return "Invalid sound!"
						elseif tonumber(settingValue) and not tonumber(newValue) then
							return "Invalid number!"
						end
						modules.PlayerData:ChangeStat(player, settingName, newValue)
						return "Success" 
					end
				
				
				---------------------------------------------	
				elseif rfunction.Name == "RestoreDefaultSettings" then
					local success = "Success"
					for i,v in pairs(main.validSettings) do
						local originalSetting = main.settings[v]
						if originalSetting ~= nil then
							modules.PlayerData:ChangeStat(player, v, originalSetting)
						else
							success = "Error"
						end
					end
					return success
					
					
				---------------------------------------------
				elseif rfunction.Name == "RetrieveServerRanks" then
					local serverRankInfo = {}
					for i, plr in pairs(main.players:GetChildren()) do
						local pdata = main.pd[plr]
						if pdata and pdata.Rank > 0 then
							local rankType = main.rankTypes[modules.cf:GetRankType(plr)]
							table.insert(serverRankInfo, {Player = plr, RankId = pdata.Rank, RankType = rankType})
						end
					end
					return serverRankInfo
					
				
				---------------------------------------------
				elseif rfunction.Name == "RetrieveBanland" then
					local banlandInfo = {{},{}}
					local pdata = main.pd[player]
					if pdata and pdata.Rank >= main.settings.ViewBanland then
						local toScan = {main.serverBans, main.sd.Banland.Records}
						local timeNow = os.time()
						local usersAdded = {}
						for section, records in pairs(toScan) do
							for i, record in pairs(records) do
								local banTime = record.BanTime
								if (not tonumber(banTime) or timeNow < (banTime-30)) and not usersAdded[record.UserId] then
									usersAdded[record.UserId] = true
									table.insert(banlandInfo[section], record)
								end
							end
						end
					end
					return banlandInfo 
					
				
				---------------------------------------------
				elseif rfunction.Name == "RetrieveRanksInfo" then
					
					local permRanksInfo = {}
					local ranks = {}
					local permissions = {}
					local pdata = main.pd[player]
					if pdata and main.sd.PermRanks  then
						
						--PermRanksInfo
						if pdata.Rank >= main.settings.RankRequiredToViewRankType.specificusers or 5 then
							permRanksInfo = main.sd.PermRanks.Records
						end
						
						--Ranks
						for i,v in pairs(main.settings.Ranks) do
							local rankId = v[1]
							if pdata.Rank >= (main.settings.RankRequiredToViewRank[rankId] or 0) then
								table.insert(ranks, v)
							end
						end
						
						--Permissions
						for pName, pDetails in pairs(main.permissions) do
							pName = string.lower(pName)
							local pRank = main.settings.RankRequiredToViewRankType[pName]
							if pdata.Rank >= (pRank or 0) then
								permissions[pName] = pDetails
							end
						end
						
					end
					
					return {
						["PermRanks"] = permRanksInfo;
						["Ranks"] = ranks;
						["Permissions"] = permissions;
					} 
					
				
				---------------------------------------------
				elseif rfunction.Name == "ReplyToPrivateMessage" then
					local targetPlr = args[1]
					local targetPlrPerms = main.permissionToReplyToPrivateMessage[targetPlr]
					if targetPlrPerms and targetPlrPerms[player] then
						main.permissionToReplyToPrivateMessage[targetPlr][player] = nil
						local replyMessage = modules.cf:FilterString(args[2], player, targetPlr)
						modules.cf:PrivateMessage(player, targetPlr, replyMessage)
					end
				
				
				
				---------------------------------------------
				elseif rfunction.Name == "RemovePermRank" then
					if pdata.Rank >= main.settings.RankRequiredToViewRankType.specificusers and pdata.Rank >= main.commandRanks.permrank then
						local userId = args[1]
						local userName = args[2]
						local record = main.sd.PermRanks.Records[modules.cf:FindUserIdInRecord(main.sd.PermRanks.Records, userId)]
						if record then
							record.RemoveRank = true
							modules.SystemData:InsertStat("PermRanks", "RecordsToModify", record)
							modules.cf:FormatAndFireNotice(player, "RemovePermRank", userName)
						end
					end
				
				
				---------------------------------------------
				elseif rfunction.Name == "RetrieveAlertData" then
					if pdata.Rank >= main.commandRanks.globalalert then
						local data = {
							["Title"] = modules.cf:FilterBroadcast(args.Title or "", player),
							["Message"] = modules.cf:FilterBroadcast(args.Message or "", player),
							["Server"] = args.Server,
							["PlayerArg"] = args.PlayerArg
							}
						alertData[player] = data
						return data
					end
				
				
				---------------------------------------------
				elseif rfunction.Name == "ExecuteAlert" then
					local data = alertData[player]
					if data then
						local successMessage = "Alert successful!"
						local server = data.Server
						
						-- << GLOBAL VOTE >>
						if server == "All" then
							successMessage = "Global "..successMessage
							main.messagingService:PublishAsync(topics.GlobalAlert, data)
						
						
						-- << SERVER VOTE >>
						else
							local targetPlayers = modules.Qualifiers:ParseQualifier(data.PlayerArg, player)
							for plr,_ in pairs(targetPlayers) do
								main.signals.CreateAlert:FireClient(plr, {data.Title, data.Message})
							end
							
							
						end
						main.signals.Notice:FireClient(player, {"HD Admin", successMessage})
						alertData[player] = nil
						return true
					end
					modules.cf:FormatAndFireError(player, "AlertFail")
					
				
				---------------------------------------------
				elseif rfunction.Name == "RetrievePollData" then
					if pdata.Rank >= main.commandRanks.vote then
						pollCount = pollCount + 1
						--local server = (type(args.Server) == "boolean" and args.Server) or true
						local voteTime = tonumber(args.VoteTime)
						if not voteTime then
							voteTime = 20
						elseif voteTime > 60 then
							voteTime = 60
						elseif voteTime < 1 then
							voteTime = 1
						end
						local question = modules.cf:FilterBroadcast(args.Question or "", player)
						local answers = {}
						for i, answer in pairs(args.Answers) do
							if i > 10 then
								break
							end
							table.insert(answers, modules.cf:FilterBroadcast(answer or "", player))
						end
						if #answers < 1 then
							return "Must have at least 1 answer!"
						end
						local senderId = player.UserId
						local senderName = player.Name
						local data = {
							["VoteTime"] = voteTime,
							["Question"] = question,
							["Answers"] = answers,
							["Server"] = args.Server,
							["ShowResultsTo"] = args.ShowResultsTo,
							["PlayerArg"] = args.PlayerArg,
							["SenderName"] = player.Name,
							["PollId"] = pollCount
							}
						pollData[player] = data
						return data
					end
				
				
				---------------------------------------------
				elseif rfunction.Name == "ExecutePoll" then
					local data = pollData[player]
					if data then
						local successMessage = "Poll successful! The results will appear shortly."
						local server = data.Server
						
						-- << GLOBAL VOTE >>
						if server == "All" then
							if pdata.Rank >= main.commandRanks.globalvote then
								spawn(function()
									successMessage = "Global "..successMessage
									
									--Setup topic and SubscribeAsync
									local scores = {}
									for i = 1, #data.Answers+1 do
										table.insert(scores, 0)
									end
									local uniquePollTopic = "Poll"..data.PollId
									data.UniquePollTopic = uniquePollTopic
									local serversResponded = 0
									local subFunc = main.messagingService:SubscribeAsync(uniquePollTopic, function(message)
										local serverScores = message.Data
										for i,v in pairs(serverScores) do
											scores[i] = scores[i] + v
										end
										serversResponded = serversResponded + 1
									end)
									
									--Begin polls for all servers
									main.messagingService:PublishAsync(topics.BeginPoll, data)
									local totalServers = modules.cf:GetAmountOfServers()
									for i = 1, data.VoteTime+2 do
										wait(1)
										if serversResponded >= totalServers then
											break
										end
									end
									subFunc:Disconnect()
									
									--Calculate results
									local highestScore = 0
									for i,v in pairs(scores) do
										if v > highestScore then
											highestScore = v
										end
									end
									data.Results = {}
									for i = 1, #data.Answers+1 do
										local answer = data.Answers[i]
										local answerVotes = scores[i]
										table.insert(data.Results, {
												Answer = answer or "Did Not Vote";
												Votes = answerVotes;
												Percentage = answerVotes/highestScore;
											}
										)
									end
									
									--Display results
									if data.ShowResultsTo == "You" then
										modules.cf:DisplayPollResults(player, data)
									else
										main.messagingService:PublishAsync(topics.DisplayPollResultsToServer, data)
									end
								end)
								
							end
						
						
						-- << SERVER VOTE >>
						elseif pdata.Rank >= main.commandRanks.vote then
							spawn(function()
								--Get participants
								local targetPlayers = modules.Qualifiers:ParseQualifier(data.PlayerArg, player)
								local participants = {}
								for plr,_ in pairs(targetPlayers) do
									table.insert(participants, plr)
								end
								
								--Setup poll and retrieve data
								local newData = modules.cf:BeginPoll(data, participants)
								
								--Display results
								local showResultsToTable = participants
								if data.ShowResultsTo == "You" then
									showResultsToTable = {player}
								end
								for i, plr in pairs(showResultsToTable) do
									modules.cf:DisplayPollResults(plr, data)
								end
							end)
							
							
						else
							return false
						end
						pollData[player] = nil
						main.signals.Notice:FireClient(player, {"HD Admin", successMessage})
						return true
					end
					modules.cf:FormatAndFireError(player, "PollFail")
					
				---------------------------------------------
				elseif rfunction.Name == "RetrieveBroadcastData" then
					if pdata.Rank >= main.commandRanks.globalannouncement then
						local title = args.Title
						local displayFrom = args.DisplayFrom
						local color = args.Color
						local message = args.Message
						if title ~= "Global Announcement" then
							title = modules.cf:FilterBroadcast(title, player)
						end
						if type(displayFrom) ~= "boolean" then
							displayFrom = true
						end
						color = modules.cf:GetColorFromString(color:match("%a+"))
						if not color then
							color = Color3.fromRGB(255,255,255)
						end
						color = {color.r, color.g, color.b}
						message = modules.cf:FilterBroadcast(message, player)
						local senderId = player.UserId
						local senderName = player.Name
						local data = {
							["Title"] = title,
							["DisplayFrom"] = displayFrom,
							["Color"] = color,
							["Message"] = message,
							["SenderId"] = player.UserId,
							["SenderName"] = player.Name
							}
						broadcastData[player] = data
						return data
					end --RetrievePollData
				
				
				---------------------------------------------
				elseif rfunction.Name == "ExecuteBroadcast" then
					if pdata.Rank >= main.commandRanks.globalannouncement then
						local data = broadcastData[player]
						if data then
							modules.SystemData:ChangeStat("Broadcast", "BroadcastData", data)
							modules.SystemData:ChangeStat("Broadcast", "BroadcastTime", os.time())
							modules.SystemData:ChangeStat("Broadcast", "BroadcastId", math.random(1,10000000))
							modules.cf:FormatAndFireNotice(player, "BroadcastSuccessful")
							broadcastData[player] = nil
							return true
						end
					end
					modules.cf:FormatAndFireNotice(player, "BroadcastFailed")
					
				---------------------------------------------
				end
			end
		end
			
		
		
		
		
		
		
		
		
		
		
		
		
	--Remote events
	elseif object:IsA("RemoteEvent") then
		local revent = object
		local firingToFast = {}
		local validCommands = {"laserEyes"}
		revent.OnServerEvent:Connect(function(player, commandName, args)
			local pdata = main.pd[player]
			if pdata and not firingToFast[player] and modules.cf:FindValue(validCommands, commandName) then
				firingToFast[player] = true
				---------------------------------------------
				if revent.Name == "UpdateNearbyPlayers" then
					for i, plr in pairs(main.players:GetChildren()) do
						local plrHead = modules.cf:GetHead(plr)
						if plr ~= player and plrHead and player:DistanceFromCharacter(plrHead.Position) <= 100 then
							main.signals.ExecuteClientCommand:FireClient(plr, {player, args, commandName, {}})
						end
					end
				end
				---------------------------------------------
				wait(0.5)
				firingToFast[player] = nil
			end
		end)
	end
	
end



-- << MESSAGING SERVICE >>
local testSub
if pcall(function() testSub = main.messagingService:SubscribeAsync("TestSub", function() end) end) then
	testSub:Disconnect()
	for _, topicName in pairs(topics) do
		main.messagingService:SubscribeAsync(topicName, function(message)
			local data = message.Data
			
			if topicName == "BeginPoll" then
				local newData, scores = modules.cf:BeginPoll(data)
				main.messagingService:PublishAsync(data.UniquePollTopic, scores)
				
			elseif topicName == "DisplayPollResultsToServer" then
				for i, plr in pairs(main.players:GetChildren()) do
					modules.cf:DisplayPollResults(plr, data)
				end	
			
			elseif topicName == "GetAmountOfServers" then
				local topicName = data
				main.messagingService:PublishAsync(topicName)
			
			elseif topicName == "GlobalAlert" then
				for i,plr in pairs(main.players:GetChildren()) do
					main.signals.CreateAlert:FireClient(plr, {data.Title, data.Message})
				end
				
			end
		end)
	end
end



return module
