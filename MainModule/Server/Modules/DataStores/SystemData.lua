local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules



-- << VARIABLES >>
local keys = {"Banland", "PermRanks", "Broadcast"}
local updateInterval = 10
local datastoreRetries = 3
local DataVersion = main.settings.SystemDataStoreVersion or "V1.0"
local systemDataStore = main.dataStoreService:GetDataStore("HDAdminSystemData"..DataVersion)
local currentBroadcastId = 0
local updating = false



-- << LOCAL FUNCTIONS >>
local function dataTemplate(key)
	if key == "Banland" or key == "PermRanks" then
		return{
			DataKey = 0;
			Records = {};
			RecordsToAdd = {};
			RecordsToRemove = {};
			RecordsToModify = {};
		}
	elseif key == "Broadcast" then
		return{
			DataKey = 0;
			BroadcastData = {};
			BroadcastTime = 0;
			BroadcastId = 0
		}
	end
end

--Save data to DataStore
local function saveSystemData(key)
	local sdata = main.sd[key]
	return modules.DataStores:DataStoreRetry(datastoreRetries, function()
		return systemDataStore:UpdateAsync(key, function(oldValue)
			local newValue = oldValue or dataTemplate(key)
			if sdata then
				if sdata.DataKey == newValue.DataKey then
					newValue.DataToUpdate = false
					newValue.DataKey = newValue.DataKey + 1
					for statName, statValue in pairs(sdata) do
						if statName == "RecordsToAdd" and #statValue > 0 then
							for i,record in pairs(statValue) do
								--print("Datastore: "..key.." | AddRecord | "..record.UserId)
								table.insert(newValue.Records, record)
							end
						elseif (statName == "RecordsToRemove" or statName == "RecordsToModify") and #statValue > 0 then
							for i,record in pairs(statValue) do
								local recordToRemovePos = modules.cf:FindUserIdInRecord(newValue.Records, record.UserId)
								if recordToRemovePos then
									table.remove(newValue.Records, recordToRemovePos)
									if statName == "RecordsToModify" then
										--print("Datastore: "..key.." | ModifyRecord | "..record.UserId)
										table.insert(newValue.Records, record)
									else
										--print("Datastore: "..key.." | RemoveRecord | "..record.UserId)
									end
								end
							end
						elseif statName ~= "Records" and statName ~= "DataKey" and statName ~= "DataToUpdate" then
							newValue[statName] = statValue
						end
					end
					main.sd[key] = newValue
				else
					newValue = nil
				end
			end
			return newValue
		end)
	end)
end



-- << FUNCTIONS >>
function module:InsertStat(key, statName, value, specificData)
	if updating and not specificData then repeat wait(0.1) until not updating end
	key = tostring(key)
	if specificData then
		table.insert(specificData[statName], value)
		specificData.DataToUpdate = true
	else
		table.insert(main.sd[key][statName], value)
		main.sd[key].DataToUpdate = true
	end
end

function module:ChangeStat(key, statName, newValue)
	if updating then repeat wait(0.1) until not updating end
	main.sd[key][statName] = newValue
	main.sd[key].DataToUpdate = true
end



-- << MAIN >>
coroutine.wrap(function()
	local initialized = main.initialized or main.client.Signals.Initialized.Event:Wait()
	while true do
		updating = true
		for i,key in pairs(keys) do
			
			-- << WRITE DATA >>
			local sdata = main.sd[key]
			if sdata and sdata.DataToUpdate then
				saveSystemData(key)
			end
			
			
			-- << RETRIEVE DATA >>
			local dataTemplate = dataTemplate(key)
			local success, data = modules.DataStores:GetData(systemDataStore, datastoreRetries, key)
			--Can't access DataStore
			if not success and not main.isStudio then
				data = main.sd[key]
			
			--New data
			elseif not data then
				data = dataTemplate
				saveSystemData(key)
				
			--Existing data
			else
				local timeNow = os.time()
				for statName, defaultStatValue in pairs(dataTemplate) do
					if data[statName] == nil then
						data[statName] = defaultStatValue
					end
					local statValue = data[statName]
					local currentUsers = {}
					if statName == "Records" then
						for i, record in pairs(statValue) do
							currentUsers[record.UserId] = record
							coroutine.wrap(function()
								record.Name = modules.cf:GetName(record.UserId)
							end)()
						end
						if key == "PermRanks" then
							for plr, pdata in pairs(main.pd) do
								local record = currentUsers[plr.UserId]
								if record and (record.RemoveRank or not pdata.SaveRank) then
									module:InsertStat(key, "RecordsToRemove", record, data)
									if record.RemoveRank then
										modules.cf:Unrank(plr)
									end
								elseif not record and pdata.SaveRank and (not pdata.AutomaticRank or pdata.AutomaticRank < pdata.Rank) then
									local newRecord = {
										UserId = plr.UserId;
										Rank = pdata.Rank;
										RankedBy = pdata.PermRankedBy;
										RemoveRank = false;
									}
									module:InsertStat(key, "RecordsToAdd", newRecord, data)
									module:InsertStat(key, "Records", newRecord, data)
								end
							end
						end
					elseif statName == "BroadcastTime" then
						--print("BroadcastCheck: ".. timeNow - statValue.."    |    ".. currentBroadcastId.." : "..data.BroadcastId)
						if statValue > timeNow - 30 and currentBroadcastId ~= data.BroadcastId then
							currentBroadcastId = data.BroadcastId
							main.signals.GlobalAnnouncement:FireAllClients(data.BroadcastData)
						end
					end
				end
			end
			main.sd[key] = data
			
		end
		updating = false
		wait(updateInterval)
	end
end)()




return module
