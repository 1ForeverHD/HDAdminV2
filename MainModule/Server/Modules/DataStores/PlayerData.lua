local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules
local settings = main.settings



-- << VARIABLES >>
local autosaveInterval = 90
local datastoreRetries = 3
local DataVersion = main.settings.PlayerDataStoreVersion or "V1.0"
local playerDataStore = main.dataStoreService:GetDataStore("HDAdminPlayerData"..DataVersion)



-- << LOCAL FUNCTIONS >>
local defaultSettingsToAdd = {"NoticeSoundId", "NoticeVolume", "NoticePitch", "ErrorSoundId", "ErrorVolume", "ErrorPitch", "AlertSoundId", "AlertVolume", "AlertPitch", "Prefix", "SplitKey"}
local defaultSettings = {}
coroutine.wrap(function()
	if not main.initialized then
		main.client.Signals.Initialized.Event:Wait()
	end
	for i,v in pairs(defaultSettingsToAdd) do
		defaultSettings[v] = settings[v]
	end
end)()
local function getDataTemplate()
	if not main.initialized then
		main.client.Signals.Initialized.Event:Wait()
	end
	return{
		
		DataKey 		= 0;
		DataToUpdate	= true;
		Theme			= settings.Theme;
		NoticeSoundId	= settings.NoticeSoundId;
		NoticeVolume	= settings.NoticeVolume;
		NoticePitch		= settings.NoticePitch;
		ErrorSoundId	= settings.ErrorSoundId;
		ErrorVolume		= settings.ErrorVolume;
		ErrorPitch		= settings.ErrorPitch;
		AlertSoundId	= settings.AlertSoundId;
		AlertVolume		= settings.AlertVolume;
		AlertPitch		= settings.AlertPitch;
		Prefix 			= settings.Prefix;
		SplitKey		= settings.SplitKey;
		MusicList 		= settings.MusicList;
		MuteLocalSound	= false;
		PreviousServer 	= game.JobId;
		Rank 			= 0;
		SaveRank		= false;
		PermRankedBy	= 3682;
		Donor 			= false;
		Gamepasses 		= {};
		Assets 			= {};
		
		DefaultSettings = defaultSettings; --If the owner changes these Settings, then update everyones data to the new setting.
		
		Groups 			= {};
		Friends 		= {};
		CommandsActive 	= {};
		LaserColor 		= Color3.fromRGB(255,0,0);
		PromptedDonor	= false;
		AutomaticRank	= false;
		Items 			= {};
		SetupData		= false;
		
	}
end

local function dataNotToSave()
	return{
		"Groups";
		"Friend";
		"CommandsActive";
		"LaserColor";
		"PromptedDonor";
		"AutomaticRank";
		"Items";
		"SetupData"
	}
end



--Save data to DataStore
local function savePlayerData(player, playerLeaving)
	local pdata = main.pd[player]
	if pdata and (pdata.DataToUpdate or playerLeaving) then
		return modules.DataStores:DataStoreRetry(datastoreRetries, function()
			return playerDataStore:UpdateAsync(player.UserId, function(oldValue)
				local newValue = oldValue or {DataKey = 0}
				if pdata and main.pd[player] then
					if pdata.DataKey == newValue.DataKey then
						main.pd[player].DataToUpdate = false
						main.pd[player].DataKey = pdata.DataKey + 1
						--
						local pdataToSave = {}
						for a,b in pairs(main.pd[player]) do
							pdataToSave[a] = b
						end
						if playerLeaving and not pdataToSave.SaveRank then
							pdataToSave.Rank = 0
						end
						local dataNotToSave = dataNotToSave()
						for i, v in pairs(dataNotToSave) do
							pdataToSave[v] = nil
						end
						--
						newValue = pdataToSave
					else
						newValue = nil --Prevent data being overwritten
					end
				end
				return newValue
			end)
		end)
	end
end



--<< FUNCTIONS >>
--Change value
function module:ChangeStat(player, statName, changeValue)
	local pdata = main.pd[player]
	if pdata then
		local newValue = pdata[statName]
		--[[
		if type(changeValue) == "number" and tonumber(newValue) then
			if changeValue == "reset" then
				newValue = 0
			else
				newValue = newValue + changeValue
			end
		else--]]
			newValue = changeValue
		--end
		main.pd[player][statName] = newValue
		main.pd[player].DataToUpdate = true
		main.signals.ChangeStat:FireClient(player, {statName, newValue})
		if statName == "Rank" then
			main.signals.RankChanged:FireClient(player)
		end
	end
end

--Insert new value
function module:InsertStat(player, locationName, newValue)
	if main.pd[player][locationName] then
		table.insert(main.pd[player][locationName], newValue)
		main.pd[player].DataToUpdate = true
		main.signals.InsertStat:FireClient(player, {locationName, newValue})
	end
end

--Remove value
function module:RemoveStat(player, locationName, newValue)
	local location = main.pd[player][locationName]
	if location then
		for i,v in pairs(location) do
			if tostring(v) == tostring(newValue) then
				table.remove(main.pd[player][locationName], i)
				main.pd[player].DataToUpdate = true
				main.signals.RemoveStat:FireClient(player, {locationName, newValue})
				break
			end
		end
	end
end



-- << SET UP PLAYER DATA >>
function module:SetupPlayerData(player)
	
	local dataTemplate = getDataTemplate()
	local pdata = main.pd[player]
	local success, data = modules.DataStores:GetData(playerDataStore, datastoreRetries, player.UserId)
	pdata = data
	
	--Can't access DataStore
	if not success and not main.isStudio then
		return nil
	
	--New player
	elseif not pdata then
		pdata = dataTemplate
		savePlayerData(player)
		local welcomeBadgeId = tonumber(main.settings.WelcomeBadgeId)
		if welcomeBadgeId and welcomeBadgeId > 0 then
			main.badgeService:AwardBadge(player.UserId, welcomeBadgeId)
		end
	
	--Existing player
	else
		for statName, statValue in pairs(dataTemplate) do
			if pdata[statName] == nil then
				pdata[statName] = statValue
			end
			if statName == "DefaultSettings" then
				for i, settingName in pairs(defaultSettingsToAdd) do
					if pdata[statName][settingName] == nil then
						pdata[statName][settingName] = settings[settingName]
					end
				end
			end
		end
		
	end
	
	main.pd[player] = pdata
	return pdata
end
 
--Player leaving > save data and remove server data about player
function module:RemovePlayerData(player)
	if main.pd[player] then
		savePlayerData(player, true)
	end
	main.pd[player] = nil
end



-- << SETUP >>
--Autosave
spawn(function()
	while wait(autosaveInterval) do
		for player, pdata in pairs(main.pd) do
			if main.players:FindFirstChild(player.Name) == nil then
				pdata = nil
			else
				savePlayerData(player)
			end
		end
	end
end)



--[[
-- << MODIFY DATA IN GAME >>

local player = game.Players.ForeverHD
local main = _G.HDAdminMain
local modules = main.modules
modules.DataStore:ChangeStat(player, "Donor", true)
	
--]]



return module
