local module = {}



-- << FUNCTIONS >>
function module:GetData(dataStore, datastoreRetries, key)
	return module:DataStoreRetry(datastoreRetries, function()
		return dataStore:GetAsync(key)
	end)
end

function module:DataStoreRetry(datastoreRetries, dataStoreFunction)
	local tries = 0	
	local success = true
	local data = nil
	local errorMsg = ""
	repeat
		tries = tries + 1
		success, errorMsg = pcall(function() data = dataStoreFunction() end)
		if not success then wait(1) end
	until tries == datastoreRetries or success
	if not success then
		--warn("HD Admin | Could not access DataStore | ".. tostring(errorMsg))
		-- Cannot access DataStore
	end
	return success, data
end



return module
