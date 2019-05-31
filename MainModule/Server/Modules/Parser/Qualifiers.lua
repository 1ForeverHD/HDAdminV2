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



-- << FUNCTIONS >>
function module:ParseQualifier(q, speaker, targetPlayers)
	targetPlayers = targetPlayers or {}
	local speakerData = main.pd[speaker]
	local firstChar = string.sub(q,1,1)
	local remainingChars = string.sub(q,2)
	local endLength = #remainingChars
	if firstChar == "@" and string.sub(remainingChars, endLength-1, endLength) then
		remainingChars = string.sub(remainingChars, 1, endLength-1)
	end
				
	if q == "me" then
		targetPlayers[speaker] = true
	
	elseif q == "all" then
		for i, plr in pairs(main.players:GetChildren()) do
			targetPlayers[plr] = true
		end
		
	elseif q == "random" then
		targetPlayers[game.Players:GetChildren()[math.random(1,#game.Players:GetChildren())]] = true
		
	elseif q == "others" then
		for i, plr in pairs(main.players:GetChildren()) do
			if plr ~= speaker then
				targetPlayers[plr] = true
			end
		end
		
	elseif q == "admins" or q == "nonadmins" then
		for i, plr in pairs(main.players:GetChildren()) do
			local pdata = main.pd[plr]
			if pdata and ((q == "admins" and pdata.Rank > 0) or (q == "nonadmins" and pdata.Rank == 0)) then
				targetPlayers[plr] = true
			end
		end
		
	elseif q == "nbc" or q == "bc" or q == "tbc" or q == "obc" then
		for i, plr in pairs(main.players:GetChildren()) do
			if plr.MembershipType == memberships[q] then
				targetPlayers[plr] = true
			end
		end
		
	elseif q == "friends" or q == "nonfriends" then
		for i, plr in pairs(main.players:GetChildren()) do
			if (q == "friends" and speakerData.Friends[plr.Name]) or (q == "nonfriends" and not speakerData.Friends[plr.Name] and plr ~= speaker) then
				targetPlayers[plr] = true
			end
		end
			
	elseif q == "r6" or q == "r15" then
		for i, plr in pairs(main.players:GetChildren()) do
			local humanoid = modules.cf:GetHumanoid(plr)
			if humanoid and ((q == "r6" and humanoid.RigType == Enum.HumanoidRigType.R6) or (q == "r15" and humanoid.RigType == Enum.HumanoidRigType.R15)) then
				targetPlayers[plr] = true
			end
		end
		
	elseif q == "rthro" or q == "nonrthro" then
		for i, plr in pairs(main.players:GetChildren()) do
			local humanoid = modules.cf:GetHumanoid(plr)
			if humanoid then
				local bts = humanoid:FindFirstChild("BodyTypeScale")
				if bts and ((q == "rthro" and bts.Value > 0.9) or (q == "nonrthro" and bts.Value <= 0.9)) then
					targetPlayers[plr] = true
				end
			end
		end
		
	elseif firstChar == "@" then -- Select Rank
		local selectedRanks = {}
		local count = 0
		for _, rankDetails in pairs(main.settings.Ranks) do
			local rankId = tostring(rankDetails[1])
			local rankName = string.lower(rankDetails[2])
			if string.sub(rankName, 1, #remainingChars) == remainingChars then
				selectedRanks[rankId] = true
				count = count + 1
			end
		end
		if count > 0 then
			for i, plr in pairs(main.players:GetChildren()) do
				local pdata = main.pd[plr]
				if pdata and selectedRanks[tostring(pdata.Rank)] then
					targetPlayers[plr] = true
				end
			end
		end
		
	elseif firstChar == "%" then -- Select Team
		local selectedTeams = {}
		local count = 0
		for _,team in pairs(main.teams:GetChildren()) do
			local teamName = string.lower(team.Name)
			if string.sub(teamName, 1, #remainingChars) == remainingChars then
				selectedTeams[tostring(team.TeamColor)] = true
				count = count + 1
			end
		end
		if count > 0 then
			for i, plr in pairs(main.players:GetChildren()) do
				if selectedTeams[tostring(plr.TeamColor)] then
					targetPlayers[plr] = true
				end
			end
		end
	
	else -- Individual
		for i, plr in pairs(main.players:GetChildren()) do
			local plrName = string.lower(plr.Name)
			if string.sub(plrName, 1, #q) == q then
				targetPlayers[plr] = true
			end
		end
	end
	return targetPlayers
end

function module:GetTargetPlayers(speaker, args, commandPrefix, commandPrefixes, commandName, individual)
	local qArg = args[1]
	local targetPlayers = {}
	local qBatches = {}
	local qUsed = {}
	local speakerData = main.pd[speaker]
	if qArg and type(qArg) ~= "userdata" and type(qArg) ~= "number" then
		qArg:gsub('([^'..settings.QualifierBatchKey..']+)',function(c) table.insert(qBatches, c) end);
		table.remove(args, 1)
	end
	for _, q in pairs(qBatches) do
		qUsed[q] = true
		targetPlayers = module:ParseQualifier(q, speaker, targetPlayers)
	end
	
	--Check if player is selecting more than 1 person and modify based on their rank
	local ignoreSingleUse = {["view"] = true, ["handto"] = true;}
	if not ignoreSingleUse[commandName] then
		local totalPlrs = 0
		for plr, _ in pairs(targetPlayers) do
			totalPlrs = totalPlrs + 1
		end
		local onlyMe = true
		for i,v in pairs(qBatches) do
			if v ~= "me" then
				onlyMe = false
			end
		end
		local speakerRankName = modules.cf:GetRankName(speakerData.Rank)
		if individual and totalPlrs > 0 then
			for plr,_ in pairs(targetPlayers) do
				return plr
			end
		elseif speakerData.Rank < 2 and not onlyMe then
			modules.cf:FormatAndFireError(speaker, "QualifierLimitToSelf", speakerRankName)
			targetPlayers = {}
		elseif speakerData.Rank < 3 and totalPlrs > 1 then
			modules.cf:FormatAndFireError(speaker, "QualifierLimitToOnePerson", speakerRankName)
			targetPlayers = {}
		end
	end
	
	
	--Check Universal Prefix and adjust arguments accordingly
	if commandPrefix == main.settings.UniversalPrefix or (modules.cf:FindValue(commandPrefixes, main.settings.UniversalPrefix) and qArg == nil) then
		targetPlayers = {}
		targetPlayers[speaker] = true
	end
	
	return targetPlayers
end



return module
