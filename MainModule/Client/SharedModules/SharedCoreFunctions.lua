-- Referenced using 'main.modules.cf'

local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules



-- << FUNCTIONS >>
function module:WaitForEvent(...)
	local event
	local firstArg = ({...})[1]
	if typeof(firstArg) == "Instance" and firstArg:IsA("BindableEvent") then
		event = firstArg
	else
		event = Instance.new("BindableEvent")
	end
	local signals = {}
	for _,e in pairs({...}) do
		if e ~= firstArg then
			signals[#signals + 1] = e:Connect(function()
				event:Fire()
			end)
		end
	end
	event.Event:Wait()
	event:Destroy()
	for _,s in pairs(signals) do s:Disconnect() end
end

function module:CreateSound(props)
	local sound = Instance.new("Sound")
	for propName, value in pairs(props) do
		if propName == "SoundId" then
			value = "rbxassetid://"..value
		end
		sound[propName] = value
	end
	return sound
end

function module:FormatNotice2(noticeName, extraDetails, ...)
	local notice = modules.CoreNotices:GetNotice(noticeName)
	notice[2] = string.format(notice[2], ...)
	notice[3] = extraDetails
	return notice
end

function module:FormatNotice(noticeName, ...)
	local notice = modules.CoreNotices:GetNotice(noticeName)
	notice[2] = string.format(notice[2], ...)
	return notice
end

function module:RandomiseTable(originalTable)
	local sortedTable ={}
	if originalTable[1]~=nil then
		for i=1,#originalTable do
			table.insert(sortedTable,math.random(1,#sortedTable+1),originalTable[i])
		end
	end
	return sortedTable
end

function module:IsPunished(plr)
	if plr and plr.Character and plr.Character.Parent == workspace then
		return false
	else
		return true
	end
end

function module:UnSeatPlayer(plr)
	local humanoid = module:GetHumanoid(plr)
	if humanoid then
		local seatPart = humanoid.SeatPart
		if seatPart then
			local seatWeld = seatPart:FindFirstChild("SeatWeld")
			if seatWeld then
				seatWeld:Destroy()
				wait()
			end
		end
	end
end

function module:GetBanDateString(date, serverDate)
	local minute = date.min or serverDate.min
	local hour = date.hour or serverDate.hour
	local day = date.day or serverDate.day
	local month = modules.cf:GetMonths()[date.month or serverDate.month]
	local year = date.year or serverDate.year
	if minute < 10 then
		minute = "0"..minute
	end
	if hour < 10 then
		hour = "0"..hour
	end
	local dayId = tonumber(string.sub(day,-1))
	local dayEnding = "th"
	if dayId < 10 or dayId > 15 then
		if dayId == 1 then
			dayEnding = "st"
		elseif dayId == 2 then
			dayEnding = "nd"
		elseif dayId == 3 then
			dayEnding = "rd"
		end
	end
	return(hour..":"..minute..", "..day..dayEnding.." "..month.." "..year)
end

function module:GetTimeAmount(timeType, d)
	local amount = 0
	local frameName = ""
	if d < 0 then
		d = 0
	end
	if timeType == "m" then
		if d > 60 then
			d = 60
		end
		amount = d*60
		frameName = "Minutes"
	elseif timeType == "h" then
		if d > 24 then
			d = 24
		end
		amount = d*3600
		frameName = "Hours"
	elseif timeType == "d" then
		if d > 100000 then
			d = 100000
		end
		amount = d*86400
		frameName = "Days"
	end
	return amount, frameName, d
end

function module:GetMonths()
	return{
		"January";
		"February";
		"March";
		"April";
		"May";
		"June";
		"July";
		"August";
		"September";
		"October";
		"November";
		"December";
	}
end

function module:AnchorModel(model, state)
	for a,b in pairs(model:GetDescendants()) do
		if b:IsA("BasePart") and not b.Parent:IsA("Accessory") then
			b.Anchored = state
		end
	end
end

function module:TweenModel(model, CF, info)
	local CFrameValue = Instance.new("CFrameValue")
	CFrameValue.Value = model:GetPrimaryPartCFrame()
	local changedEvent
	changedEvent = CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
		if model.PrimaryPart == nil then
			changedEvent:Disconnect()
		else
			model:SetPrimaryPartCFrame(CFrameValue.Value)
		end
	end)
	local tween = main.tweenService:Create(CFrameValue, info, {Value = CF})
	tween:Play()
	tween.Completed:Connect(function()
		CFrameValue:Destroy()
	end)
end

function module:Movement(state, plr)
	if plr == nil then
		plr = main.player
	end
	local hrp = module:GetHRP(plr)
	local humanoid = module:GetHumanoid(plr)
	if hrp and humanoid then
		if not state then
			local originialSpeed = humanoid.WalkSpeed
			humanoid.WalkSpeed = 0
			wait()
			humanoid.WalkSpeed = originialSpeed
			hrp.Anchored = true
		else
			hrp.Anchored = false
		end
	end
end

function module:SetFakeBodyParts(char, info)
	for a,b in pairs(char:GetChildren()) do
		if modules.cf:CheckBodyPart(b) then
			local fakePart = modules.MorphHandler:CreateFakeBodyPart(char, b)
			for pName, pValue in pairs(info) do
				if pName == "Material" then
					fakePart.Material = pValue
					if pValue == Enum.Material.Glass then
						fakePart.Transparency = 0.5
					else
						fakePart.Transparency = 0
					end
				elseif pName == "Reflectance" then
					fakePart.Reflectance = pValue
				elseif pName == "Transparency" then
					fakePart.Transparency = pValue
				elseif pName == "Color" then
					fakePart.Color = pValue
				end
			end
		end
	end
end

function module:CheckBodyPart(part)
	if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and string.sub(part.Name,1,4) ~= "Fake" then
		return true
	else
		return false
	end
end

function module:CreateClone(character)
	
	if character == nil then
		character = main.player.Character
	end
	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid then
		
		--Setup clone
		character.Archivable = true
		local clone = character:Clone()
		local cloneHumanoid = clone.Humanoid
		clone.Name = character.Name.."'s HDAdminClone"
		local specialChar = false
		if clone:FindFirstChild("Chest") then
			specialChar = true
		end
		for a,b in pairs(clone:GetDescendants()) do
			if b:IsA("Humanoid") then
				b.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			elseif b:IsA("BillboardGui") then
				b:Destroy()
			elseif b:IsA("Weld") and b.Part1 ~= nil then
				b.Part0 = b.Parent
				if clone:FindFirstChild(b.Part1.Name) then
					b.Part1 = clone[b.Part1.Name]
				elseif not specialChar then
					b:Destroy()
				end
			end
		end
		
		--Make clone visible
		--module:SetTransparency(clone, 0)
		clone.Parent = workspace
		
		--Animations
		local tracks = {}
		local desc = humanoid:GetAppliedDescription()
		local animate = clone:FindFirstChild("Animate")
		if animate then
			for i,v in pairs(clone.Animate:GetChildren()) do
				local anim = (v:GetChildren()[1])
				if anim then
					--anim.Parent = clone
					tracks[v.Name] = cloneHumanoid:LoadAnimation(anim)
				end
			end
			tracks.idle:Play()
		end
		
		return clone, tracks
	end
	
end

function module:SetTransparency(model, value, force)
	local plr = main.players:GetPlayerFromCharacter(model)
	if ((plr and main.pd[plr] and main.pd[plr].Items.UnderControl and not force)) or not model then
		return
	end
	local fakeParts = false
	if model:FindFirstChild("FakeHead") then
		fakeParts = true
	end
	for a,b in pairs(model:GetDescendants()) do
		if (b:IsA("BasePart") and b.Name ~= "HumanoidRootPart") or (b.Name == "face" and b:IsA("Decal")) then
			local ot = b:FindFirstChild("OriginalTransparency")
			if value == 1 and b.Transparency ~= 0 and not ot then
				ot = Instance.new("IntValue")
				ot.Name = "OriginalTransparency"
				ot.Value = b.Transparency
				ot.Parent = b
			elseif value == 0 and ot then
				b.Transparency = ot.Value
				ot:Destroy()
			elseif not fakeParts or model:FindFirstChild(b.Name.."Fake") == nil then --string.sub(b.Name,1,4) == "Fake" then
				b.Transparency = value
			end
		elseif (b:IsA("ParticleEmitter") and b.Name == "BodyEffect") or b:IsA("PointLight") then
			if value == 1 then
				b.Enabled = false
			elseif value == 0 then
				b.Enabled = true
			end
		elseif b:IsA("BillboardGui") then
			if value == 1 then
				b.Enabled = false
			elseif value == 0 then
				b.Enabled = true
			end
		end
	end
end

function module:GetMessageTime(msg)
	return(3+(string.len(msg)/30))
end

function module:GetProductInfo(assetId)
	local infoToReturn = {}
	local success, productInfo = pcall(function() return main.marketplaceService:GetProductInfo(assetId) end)
	if success then
		infoToReturn = productInfo
	end
	return infoToReturn
end

function module:CheckIfValidSound(soundId)
	local productInfo = module:GetProductInfo(soundId)
	if productInfo.AssetTypeId == 3 then
		return true
	else
		return false
	end
end

function module:GetChar(plr)
	if plr == nil then
		plr = main.player
	end
	if plr then
		return plr.Character
	end
end

function module:GetHRP(plr)
	if plr == nil then
		plr = main.player
	end
	if plr and plr.Character then
		local head = plr.Character:FindFirstChild("HumanoidRootPart")
		return head
	end
end

function module:GetNeck(plr)
	if plr == nil then
		plr = main.player
	end
	if plr and plr.Character then
		local head = plr.Character:FindFirstChild("Head")
		if head then
			local neck = head:FindFirstChild("Neck")
			local torso = plr.Character:FindFirstChild("Torso")
			if not neck and torso then
				neck = torso:FindFirstChild("Neck")
			end
			return neck
		end
	end
end

function module:GetHead(plr)
	if plr == nil then
		plr = main.player
	end
	if plr and plr.Character then
		local head = plr.Character:FindFirstChild("Head")
		return head
	end
end

function module:GetFace(plr)
	if plr == nil then
		plr = main.player
	end
	if plr and plr.Character then
		local head = plr.Character:FindFirstChild("Head")
		if head then
			local face = head:FindFirstChild("face")
			if face and face.ClassName == "Decal" then
				return face
			end
		end
		return head
	end
end

function module:GetHumanoid(plr)
	if plr == nil then
		plr = main.player
	end
	if plr and plr.Character then
		local humanoid = plr.Character:FindFirstChild("Humanoid")
		return humanoid
	end
end

function module:GetProductInfo(productId, productType)
	local productInfo = {}
	local success, message = pcall(function()
		productInfo = main.marketplaceService:GetProductInfo(productId, productType)
	end)
	if not success then
		--warn("HD Admin | Loader settings incorrect  | "..message)
	end
	return productInfo
end

function module:GetFriends(userId)
	local friendsList = {}
	local success, page = pcall(function() return main.players:GetFriendsAsync(userId) end)
	if success then
		repeat
			local info = page:GetCurrentPage()
			for i, friendInfo in pairs(info) do
				friendsList[friendInfo.Username] = friendInfo.Id
			end
			if not page.IsFinished then 
				page:AdvanceToNextPageAsync()
			end
		until page.IsFinished
	end
	return friendsList
end

function module:GetRankName(rankIdToConvert)
	local rankNameToReturn = ""
	for _, rankDetails in pairs(main.settings.Ranks) do
		local rankId = rankDetails[1]
		local rankName = rankDetails[2]
		if rankIdToConvert == rankId then
			rankNameToReturn = rankName
		elseif rankIdToConvert == "Donor" then
			rankNameToReturn = rankIdToConvert
		end
	end
	return rankNameToReturn
end

function module:GetRankId(rankNameToConvert)
	local rankIdToReturn = 0
	for _, rankDetails in pairs(main.settings.Ranks) do
		local rankId = rankDetails[1]
		local rankName = rankDetails[2]
		if rankNameToConvert == rankName then
			rankIdToReturn = rankId
		end
	end
	return rankIdToReturn
end

function module:CheckRankExists(rankName)
	for _, rankDetails in pairs(main.settings.Ranks) do
		if string.lower(rankDetails[2]) == rankName then
			return true
		end
	end
	return false
end

function module:GetUserId(userName)
	local start = tick()
	local userId = main.UserIdsFromName[userName]
	if not userId or userId <= 1 then
		userId = 1
		local success, message = pcall(function()
			userId = main.players:GetUserIdFromNameAsync(userName)
		end)
		main.UserIdsFromName[userName] = userId
		--main.UsernamesFromUserId[tostring(userId)] = userName
	end
	return userId
end

function module:GetName(userId)
	local userIdString = tostring(userId)
	local userIdInt = tonumber(userId)
	local username = main.UsernamesFromUserId[userIdString]
	if not username then
		username = ""
		if userIdInt then
			local success, message = pcall(function()
				username = main.players:GetNameFromUserIdAsync(userIdInt)
			end)
			if not success then
				--warn("HD Admin | Loader settings incorrect  | "..message)
			else
				main.UsernamesFromUserId[userIdString] = username
				--main.UserIdsFromName[username] = userIdInt
			end
		end
	end
	return username
end

function module:FindValue(table, value)
	for i,v in pairs(table) do
		if tostring(v) == tostring(value) then
			return true
		end
	end
	return false
end



return module
