local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules
local commandInfoForClient = {"Contributors", "Prefixes", "Rank", "Aliases", "Tags", "Description", "Args", "Loopable"}



function module:Setup()
	
	--Grab all tools
	local locationsToScan = {main.lighting, main.rs, main.ss, main.starterPack}
	for _, l in pairs(locationsToScan) do
		for a,b in pairs(l:GetDescendants()) do
			if b:IsA("Tool") and b.Parent.Name ~= "BuildingTools" then
				table.insert(main.listOfTools, b)
			end
		end
	end
					
	--Setup morphNames and toolNames
	for _, morph in pairs(main.server.Morphs:GetChildren()) do
		main.morphNames[tostring(morph.Name)] = true
	end
	for _, tool in pairs(main.listOfTools) do
		main.toolNames[tostring(tool.Name)] = true
	end
	
	--
	local newRankRequiredToViewRankType = {}
	for subSettingName, rankId in pairs(main.settings.RankRequiredToViewRankType) do
		subSettingName = string.lower(subSettingName)
		newRankRequiredToViewRankType[subSettingName] = rankId
	end
	main.settings.RankRequiredToViewRankType = newRankRequiredToViewRankType
	--
	local newRankRequiredToViewRank = {}
	for subSettingName, rankId in pairs(main.settings.RankRequiredToViewRank) do
		subSettingName = tonumber(subSettingName) or modules.cf:GetRankId(subSettingName)
		newRankRequiredToViewRank[subSettingName] = rankId
	end
	main.settings.RankRequiredToViewRank = newRankRequiredToViewRank
	--
	for settingName, details in pairs(main.settings) do
		if settingName == "BatchKey" then
			main.settings.BatchKey = tostring(details)
			
		elseif settingName == "ChatColors" then
			local newSetting = {}
			for rank, color in pairs(details) do
				local chatRankId = rank
				local chatColor3 = color
				if not tonumber(rank) then
					chatRankId = modules.cf:GetRankId(rank)
				end
				if type(color) ~= "userdata" then
					chatColor3 = modules.cf:GetColorFromString(color)
				end
				newSetting[chatRankId] = chatColor3
			end
			main.settings.ChatColors = newSetting
			
		elseif settingName == "CoreNotices" then
			for noticeName, notice in pairs(details) do
				modules.CoreNotices[noticeName] = notice
			end
			
		elseif settingName == "IgnoreScaleLimit" or settingName == "ViewBanland" or settingName == "IgnoreGearBlacklist" then
			if tonumber(details) == nil then
				main.settings[settingName] = modules.cf:GetRankId(details)
			end
		
		elseif settingName == "RankRequiredToViewPage" or settingName == "RankRequiredToViewRank" or settingName == "RankRequiredToViewRankType" then
			for subSettingName, rankId in pairs(details) do
				if tonumber(rankId) == nil then
					main.settings[settingName][subSettingName] = modules.cf:GetRankId(rankId)
				end
			end
			
		elseif settingName == "Banned" then
			for i,v in pairs(details) do
				local plrId = tonumber(v)
				if not plrId then
					plrId = modules.cf:GetUserId(v)
				end
				main.banned[tostring(plrId)] = true
			end
			
		elseif settingName == "VIPServerCommandBlacklist" then
			if type(details) ~= "table" then
				main.settings[settingName] = {}
			end
			
		elseif settingName == "NoticeSoundId" or settingName == "ErrorSoundId" then
			if details == 261082034 then -- Notice
				main.settings[settingName] = 2865227271
				main.settings.NoticeVolume = 0.1
			elseif details == 138090596 then -- Error
				main.settings[settingName] = 2865228021
				main.settings.ErrorVolume = 0.1
			end
			
		elseif settingName == "Ranks" then
			for _, rankDetails in pairs(details) do
				local rankId = rankDetails[1]
				local rankName = rankDetails[2]
				local specificUsers = rankDetails[3]
				if rankId > 5 then
					rankId = 5
				elseif rankId < 0 then
					rankId = 0
				end
				if specificUsers == nil or rankId == 5 or rankId == 0 then
					specificUsers = {}
				end
				for i,plrName in pairs(specificUsers) do
					if tonumber(plrName) then
						plrName = modules.cf:GetName(plrName)
					end
					main.permissions.specificUsers[plrName] = rankId
				end
			end
				
		elseif settingName == "Gamepasses" then
			for productName, productId in pairs(main.products) do
				details[productId] = productName
			end
			for gamepassId, rankId in pairs(details) do
				gamepassId = tonumber(gamepassId)
				if gamepassId and gamepassId > 0 then
					local success, productInfo = pcall(function() return(modules.cf:GetProductInfo(gamepassId, Enum.InfoType.GamePass)) end)
					if not success or not productInfo.Name then
						warn("HD Admin | You entered an invalid GamepassId: ".. tostring(gamepassId))
					else
						if gamepassId and gamepassId > 0 then
							if tonumber(rankId) == nil then
								rankId = modules.cf:GetRankId(rankId)
							end
							if gamepassId then
								productInfo.Rank = rankId
								main.permissions.gamepasses[tostring(gamepassId)] = productInfo
							end
						end
					end
				end
			end
		
		elseif settingName == "Assets" then
			for assetId, rankId in pairs(details) do
				assetId = tonumber(assetId)
				if assetId and assetId > 0 then
					local success, productInfo = pcall(function() return(modules.cf:GetProductInfo(assetId, Enum.InfoType.Asset)) end)
					if not success or not productInfo.Name then
						warn("HD Admin | You entered an invalid AssetId: ".. tostring(assetId))
					else
						if tonumber(rankId) == nil then
							rankId = modules.cf:GetRankId(rankId)
						end
						if assetId then
							productInfo.Rank = rankId
							main.permissions.assets[tostring(assetId)] = productInfo
						end
					end
				end
			end
			
		elseif settingName == "Groups" then
			for groupId, groupDetails in pairs(details) do
				groupId = tonumber(groupId)
				if groupId and groupId > 0 then
					local success, groupInfo = pcall(function() return(main.groupService:GetGroupInfoAsync(groupId)) end)
					if not success then
						warn("HD Admin | You entered an invalid GroupId: ".. tostring(groupId))
					else
						local roles = groupInfo.Roles
						if roles then
							local newRoles = {}
							for _, roleDetails in pairs(roles) do
								newRoles[roleDetails.Name] = {}
								newRoles[roleDetails.Name].GroupRank = roleDetails.Rank
							end
							groupInfo.Roles = newRoles
							for roleName, rankId in pairs(groupDetails) do
								if tonumber(roleName) then
									for rN, roleDetails in pairs(newRoles) do
										if roleDetails.GroupRank == roleName then
											roleName = rN
										end
									end
								end
								if tonumber(rankId) == nil then
									rankId = modules.cf:GetRankId(rankId)
								end
								if groupInfo.Roles[roleName] then
									groupInfo.Roles[roleName].Rank = rankId
								else
									--warn("HD Admin: Entered incorrect role Name/ID. That role does not exists.")
								end
							end
						end
						main.permissions.groups[tostring(groupId)] = groupInfo
					end
				end
			end
			
		elseif settingName == "Friends" or settingName == "FreeAdmin" or settingName == "VipServerOwner" or settingName == "VipServerPlayers" then
			local rankId = details
			if tonumber(rankId) == nil then
				rankId = modules.cf:GetRankId(rankId)
			end
			local lowerCase = string.lower(string.sub(settingName,1,1))
			local variableName = string.gsub(settingName,"%a",lowerCase, 1)
			main.permissions[variableName] = rankId
				
		end
	end
	
	
	--Final
	for i,v in pairs(main.settings.VIPServerCommandBlacklist) do
		main.blacklistedVipServerCommands[string.lower(v)] = true
	end
	
end




return module
