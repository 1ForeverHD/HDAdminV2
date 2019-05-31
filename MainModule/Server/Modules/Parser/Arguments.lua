local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules
local settings = main.settings



-- << VARIABLES >>
local memberships = {
	nbc = Enum.MembershipType.None;
	bc = Enum.MembershipType.BuildersClub;
	tbc = Enum.MembershipType.TurboBuildersClub;
	obc = Enum.MembershipType.OutrageousBuildersClub;
	};

local materials = main.materials



-- << FUNCTIONS >>
function module:Process(commandArgsReal, args, commandPrefix, commandName, speaker, speakerData, originalMessage, originalAlias, batches, batchPos)
	local argsToReturn = {}
	local commandArgs = {}
	local UP = false
	if commandPrefix == main.settings.UniversalPrefix then
		UP = true
	end
	for i,v in pairs(commandArgsReal) do
		if i ~= 1 or v ~= "player" or not UP then
			table.insert(commandArgs, v)
		end
	end
	for i,v in pairs(commandArgs) do
		local argToProcess = args[i]
		
		if v == "rank" then
			local finalRankId = 6 -- Any rank higher than 5 will not be given
			if argToProcess ~= nil then
				for _, rankDetails in pairs(main.settings.Ranks) do
					local rankId = rankDetails[1]
					local rankName = rankDetails[2]
					if string.lower(rankName) == argToProcess then
						finalRankId = rankId
						break
					end
				end
				if finalRankId == 6 then
					for _, rankDetails in pairs(main.settings.Ranks) do
						local rankId = rankDetails[1]
						local rankName = rankDetails[2]
						if string.sub(string.lower(rankName),1,#argToProcess) == argToProcess then
							finalRankId = rankId
							break
						end
					end
				end
			end
			argToProcess = finalRankId
			
		elseif v == "colour" or v == "color" or v == "color3" then
			local finalColor
			if argToProcess ~= nil then
				finalColor = modules.cf:GetColorFromString(argToProcess)
			end
			if not finalColor then
				if commandName == "laserEyes" then
					finalColor = speakerData.LaserColor
				else
					finalColor = Color3.fromRGB(255,255,255)
				end
			end
			argToProcess = finalColor
			
		elseif v == "number" or v == "integer" or v == "studs" or v == "speed" then
			argToProcess = tonumber(argToProcess) or 0
			
		elseif v == "value" then
			local number = tonumber(argToProcess)
			if number then
				argToProcess = number
			end
		
		elseif v == "stat" or v == "statname" then
			local finalStatName = ""
			local leaderstats = speaker:FindFirstChild("leaderstats")
			if leaderstats then
				print("stat 2")
				for _,stat in pairs(leaderstats:GetChildren()) do
					local statName = string.lower(stat.Name)
					if string.sub(statName, 1, #argToProcess) == argToProcess then
						finalStatName = stat.Name
						break
					end
				end
			end
			argToProcess = finalStatName
			
		elseif v == "scale" then
			argToProcess = tonumber(argToProcess) or 1
			local scaleLimit = main.settings.ScaleLimit
			local ignoreRank = main.settings.IgnoreScaleLimit
			if argToProcess > scaleLimit and speakerData.Rank < ignoreRank then
				argToProcess = 1
				local rankName = modules.cf:GetRankName(ignoreRank)
				modules.cf:FormatAndFireError(speaker, "ScaleLimit", scaleLimit, rankName)
			elseif argToProcess > 50 then
				argToProcess = 100
			end
			--
			
		elseif v == "degrees" or v == "degree" or v == "rotation" then
			argToProcess = tonumber(argToProcess) or 180
		
		elseif v == "team" or v == "teamcolor" then
			local teamColor
			for _,team in pairs(main.teams:GetChildren()) do
				local teamName = string.lower(team.Name)
				if string.sub(teamName, 1, #argToProcess) == argToProcess then
					teamColor = team.TeamColor
					break
				end
			end
			argToProcess = teamColor
			
		elseif v == "text" or v == "string" or v == "reason" or v == "question" then
			local _, minStartPos = string.lower(originalMessage):find(originalAlias)
			if argToProcess then
				local newOriginalMessage = string.sub(originalMessage, minStartPos+1)
				local startPos, endPos = string.lower(newOriginalMessage):find(argToProcess)
				local message = string.sub(newOriginalMessage, startPos)
				if batchPos ~= #batches then
					local removeFrom = batchPos+1
					for i,v in pairs(batches) do
						if i >= removeFrom then
							table.remove(batches,removeFrom)
						end
					end
				end
				argToProcess = modules.cf:FilterBroadcast(message, speaker)
			else
				argToProcess = " "
			end
			
		elseif v == "answers" then
			local newArgs = {}
			if argToProcess then
				argToProcess:gsub('([^,]+)',function(c) newArgs[#newArgs+1] = c end);
				argToProcess = newArgs
			end
			
		elseif v == "material" then
			local finalMaterial = Enum.Material.Plastic
			for i, materialName in pairs(materials) do
				if (argToProcess == string.sub(string.lower(materialName),1,#argToProcess)) then
					finalMaterial = Enum.Material[materialName]
					break
				end
			end
			argToProcess = finalMaterial
		
		elseif v == "userid" or v == "playerid" or v == "plrid" then
			if argToProcess == nil then
				argToProcess = 1
			end
			local userId = tonumber(argToProcess)
			if not userId then
				local userName = string.lower(argToProcess)
				for i, plr in pairs(main.players:GetChildren()) do
					local plrName = string.lower(plr.Name)
					if string.sub(plrName, 1, #userName) == userName then
						userId = plr.UserId
					end
				end
				if not userId then
					userId = modules.cf:GetUserId(argToProcess)
				end
			end
			argToProcess = userId
		
		elseif v == "tools" or v == "gears" or v == "tool" or v == "gear" then
			local toolName = argToProcess
			argToProcess = {}
			for i,v in pairs(main.listOfTools) do
				if toolName == "all" or string.lower(string.sub(v.Name, 1, #toolName)) == toolName then
					table.insert(argToProcess, v)
				end
			end
		
		elseif v == "morph" then
			local morphName = argToProcess
			argToProcess = nil
			if morphName then
				for i,v in pairs(main.morphs:GetChildren()) do
					local mName = string.lower(v.Name)
					if mName == morphName then
						argToProcess = v
						break
					elseif string.sub(mName, 1, #morphName) == morphName then
						argToProcess = v
					end
				end
			end
			
		end
		
		table.insert(argsToReturn, argToProcess)
	end
	
	return argsToReturn
end



return module
