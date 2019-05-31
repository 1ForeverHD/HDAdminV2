-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules
local settings = main.settings



-- << VARIABLES >>
local hiddenGuis = {}
local lasersActive = {}
local originalNecks = {}
local laserTweenTime = 0.7
local laserTweenInfo = TweenInfo.new(laserTweenTime)



-- << CLIENT COMMANDS >>
local module = {
	
	----------------------------------------------------------------------
	["blur"] = {
		Function = function(speaker, args)
			main.blur.Size = (args[2] ~= 0 and args[2]) or 20
		end;
		UnFunction = function(speaker, args)
			main.blur.Size = 0
		end;
		};
	
	
	
	
	----------------------------------------------------------------------
	["showGuis"] = {
		Function = function(speaker, args)
			for a,b in pairs(hiddenGuis) do
				a.Enabled = true
			end
			hiddenGuis = {}
		end;
		};
	
	
	
	
	----------------------------------------------------------------------
	["hideGuis"] = {
		Function = function(speaker, args)
			for a,b in pairs(main.playerGui:GetChildren()) do
				if b:IsA("ScreenGui") and b.Name ~= "Chat" and b.Name ~= "HDAdminGUIs" then
					if b.Enabled == true then
						hiddenGuis[b] = true
					end
					b.Enabled = false
				end
			end
		end;
		};
	
	
	
	
	----------------------------------------------------------------------
	["view"] = {
		Function = function(speaker, args)
			local plr = args[1]
			local humanoid = modules.cf:GetHumanoid(plr)
			if humanoid then
				modules.cf:ChangeCameraSubject(humanoid)
			end
		end;
		UnFunction = function(speaker, args)
			local humanoid = modules.cf:GetHumanoid(speaker)
			if humanoid then
				main.signals.ChangeCameraSubject:FireClient(speaker, (humanoid))
			end
		end
		};
	
	
	
	
	----------------------------------------------------------------------
	["nightVision"] = {
		Function = function(speaker, args)
			for _,plr in pairs(main.players:GetChildren()) do
				local head = modules.cf:GetHead(plr)
				if plr.Name ~= main.player.Name and head then
					for a,b in pairs(plr.Character:GetChildren()) do
						if b:IsA("BasePart") and b:FindFirstChild("HDNightVision") == nil then
							for i = 1,6 do
								local nv = main.client.Assets.NightVision:Clone()
								nv.Parent = b 
								nv.Face = i-1
								nv.Name = "HDAdminNightVision"
							end
						end
					end
					local nv = main.client.Assets.Nickname:Clone()
					nv.TextLabel.Text = plr.Name
					nv.Parent = head
					nv.Name = "HDAdminNightVision"
				end
			end
		end;
		UnFunction = function(speaker, args)
			for _,plr in pairs(main.players:GetChildren()) do
				if plr.Character then
					for a,b in pairs(plr.Character:GetDescendants()) do
						if b.Name == "HDAdminNightVision" then
							b:Destroy()
						end
					end
				end
			end
		end;
		};
	
	
	
	
	----------------------------------------------------------------------
	["cmdbar"] = {
		Function = function(speaker, args)
			modules.CmdBar:OpenCmdBar()
		end;
		};
	
	
	
	
	----------------------------------------------------------------------
	["cmdbar2"] = {
		Function = function(speaker, args)
			modules.cf:CreateNewCommandMenu("cmdbar2", {}, 2)
		end;
		};
	
	
	
	
	----------------------------------------------------------------------
	["poop"] = {
		Function = function(speaker, args)
			local plr = args[1]
			local maxPoops = 20
			local poopSounds = {174658105,148635119}
			local function poopSound(sound_id,part)
				local soundPoop = Instance.new("Sound",part)
				soundPoop.SoundId = "rbxassetid://"..sound_id
				soundPoop.Volume = 0.5
				soundPoop:Play()
				repeat wait() until soundPoop.IsPlaying
				wait()
			end
			local function poop(clone,toilet,sound_id,poopCount, poopGroup)
				local poop = main.client.Assets.Poop:Clone()
				poopSound(sound_id,poop)
				poop.CanCollide = false
				poop.CFrame = toilet.Seat.CFrame * CFrame.new(0,(poopCount*1)-0.5,0)
				clone:SetPrimaryPartCFrame(poop.CFrame * CFrame.new(0,3,0))
				poop.Parent = poopGroup
			end
			
			local head = modules.cf:GetHead(plr)
			if not head then return end
			
			local originalCFrame = head.CFrame
			
			plr.Character.Parent = nil
			local clone, tracks = modules.cf:CreateClone(plr.Character)
			--
			if tracks.sit.Length <= 0 then repeat wait() until tracks.sit.Length > 0 end
			--
			clone.Head.CFrame = originalCFrame
			if plr == main.player then
				modules.cf:Movement(false)
				modules.cf:ChangeCameraSubject(clone.Humanoid)
			end
			--modules.cf:SetTransparency(plr.Character, 1)
			
			
			local poopCount = 0
			local poopGroup = Instance.new("Model",workspace)
			local toilet = main.client.Assets.Toilet:Clone()
			
			poopGroup.Name = plr.Name.."'s poop"
			toilet.PrimaryPart = toilet.Seat
			toilet:SetPrimaryPartCFrame(clone.HumanoidRootPart.CFrame * CFrame.new(0,-1,0)) --* CFrame.Angles(0,math.rad(90), 0))
			toilet.Parent = workspace
			toilet.Seat:Sit(clone.Humanoid)
			tracks.sit:Play(0)
			clone.Head.face.Texture = "rbxassetid://304907108"
			wait()
			clone.PrimaryPart = clone.Head
			clone:SetPrimaryPartCFrame(toilet.PrimaryPart.CFrame * CFrame.new(0,3,0))
			for a,b in pairs(clone:GetChildren()) do
				if b:IsA("BasePart") and b.Name ~= "HumanoidRootPart" then
					b.Anchored = true
				end
			end
			wait(1)
			--
			poopSound(174658105,clone.HumanoidRootPart)
			wait(2)
			poopCount = poopCount + 1
			poop(clone,toilet,148635119,poopCount, poopGroup, poopGroup)
			clone.Head.face.Texture = "rbxassetid://338312149"
			wait(1.5)
			clone.Head.face.Texture = "rbxassetid://316545711"
			for i = 1,maxPoops do
				if i == maxPoops-2 then
					for a,b in pairs(clone:GetChildren()) do
						if b:IsA("BasePart") and b.Name ~= "HumanoidRootPart" then
							b.Anchored = false
						end
					end
					local explosion = Instance.new("Explosion")
					explosion.Position = clone.Head.Position
					explosion.Parent = clone
					explosion.DestroyJointRadiusPercent = 0
					clone:BreakJoints()
				elseif i > maxPoops-1 then
					for a,b in pairs(poopGroup:GetChildren()) do
						b.Anchored = false
						b.CanCollide = true
					end
				end
				poopCount = poopCount + 1
				if i >= maxPoops then
					wait(1.5)
				else
					poop(clone,toilet,poopSounds[math.random(1,#poopSounds)],poopCount, poopGroup)
					wait()
				end
			end
			
			wait(3)
			poopGroup:Destroy()
			toilet:Destroy()
			clone:Destroy()
			
			if plr == main.player then
				local humanoid = modules.cf:GetHumanoid(plr)
				if humanoid then
					modules.cf:Movement(true)
					modules.cf:ChangeCameraSubject(humanoid)
				end
			end
			--modules.cf:SetTransparency(plr.Character, 0)
			plr.Character.Parent = workspace
		end;
		};
	
	
	
	
	----------------------------------------------------------------------
	["icecream"] = {
		Function = function(speaker, args)
			local plr = args[1]
			
			--Create clone and hide char
			plr.Character.Parent = nil
			local clone, tracks = modules.cf:CreateClone(plr.Character)
			local hrp = clone:FindFirstChild("HumanoidRootPart")
			if hrp == nil then clone:Destroy() return end
			hrp.Anchored = true
			--tracks.idle:Play()
			--modules.cf:SetTransparency(plr.Character, 1)
			
			--Create van
			local van = main.client.Assets.IcecreamVan:Clone()
			van.PrimaryPart = van.VanDoor.Part1
			van:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(-210,3,-4) * CFrame.Angles(0,math.rad(90), 0))
			van.Parent = workspace
			
			--Disable movement and set camera if player == plr
			if plr == main.player then
				modules.cf:Movement(false)
				modules.cf:ChangeCameraSubject(clone.Humanoid)
				for a,b in pairs(van:GetDescendants()) do
					if b:IsA("BasePart") then
						b.CanCollide = true
					end
				end
			end
			
			--Setup Sounds
			local soundIcecream = modules.cf:CreateSound{SoundId = 260910474, Volume = 0.5, Parent = van.PrimaryPart}
			local soundClowns = modules.cf:CreateSound{SoundId = 861942173, Volume = 4, Parent = van.PrimaryPart}
			local soundBaby = modules.cf:CreateSound{SoundId = 2628538600, Volume = 0.15, Parent = van.PrimaryPart}
			local soundScream = modules.cf:CreateSound{SoundId = 147758746, Volume = 0.8, Parent = van.PrimaryPart}
			
			--Tween van to plr
			soundIcecream:Play()
			modules.cf:TweenModel(van, van.PrimaryPart.CFrame * CFrame.new(0, 0, 210), TweenInfo.new(8))
			wait(8.1)
			local tween = main.tweenService:Create(soundIcecream, TweenInfo.new(0.5), {Volume = 0})
			tween:Play()
			tween.Completed:Wait()
			soundIcecream:Stop()
			soundIcecream:Destroy()
			wait(1)
			
			--Open doors, get plr and close doors
			van.VanDoor.Part1.Transparency = 1
			van.VanDoor.Part2.Transparency = 1
			wait(1)
			clone.PrimaryPart = clone.Head
			clone:SetPrimaryPartCFrame(van.Clown.Head.CFrame * CFrame.new(0,0,-2.5) * CFrame.Angles(0,math.rad(180), 0))
			local originalMinZoom = plr.CameraMinZoomDistance
			local originalMaxZoom = plr.CameraMaxZoomDistance
			if plr == main.player then
				plr.CameraMaxZoomDistance = 0.5
				spawn(function()
					plr.CameraMaxZoomDistance = 1
				end)
			end
			local face = clone.Head:FindFirstChild("face")
			if face then
				face.Texture = "rbxassetid://338312149"
			end
			soundClowns:Play()
			wait(1)
			van.VanDoor.Part1.Transparency = 0
			van.VanDoor.Part2.Transparency = 0
			clone.Parent = van
			for a,b in pairs(clone:GetChildren()) do
				if b:IsA("Accessory") then
					b:remove()
				end
			end
			
			--Tween van away
			soundIcecream:Play()
			modules.cf:TweenModel(van, van.PrimaryPart.CFrame * CFrame.new(0, 0, 400), TweenInfo.new(14, Enum.EasingStyle.Quad, Enum.EasingDirection.In))
			
			--Show scary stuff and scream
			wait(4)
			local arm = van.Clown["Right Arm"]
			arm.CFrame = arm.CFrame * CFrame.fromEulerAnglesXYZ(math.rad(45), 0, 0)
			for a,b in pairs(van.Doll:GetChildren()) do
				b.Transparency = 0
			end
			van.Doll.Head.face.Transparency = 0
			wait(0.1)
			soundBaby:Play()
			wait(1.5)
			soundScream:Play()
			if face then
				face.Texture = "rbxassetid://288918236"
			end
			wait(2.5)
			
			--Explode
			if plr == main.player then
				local explosion = Instance.new("Explosion")
				explosion.Position = clone.Head.Position
				explosion.Parent = clone
				clone:BreakJoints()
				main.audio.Oof:Play()
			end
			
			wait(5)
			--Destroy van and reset player
			if plr == main.player then
				local humanoid = modules.cf:GetHumanoid(plr)
				if humanoid then
					modules.cf:Movement(true)
					modules.cf:ChangeCameraSubject(humanoid)
				end
				plr.CameraMaxZoomDistance = 20
				wait()
				plr.CameraMinZoomDistance = 20
				wait()
				plr.CameraMinZoomDistance = originalMinZoom
				plr.CameraMaxZoomDistance = originalMaxZoom
			end
			--modules.cf:SetTransparency(plr.Character, 0)
			if plr.Character then
				plr.Character.Parent = workspace
			end
			van:Destroy()
		end;
		};
	
	
	
	
	----------------------------------------------------------------------
	["laserEyes"] = {
		DisplayLaser = function(laserHead, laserTarget, status)
			local leftBeam = laserTarget:FindFirstChild("LeftBeam")
			if leftBeam then
				leftBeam.Enabled = status
				laserTarget.RightBeam.Enabled = status
				laserTarget.MidAttachment.GlowHit.Enabled = status
			end
		end;
		
		Activate = function(self)
			local commandName = self.Name
			local head = modules.cf:GetHead()
			local humanoid = modules.cf:GetHumanoid()
			local hrp = modules.cf:GetHRP()
			if head and humanoid and main.mouseDown then
				local laserHead = head:FindFirstChild("HDAdminLaserHead")
				local neck = modules.cf:GetNeck()
				local r6 = false
				if humanoid.RigType == Enum.HumanoidRigType.R6 then
					r6 = true
				end
				head.Parent.PrimaryPart = hrp
				if laserHead and neck then
					
					local maxDistance = 30
					local lastUpdate = tick()-1
					local originalC0 = neck.C0
					local additionalY =  humanoid.HipHeight/2.5
					local laserTarget = laserHead.LaserTarget
					local fire = laserTarget.MidAttachment2.Fire
					local sparks = laserTarget.MidAttachment.Sparks
					local sizzle = main.audio.Sizzle
					local sizzle2 = main.audio.Sizzle2
					sizzle:Play()
					self.DisplayLaser(laserHead, laserTarget, true)
					
					repeat
						local hit, position = modules.cf:GetMousePoint(main.lastHitPosition)
						local targetCFrame = CFrame.new(position, head.Position)
						local distanceFromPlayer = main.player:DistanceFromCharacter(targetCFrame.p)
						local exceededMaxDistance = false
						if distanceFromPlayer > maxDistance then
							targetCFrame = targetCFrame * CFrame.new(0, 0, maxDistance-distanceFromPlayer)
							exceededMaxDistance = true
						end
						laserTarget.CFrame = targetCFrame
						local headPos = head.Position
						local targetPos = laserTarget.Position
						local direction = (Vector3.new(targetPos.X, headPos.Y, targetPos.Z) - head.Position).Unit
						if head.Parent.PrimaryPart == nil then
							head.Parent.PrimaryPart = head.parent.HumanoidRootPart
						end
						local lookCFrame = (CFrame.new(Vector3.new(), (head.Parent.PrimaryPart.CFrame):VectorToObjectSpace(direction)))
						if r6 then
							lookCFrame = lookCFrame * CFrame.new(0,1,0) * CFrame.fromEulerAnglesXYZ(math.rad(90),math.rad(180),0)
						else
							lookCFrame = lookCFrame * CFrame.new(0,additionalY,0)
						end
						neck.C0 = lookCFrame
						if tick() - 0.6 > lastUpdate then
							lastUpdate = tick()
							main.signals.UpdateNearbyPlayers:FireServer("laserEyes", {targetCFrame, lookCFrame})
						end
						if hit and not exceededMaxDistance and (hit.Parent:FindFirstChild("Humanoid") or hit.Name == "Handle") then
							fire.Enabled = true
							sparks.Enabled = true
							if not sizzle2.Playing then
								sizzle2:Play()
							end
						else
							fire.Enabled = false
							sparks.Enabled = false
							if sizzle2.Playing then
								sizzle2:Stop()
							end
						end
						wait()
						
					until not main.mouseDown or not main.commandsActive[commandName] or not head or not head.Parent or not neck
					neck.C0 = originalC0
					self.DisplayLaser(laserHead, laserTarget, false)
					fire.Enabled = false
					sparks.Enabled = false
					sizzle:Stop()
					sizzle2:Stop()
				end
			end
			main.commandsActive[commandName] = nil
		end;
		
		Function = function(speaker, args, self)
			local plr = speaker
			local targetCFrame, lookCFrame = args[1], args[2]
			local head = modules.cf:GetHead(plr)
			if head then
				local laserHead = head:FindFirstChild("HDAdminLaserHead")
				local neck = modules.cf:GetNeck(plr)
				if laserHead and neck then
					local laserTarget = laserHead.LaserTarget
					--Laser is already active
					if lasersActive[plr] then
						lasersActive[plr] = lasersActive[plr] + 1
					else -- New laser
						lasersActive[plr] = 1
						originalNecks[plr] = neck.C0
						local randomZ = math.random(10,40) - 15
						laserTarget.CFrame = targetCFrame * CFrame.new(0, 0, randomZ)
						neck.C0 = lookCFrame
						laserTarget.MidAttachment.GlowHit.Rate = 50
						self.DisplayLaser(laserHead, laserTarget, true)
					end
					main.tweenService:Create(laserTarget, laserTweenInfo, {CFrame = targetCFrame}):Play()
					main.tweenService:Create(neck, laserTweenInfo, {C0 = lookCFrame}):Play()
					wait(laserTweenTime)
					lasersActive[plr] = lasersActive[plr] - 1
					if lasersActive[plr] <= 0 then
						self.DisplayLaser(laserHead, laserTarget, false)
						neck.C0 = originalNecks[plr]
						originalNecks[plr] = nil
						lasersActive[plr] = nil
					end
				end
			end
		end;
		};
	
	
	
	
	----------------------------------------------------------------------
	["warp"] = {
		Function = function(speaker, args)
			local maxDistort = 1
			local increment = 0.005
			local distort = maxDistort-increment
			local distortDirection = -increment
			repeat main.runService.RenderStepped:Wait()
				if distort < increment then
					distort = increment
					distortDirection = increment
				elseif distort > maxDistort then
					distort = maxDistort
					distortDirection = -increment
				end
				main.camera.CFrame = main.camera.CFrame*CFrame.new(0,0,0,distort,0,0,0,distort,0,0,0,1)
				distort = distort + distortDirection
			until distort > maxDistort
		end;
		};
	
	
	
	
	----------------------------------------------------------------------
	["fly"] = {
		Activate = function(self)
			modules.cf:Fly(self.Name)
		end;
		};
	
	
	
	
	----------------------------------------------------------------------
	["fly2"] = {
		Activate = function(self)
			modules.cf:Fly(self.Name)
		end;
		};
	
	
	
	
	----------------------------------------------------------------------
	["noclip"] = {
		Activate = function(self)
			local commandName = self.Name
			local humanoid = modules.cf:GetHumanoid()
			local hrp = modules.cf:GetHRP()
			if humanoid and hrp then
				local lastUpdate = tick()
				hrp.Anchored = true
				humanoid.PlatformStand = true
				repeat wait()
					local delta = tick()-lastUpdate
					local look = (main.camera.Focus.p-main.camera.CFrame.p).unit
					local move = modules.cf:GetNextMovement(delta, main.commandSpeeds[commandName])
					local pos = hrp.Position
					hrp.CFrame = CFrame.new(pos,pos+look) * move
					lastUpdate = tick()
					
				until not main.commandsActive[commandName]
				if hrp and humanoid then
					hrp.Anchored = false
					hrp.Velocity = Vector3.new()
					humanoid.PlatformStand = false
				end
			end
		end;
		};
	
	
	
	
	----------------------------------------------------------------------
	["clip"] = {
		Function = function(speaker, args, self)
			modules.cf:DeactivateCommand("noclip")
		end;
		};
	
	
	
	
	----------------------------------------------------------------------
	["boing"] = {
		ExpandTime = 4;
		ExpandAmount = 3;
		EndBoing = {};
		Function = function(speaker, args, self)
			local plr = args[1]
			local head = modules.cf:GetHead(plr)
			local humanoid = modules.cf:GetHumanoid(plr)
			if head and humanoid and not self.UnFunction(speaker, args, self) then
				local headMesh = head:FindFirstChild("Mesh")
				if headMesh then
					local hats = {}
					local character = plr.Character
					for a,b in pairs(character:GetChildren()) do
						if b:IsA("Accessory") then
							table.insert(hats, b)
							b.Parent = nil
						end
					end
					local originalScale = headMesh.Scale
					local tween = main.tweenService:Create(headMesh, TweenInfo.new(self.ExpandTime, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Scale = Vector3.new(originalScale.X, originalScale.Y * self.ExpandAmount, originalScale.Z)})
					tween:Play()
					--
					local endEvent = Instance.new("BindableEvent")
					self.EndBoing[plr] = endEvent
					modules.cf:WaitForEvent(endEvent, humanoid.Died, plr.CharacterAdded)
					self.EndBoing[plr] = nil
					endEvent:Destroy()
					--
					if headMesh then
						local tween = main.tweenService:Create(headMesh, TweenInfo.new(2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Scale = originalScale})
						tween:Play()
						tween.Completed:Wait()
					end
					for i,v in pairs(hats) do
						if character then
							v.Parent = character
						else
							v:Destroy()
						end
					end
				end
			end
		end;
		UnFunction = function(speaker, args, self)
			local plr = args[1]
			local endEvent = self.EndBoing[plr]
			if endEvent then
				endEvent:Fire()
				return true
			end
		end;
		};
	
	
	
	
	----------------------------------------------------------------------
	
};



-- << SETUP >>
for commandName, command in pairs(module) do
	command.Name = commandName
end



return module
