local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules
local commandInfoForClient = {"Contributors", "Prefixes", "Rank", "Aliases", "Tags", "Description", "Args", "Loopable"}



-- << VARIABLES >>
local humanoidDescriptions = {}
local accessoryTypes = {
	[8] = "HatAccessory",
    [41] = "HairAccessory",
    [42] = "FaceAccessory",
    [43] = "NeckAccessory",
    [44] = "ShouldersAccessory",
    [45] = "FrontAccessory",
    [46] = "BackAccessory",
    [47] = "WaistAccessory",
}
local correspondingBodyParts = {
	["Torso"]		= {"UpperTorso","LowerTorso"};
	["Left Arm"] 	= {"LeftHand","LeftLowerArm","LeftUpperArm"};
	["Right Arm"]	= {"RightHand","RightLowerArm","RightUpperArm"};
	["Left Leg"]	= {"LeftFoot","LeftLowerLeg","LeftUpperLeg"};
	["Right Leg"]	= {"RightFoot","RightLowerLeg","RightUpperLeg"};
	}


-- << FUNCTIONS >>
function module:UpdateHipHeight(character)
	--[[
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local leftFoot = character:FindFirstChild("LeftFoot")
	if hrp and humanoid and leftFoot then
		local bottomOfHumanoidRootPart = hrp.Position.Y - (1/2 * hrp.Size.Y)
		local bottomOfFoot = leftFoot.Position.Y - (1/2 * leftFoot.Size.Y) -- Left or right. Chose left arbitrarily
		local newHipHeight = bottomOfHumanoidRootPart - bottomOfFoot
		humanoid.HipHeight = newHipHeight
	end
	--]]
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		local leftFoot = character:FindFirstChild("LeftFoot")
		if leftFoot then
			humanoid:BuildRigFromAttachments()
		else
			humanoid.HipHeight = 0
		end
	end
end
function module:ChangeAllBodyColors(plr, newColor)
	local humanoid = modules.cf:GetHumanoid(plr)
	if humanoid then
		local desc = humanoid:GetAppliedDescription()
		desc.HeadColor = newColor
		desc.LeftArmColor = newColor
		desc.RightArmColor = newColor
		desc.LeftLegColor = newColor
		desc.RightLegColor = newColor
		desc.TorsoColor = newColor
		pcall(function() humanoid:ApplyDescription(desc) end)
		if plr.Character:FindFirstChild("FakeHead") then
			for a,b in pairs(plr.Character:GetChildren()) do
				if string.sub(b.Name,1,4) == "Fake" and b:IsA("BasePart") then
					b.Color = newColor
				end
			end
		end
	end
end

function module:ChangeProperty(plr, propertyName, propertyValue)
	local humanoid = modules.cf:GetHumanoid(plr)
	if humanoid then
		local desc = humanoid:GetAppliedDescription()
		desc[propertyName] = propertyValue
		pcall(function() humanoid:ApplyDescription(desc) end)
	end
end

function module:ChangeProperties(plr, properties)
	local humanoid = modules.cf:GetHumanoid(plr)
	if humanoid then
		--[[
		local desc = humanoid:GetAppliedDescription()
		for pName, pValue in pairs(properties) do
			desc[pName] = pValue
		end
		pcall(function() humanoid:ApplyDescription(desc) end)--]]
		for a,b in pairs(humanoid:GetChildren()) do
			local targetName = string.lower(b.Name)
			for propName, propValue in pairs(properties) do
				propName = string.lower(propName)
				if string.sub(targetName, -#propName) == propName then
					b.Value = propValue
					break
				end
			end
		end
	end
end

function module:ClearProperty(plr, propertyName)
	local humanoid = modules.cf:GetHumanoid(plr)
	if humanoid then
		local desc = humanoid:GetAppliedDescription()
		desc[propertyName] = ""
		pcall(function() humanoid:ApplyDescription(desc) end)
	end
end

function module:ResetProperty(plr, propertyName)
	local humanoid = modules.cf:GetHumanoid(plr)
	if humanoid then
		local mainDesc = main.players:GetHumanoidDescriptionFromUserId(plr.UserId)
		local desc = humanoid:GetAppliedDescription()
		desc[propertyName] = mainDesc[propertyName]
		pcall(function() humanoid:ApplyDescription(desc) end)
	end
end

function module:SetScale(plr, scaleType, scaleValue)
	local humanoid = modules.cf:GetHumanoid(plr)
	if humanoid then
		local desc = humanoid:GetAppliedDescription()
		desc[scaleType.."Scale"] = scaleValue
		pcall(function() humanoid:ApplyDescription(desc) end)
	end
end

function module:AddAccessory(plr, accessoryId)
	local humanoid = modules.cf:GetHumanoid(plr)
	if humanoid then
		local info = modules.cf:GetProductInfo(accessoryId)
		if info.AssetTypeId then
			local propertyName = accessoryTypes[info.AssetTypeId]
			if propertyName and info.AssetTypeId then
				local desc = humanoid:GetAppliedDescription()
				desc[propertyName] = desc[propertyName]..","..accessoryId
				pcall(function() humanoid:ApplyDescription(desc) end)
			end
		end
	end
end

function module:ClearAccessories(plr)
	local humanoid = modules.cf:GetHumanoid(plr)
	if humanoid then
		local desc = humanoid:GetAppliedDescription()
		for i,v in pairs(accessoryTypes) do
			desc[v] = ""
		end
		desc.HatAccessory = ""
		pcall(function() humanoid:ApplyDescription(desc) end)
	end
end

function module:CreateFakeBodyPart(character, bodyPart)
	local fakePartName = "Fake"..bodyPart.Name
	local fakePart = character:FindFirstChild(fakePartName)
	if not fakePart then
		local mesh = bodyPart:FindFirstChildOfClass("SpecialMesh")
		if bodyPart.Name == "Head" and mesh then
			if mesh.MeshType == Enum.MeshType.Head then
				fakePart = main.server.Assets.FakeHead:Clone()
				local size = bodyPart.Size
				local scaleUp = mesh.Scale.Y/1.25
				fakePart.Size = Vector3.new(size.X*0.6*scaleUp, size.Y*1.2*scaleUp, size.Z*1.19*scaleUp)
				fakePart.CFrame = bodyPart.CFrame * CFrame.new(0, mesh.Offset.Y, 0)
			else
				fakePart = bodyPart:Clone()
				fakePart:ClearAllChildren()
				mesh:Clone().Parent = fakePart
			end
		else
			fakePart = bodyPart:Clone()
			fakePart:ClearAllChildren()
		end
		fakePart.CanCollide = false
		fakePart.Name = "Fake"..bodyPart.Name
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = fakePart
		weld.Part1 = bodyPart
		weld.Parent = fakePart
		bodyPart.Transparency = 1
		fakePart.Parent = character
	end
	fakePart.Color = bodyPart.Color
	return fakePart
end

function module:ClearFakeBodyParts(character)
	for a,b in pairs(character:GetChildren()) do
		if b:IsA("BasePart") then
			if string.sub(b.Name, 1, 4) == "Fake" then
				b:Destroy()
			elseif b.Name ~= "HumanoidRootPart" then
				b.Transparency = 0
			end
		end
	end
end

function module:SetHeadMeshSize(plr, scale)
	local head = modules.cf:GetHead(plr)
	if head then
		local mesh = head:FindFirstChildOfClass("SpecialMesh")
		if mesh then
			local osize = mesh:FindFirstChild("OriginalSize")
			if not osize then
				osize = Instance.new("Vector3Value")
				osize.Name = "OriginalSize"
				osize.Value = mesh.Scale
				osize.Parent = mesh
			end
			modules.MorphHandler:ClearAccessories(plr)
			mesh.Scale = Vector3.new(osize.Value.X*scale.X, osize.Value.Y*scale.Y, osize.Value.Z*scale.Z)
			local yOffset = 0
			if scale.Y == 0.75 then
				yOffset = -0.15
			elseif scale.Y == 2 then
				yOffset = 0.45
			end
			mesh.Offset = Vector3.new(0, yOffset, 0)
		end
	end
end

function module:ChangeFace(char, faceId)
	local head = char:FindFirstChild("Head")
	if head then
		local face = head:FindFirstChild("face")
		if face then
			face.Texture = "rbxassetid://"..faceId
		end
	end
end

function module:BecomeTargetPlayer(player, targetId)
	local humanoid = modules.cf:GetHumanoid(player)
	if humanoid then
		local success, desc
		--[[local plr = main.players:GetPlayerByUserId(targetId)
		if plr and not useOriginal then
			success, desc = pcall(function() return plr.Character.Humanoid:GetAppliedDescription() end)
		else--]]
			success, desc = pcall(function() return main.players:GetHumanoidDescriptionFromUserId(targetId) end)
		--end
		if success then
			pcall(function() humanoid:ApplyDescription(desc) end)
		end
	end
end

function module:ClearCharacter(character)
	for a,b in pairs(character:GetDescendants()) do
		if b:IsA("Shirt") or b:IsA("ShirtGraphic") or b:IsA("Pants") or b:IsA("Accessory") or b:IsA("Hat") or b:IsA("CharacterMesh") or b:IsA("BodyColors") then
			b:Destroy()
		elseif b.Name == "Chest" or b.Name == "Arm1" or b.Name == "Arm2" or b.Name == "Leg1" or b.Name == "Leg2" or b.Name == "ExtraFeatures" or b.Name == "ExtraFace" then
			b:Destroy()
		end
	end
end

--This gets really messy and I'm not proud of it, however I'm keeping it in as players enjoy the classic morphs
function module:OldMorphHandler(plr, char, morph, rigType)
	local head = char.Head
	if rigType == Enum.HumanoidRigType.R15 then
		modules.cf:ConvertCharacterToRig(plr, "R6")
		char = plr.Character
	end
	for i,v in pairs(morph:GetChildren()) do
		if v.ClassName == "Model" then
			local body_type = "Nothing"
			if v.Name == "Chest" then
				body_type = "Torso"
			elseif v.Name == "Arm1" then
				body_type = "Left Arm"
			elseif v.Name == "Arm2" then
				body_type = "Right Arm"
			elseif v.Name == "Leg1" then
				body_type = "Left Leg"
			elseif v.Name == "Leg2" then
				body_type = "Right Leg"
			end
			local body_part = v:clone()
			body_part.Parent = char
			local C = body_part:GetChildren()
			for i=1, #C do
				if C[i].className == "Part" or C[i].className == "UnionOperation" then
					local W = Instance.new("Weld")
					W.Part0 = body_part.Middle
					W.Part1 = C[i]
					local CJ = CFrame.new(body_part.Middle.Position)
					local C0 = body_part.Middle.CFrame:inverse()*CJ
					local C1 = C[i].CFrame:inverse()*CJ
					W.C0 = C0
					W.C1 = C1
					W.Parent = body_part.Middle
				end
				local Y = Instance.new("Weld")
				Y.Part0 = char[body_type]
				Y.Part1 = body_part.Middle
				Y.C0 = CFrame.new(0, 0, 0)
				Y.Parent = Y.Part0--]]
			end
			for a,b in pairs(body_part:GetChildren()) do
				if b.ClassName == "Part" or b.ClassName == "UnionOperation" then
					b.CanCollide = false
					b.Anchored = false
				end
				if b.Name == "Face" then
					char.Head.face.Texture = b.Decal.Texture
					b:Destroy()
				elseif b.Name == "Head" then
					char.FakeHead.BrickColor = b.BrickColor
					b:Destroy()
				end
			end
		elseif v.Name == "FakeHead" then
			if v:FindFirstChild("Decal") then
				if char.Head:FindFirstChild("face") then
					char.Head.face.Texture = v.Decal.Texture
				end
			end
			head.BrickColor = v.BrickColor
			head.Transparency = v.Transparency
			for c,d in pairs(v:GetChildren()) do
				if d.ClassName == "SpecialMesh" then
					d:Clone().Parent = head
				end
			end
			--
		elseif v.ClassName == "CharacterMesh" then
			v:Clone().Parent = char
			v.Name = "CharacterMesh"
		elseif v.ClassName == "Accessory" or v.ClassName == "Hat" then
			local accessory = v:Clone()
			accessory.Parent = char
			if accessory:FindFirstChild("Handle") then
				accessory.Handle.Anchored = false
			end
		end
	end
	if morph.Chest:FindFirstChild("Ab") then
		for a,b in pairs(char:GetChildren()) do
			if b.Name == "Left Arm" or b.Name == "Right Arm" or b.Name == "Left Leg" or b.Name == "Right Leg" then
				b.Transparency = 0
				b.BrickColor = head.BrickColor
			elseif b.Name == "Torso" then
				b.Transparency = 0
				b.BrickColor = char.Chest.Ab.BrickColor
			end
		end
	else
		for a,b in pairs(char:GetChildren()) do
			if b:IsA("BasePart") and b.Name ~= "FakeHead" and b.Name ~= "Radio" then
				b.Transparency = 1
			end
		end
	end
end

function module:AddExtraFeatures(plr, char, morph)
	if morph:FindFirstChild("ExtraFeatures") then
		local g = morph.ExtraFeatures:clone()
		g.Name = "ExtraFeatures"
		g.Parent = char
		for a,b in pairs(g:GetChildren()) do
			if b.className == "Part" or b.className == "UnionOperation" then
				local W = Instance.new("Weld")
				W.Part0 = g.Middle
				W.Part1 = b
				local CJ = CFrame.new(g.Middle.Position)
				local C0 = g.Middle.CFrame:inverse()*CJ
				local C1 = b.CFrame:inverse()*CJ
				W.C0 = C0
				W.C1 = C1
				W.Parent = g.Middle
			end
			local Y = Instance.new("Weld")
			Y.Part0 = char["Head"]
			Y.Part1 = g.Middle
			Y.C0 = CFrame.new(0, 0, 0)
			Y.Parent = Y.Part0
		end
		for a,b in pairs(g:GetChildren()) do
			b.Anchored = false
			b.CanCollide = false
		end
	end
end

local function setDeathEnabled(humanoid,value)
	humanoid:SetStateEnabled("Dead",value)
	wait()
	if humanoid:FindFirstChild("SetDeathEnabled") then
		local char = humanoid.Parent
		local player = game.Players:GetPlayerFromCharacter(char)
		if player then
			pcall(function() humanoid.SetDeathEnabled:InvokeClient(player,value) end)
		end
	end
end
local function prepareJointVerifier(humanoid)
	local verifyJoints = humanoid:FindFirstChild("VerifyJoints")
	if not verifyJoints then
		local disableDeath = Instance.new("RemoteFunction")
		disableDeath.Name = "SetDeathEnabled"
		disableDeath.Parent = humanoid
		local validator = main.server.Assets.PackageValidator:Clone()
		validator.Parent = humanoid	
		verifyJoints = Instance.new("RemoteFunction")
		verifyJoints.Name = "VerifyJoints"
		verifyJoints.Parent = humanoid
		validator.Disabled = false
	end
	return verifyJoints
end
function module:Morph(plr, morph)
	local humanoid = modules.cf:GetHumanoid(plr)
	if humanoid then
		local char = plr.Character
		local rigType = humanoid.RigType
		local tag = char:FindFirstChild("CharTag")
		if tag == nil or tag.Value ~= morph.Name then
			module:ClearFakeBodyParts(char)
			module:ClearCharacter(char)
			if morph:FindFirstChild("Chest") then
				module:OldMorphHandler(plr, char, morph, rigType)
				char = plr.Character
			else
				----------------------------------------------------------------
				local tag = Instance.new("StringValue")
				tag.Name = "CharTag"
				tag.Parent = char
				--Humanoid
				local model = morph:Clone()
				local hum_values = {}
				for a,b in pairs(model.Humanoid:GetChildren()) do
					if b:IsA("NumberValue") then
						hum_values[b.Name] = b.Value
					end
				end
				for a,b in pairs(model:GetDescendants()) do
					if b:IsA("BasePart") then
						b.Anchored = false
					end
				end
				model.Humanoid:Destroy()
				----- << GET PACKAGE >>
				local package = Instance.new("Folder")
				local r15 = Instance.new("Folder")
				r15.Name = "R15"
				r15.Parent = package
				for a,r15_part in pairs(model:GetChildren()) do
					if r15_part:IsA("BasePart") and r15_part.Name ~= "Head" and r15_part.Name ~= "HumanoidRootPart"  then
						r15_part:Clone().Parent = r15
					end
				end
				---- << APPLY PACKAGE >>
				if rigType == Enum.HumanoidRigType.R15 then
					local verifyJoints
					local player = game.Players:GetPlayerFromCharacter(char)
					if player then
						verifyJoints = prepareJointVerifier(humanoid)
						humanoid:UnequipTools()
					end
					local accessories = {}
					for _,child in pairs(char:GetChildren()) do
						if child:IsA("Accoutrement") then
							child.Parent = nil
							table.insert(accessories,child)
						end
					end
					setDeathEnabled(humanoid,false)
					for _,newLimb in pairs(package.R15:GetChildren()) do
						local oldLimb = char:FindFirstChild(newLimb.Name)
						if oldLimb then
							newLimb.BrickColor = oldLimb.BrickColor
							newLimb.CFrame = oldLimb.CFrame
							oldLimb:Destroy()
						end
						newLimb.Parent = char
					end
					humanoid:BuildRigFromAttachments()
					if player then
						pcall(function ()
							local attempts = 0
							while attempts < 10 do
								local success = verifyJoints:InvokeClient(player)
								if success then
									break
								else
									attempts = attempts + 1
								end
							end
							if attempts == 10 then
								warn("Failed to apply package to ",player)
							end
						end)
					end
					for _,accessory in pairs(accessories) do
						accessory.Parent = char
					end
					setDeathEnabled(humanoid,true)
					package:Destroy()
				end
				-- Clear
				wait()
				for a,b in pairs(char:GetChildren()) do
					if b:IsA("Accessory") or b:IsA("Hat") or b:IsA("ForceField") or b:IsA("Clothing") or b.Name == "Body Colors" or b.ClassName == "ShirtGraphic" then
						b:Destroy()
					end
					if b.Name == "Head" then
						for c,d in pairs(b:GetChildren()) do
							if d:IsA("SpecialMesh") then
								--d:Destroy()
							end
						end
					end
					if b:FindFirstChild("BodyEffect") then
						b.BodyEffect:Destroy()
					end
				end
				-- Apply
				if char:WaitForChild("Head"):FindFirstChild("face") then
					char.Head.face:Destroy()
				end
				for a,b in pairs(hum_values) do
					if char.Humanoid:FindFirstChild(a) == nil then
						local val = Instance.new("NumberValue")
						val.Name = a
						val.Parent = char.Humanoid
					end
					char.Humanoid[a].Value = b
				end
				char.Head.Transparency = morph.Head.Transparency
				tag.Value = morph.Name
				if model.Head:FindFirstChild("face") then
					model.Head.face.Parent = char.Head
				end
				--local scale = model.Head.Mesh.Scale
				local plrMesh = char.Head:FindFirstChildOfClass("SpecialMesh")
				if not plrMesh then
					plrMesh = Instance.new("SpecialMesh")
					plrMesh.Parent = char.Head
				end
				local headMesh = model.Head.Mesh
				if headMesh then
					if string.match(headMesh.MeshId, "%d") == nil then
						plrMesh.MeshType = Enum.MeshType.Head
					else
						plrMesh.MeshId = headMesh.MeshId
					end
					plrMesh.TextureId = headMesh.TextureId
					plrMesh.Offset = headMesh.Offset
					plrMesh.Scale = headMesh.Scale
				end
				for a,b in pairs(model:GetChildren()) do
					if b.Name == "Shirt" or b.Name == "Pants" or b.Name == "Body Colors" or b.ClassName == "ShirtGraphic" then
						b.Parent = char
					elseif b.Name == "face" then
						b.Parent = char.Head
					elseif b.ClassName == "Accessory" or b.ClassName == "Hat" then
						humanoid:AddAccessory(b)
						local handle = b:FindFirstChild("Handle")
						if handle and handle:FindFirstChild("Mesh") == nil then
							handle.Transparency = 1
						end
					elseif b:IsA("BasePart") then
						if b:FindFirstChild("BodyEffect") then
							b.BodyEffect:Clone().Parent = char.HumanoidRootPart
						end
					end
				end
				
				---------------------------
				local modelRigType = Enum.HumanoidRigType.R15
				if model:FindFirstChild("Torso") then
					modelRigType = Enum.HumanoidRigType.R6
				end
				if rigType ~= modelRigType then
					local function updateCorrespondingPart(cPart, mPart)
						cPart.Transparency = mPart.Transparency
					end
					for r6Name, r15Table in pairs(correspondingBodyParts) do
						local modelBodyPart = model:FindFirstChild(r6Name)
						if modelBodyPart then
							for i, correspondingPartName in pairs(r15Table) do
								local correspondingPart = char:FindFirstChild(correspondingPartName)
								if correspondingPart then
									updateCorrespondingPart(correspondingPart, modelBodyPart)
								end
							end
						else
							local correspondingPart = char:FindFirstChild(r6Name)
							if correspondingPart then
								for i, modelBodyPartName in pairs(r15Table) do
									local modelBodyPart = model:FindFirstChild(modelBodyPartName)
									if modelBodyPart then
										updateCorrespondingPart(correspondingPart, modelBodyPart)
									end
								end
							end
						end
					end
				end
				module:UpdateHipHeight(char)
				----------------------------------------------------------------
				model:Destroy()
			end
		end
		module:AddExtraFeatures(plr, char, morph)
		if tag then
			tag:Destroy()
		end
		------------------
		if char.Head:FindFirstChild("face") == nil then
			local decal = Instance.new("Decal")
			decal.Name = "face"
			decal.Texture = ""
			decal.Parent = char.Head
		end
		if char then
			if morph.Name == "Domo" or morph.Name == "Minion" or morph.Name == "MachoObliviousHD" or morph.Name == "Slender" or morph.Name == "EvilObliviousHD" or morph.Name == "BigMomma" then
				char.Head.Transparency = 1
				if char.Head:FindFirstChild("face") then
					char.Head.face.Transparency = 1
				end
			else
				char.Head.Transparency = 0
				if char.Head:FindFirstChild("face") then
					char.Head.face.Transparency = 0
				end
			end
			if morph.Name == "Golden Bob" then
				char.Head.Reflectance = 0.5
			else
				char.Head.Reflectance = 0
			end
		end
		---------------
	end
end
--[[
for a,b in pairs(game.ServerScriptService.MainModule.Server.Morphs:GetDescendants()) do
	if b:IsA("Decal") and b.Name ~= "face" and b.Parent.Name == "Head" then
		print("CHANGED: ".. b.Name.." | "..b.Parent.Parent.Name)
		b.Name = "face"
	end
end
--]]

local bundleCache = {} -- cache HumanoidDescriptions retrieved from bundles to reduce API calls
function module:ApplyBundle(humanoid, bundleId)
	local HumanoidDescription = bundleCache[bundleId]
	if not HumanoidDescription then
		local success, bundleDetails = pcall(function() return main.server.Assetservice:GetBundleDetailsAsync(bundleId) end)
		if success and bundleDetails then
			for _, item in next, bundleDetails.Items do
				if item.Type == "UserOutfit" then
					success, HumanoidDescription = pcall(function() return main.players:GetHumanoidDescriptionFromOutfitId(item.Id) end)
					bundleCache[bundleId] = HumanoidDescription
					break
				end
			end
		end
	end
	if not HumanoidDescription then return end
	local newDescription = humanoid:GetAppliedDescription()
	local defaultDescription = Instance.new("HumanoidDescription")
	for _, property in next, {"BackAccessory", "BodyTypeScale", "ClimbAnimation", "DepthScale", "Face", "FaceAccessory", "FallAnimation", "FrontAccessory", "GraphicTShirt", "HairAccessory", "HatAccessory", "Head", "HeadColor", "HeadScale", "HeightScale", "IdleAnimation", "JumpAnimation", "LeftArm", "LeftArmColor", "LeftLeg", "LeftLegColor", "NeckAccessory", "Pants", "ProportionScale", "RightArm", "RightArmColor", "RightLeg", "RightLegColor", "RunAnimation", "Shirt", "ShouldersAccessory", "SwimAnimation", "Torso", "TorsoColor", "WaistAccessory", "WalkAnimation", "WidthScale"} do
		if HumanoidDescription[property] ~= defaultDescription[property] then -- property is not the default value
			newDescription[property] = HumanoidDescription[property]
		end
	end
	humanoid:ApplyDescription(newDescription)
end




return module
