-- Referenced using 'main.modules.cf'

local module = {}


-- << RETRIEVE MAIN FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules



-- << VARIABLES >>
local unBan = main.warnings.UnBan
local permRank = main.warnings.PermRank
local menuTemplates = main.gui.MenuTemplates
local pmId = 1



-- << LOCAL FUNCTIONS >>
local function setupOriginalZIndex(frame, forceOnTop)
	for a,b in pairs(frame:GetDescendants()) do
		if b:IsA("GuiObject") and b:FindFirstChild("OriginalZIndex") == nil then
			local iValue = Instance.new("IntValue")
			iValue.Name = "OriginalZIndex"
			local zValue = b.ZIndex
			if forceOnTop then
				zValue = zValue + 10000
			end
			iValue.Value = zValue
			iValue.Parent = b
		end
	end
end
local function updateZIndex(list, specificFrame)
	for i,v in pairs(main.commandMenus) do
		for a,b in pairs(v:GetDescendants()) do
			if b:IsA("GuiObject") then
				if b:FindFirstChild("OriginalZIndex") and (not specificFrame or v == specificFrame) then
					b.ZIndex = b.OriginalZIndex.Value + ((i-1)*10) - 1000
				end
			end
		end
	end
end



-- << FUNCTIONS >>
function module:DeactivateCommand(commandName)
	main.commandsAllowedToUse[commandName] = nil
	main.commandsActive[commandName] = nil
	if not main.commandsToDisableCompletely[commandName] then
		local frame = main.gui:FindFirstChild("CommandMenu"..commandName)
		modules.cf:DestroyCommandMenuFrame(frame)
	end
end

function module:EndCommand(commandName)
	main.commandsActive[commandName] = nil
	modules.cf:UpdateCommandMenu(commandName)
end

function module:ActivateClientCommand(commandName, extraDetails)
	if main.commandsAllowedToUse[commandName] and not main.commandsActive[commandName] then
		if not(extraDetails and extraDetails.DontForceActivate and main.gui:FindFirstChild("CommandMenu"..commandName)) then
			main.commandsActive[commandName] = true
			spawn(function()
				modules.cf:UpdateCommandMenu(commandName)
				local clientCommand = modules.ClientCommands[commandName]
				if clientCommand then
					local Function = clientCommand["Activate"]
					if Function then
						Function(clientCommand)
					end
				end
				main.commandsActive[commandName] = nil
			end)
		end
	end
end

function module:GetCF(part, isFor)
	--Credit to Scel for this
	local cframe = part.CFrame
	local noRot = CFrame.new(cframe.p)
	local x, y, z = (workspace.CurrentCamera.CFrame - workspace.CurrentCamera.CFrame.p):toEulerAnglesXYZ()
	return noRot * CFrame.Angles(isFor and z or x, y, z)
end

function module:GetNextMovement(deltaTime, speed)
	local nextMove = Vector3.new()
	local directions = {
		Left = Vector3.new(-1, 0, 0);
		Right = Vector3.new(1, 0, 0);
		Forwards = Vector3.new(0, 0, -1);
		Backwards = Vector3.new(0, 0, 1);
		Up = Vector3.new(0, 1, 0);
		Down = Vector3.new(0, -1, 0);
	}
	if main.device == "Computer" then
		for i,v in pairs(main.movementKeysPressed) do
			local vector = directions[v]
			if vector then
				nextMove = nextMove + vector
			end
		end
	else
		local humanoid = modules.cf:GetHumanoid()
		local hrp = modules.cf:GetHRP()
		if humanoid then
			local md = humanoid.MoveDirection
			for i,v in pairs(directions) do
				local isFor = false
				if i == "Forwards" or i == "Backwards" then
					isFor = true
				end
				local vector = ((module:GetCF(hrp, true)*CFrame.new(v)) - hrp.CFrame.p).p;
				if (vector - md).magnitude <= 1.05 and md ~= Vector3.new(0,0,0) then
					nextMove = nextMove + v
				end
			end
		end
	end
	return CFrame.new(nextMove * speed * deltaTime), nextMove
end

function module:Fly(commandName)
	local lockType = "PlatformStand"
	if commandName == "fly2" then
		lockType = "Sit"
	end
	local hrp = modules.cf:GetHRP()
	local humanoid = modules.cf:GetHumanoid()
	if hrp and humanoid then
		-------------------------------------
		--[[
		--I attempted to use Constraints but can't get speed modifications to work with AlignPosition, so for now I'll be using legacy BodyPositions
		local flyPart = Instance.new("Part")
		flyPart.Anchored = true
		flyPart.CanCollide = false
		flyPart.Transparency = 1
		flyPart.Color = Color3.fromRGB(255,0,0)
		flyPart.Name = "HDAdminFlyPart"
		flyPart.Size = Vector3.new(1,1,1)
		flyPart.CFrame = hrp.CFrame * CFrame.new(0,4,0)
		flyPart.Parent = workspace
		local flyAttachment0 = Instance.new("Attachment")
		flyAttachment0.Name = "Attachment0"
		flyAttachment0.Parent = hrp
		local flyAttachment1 = Instance.new("Attachment")
		flyAttachment1.Name = "Attachment1"
		flyAttachment1.Parent = flyPart
		local flyForce = Instance.new("AlignPosition")
		flyForce.Name = "HDAdminFlyForce"
		flyForce.Attachment0 = flyAttachment0
		flyForce.Attachment1 = flyAttachment1
		flyForce.Enabled = false
		flyForce.Responsiveness = 5
		flyForce.ApplyAtCenterOfMass = false
		flyForce.Enabled = true
		flyForce.Parent = hrp
		local bodyGyro = Instance.new("BodyGyro")
		bodyGyro.D = 50
		bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
		bodyGyro.P = 200
		bodyGyro.Name = "HDAdminFlyGyro"
		bodyGyro.CFrame = hrp.CFrame
		bodyGyro.Parent = hrp
		local tiltMax = 25
		local tiltAmount = 0
		local tiltInc = 1
		-------------------------------------
		local lastUpdate = tick()
		local lastPosition = hrp.Position
		repeat
			local delta = tick()-lastUpdate
			local look = (main.camera.Focus.p-main.camera.CFrame.p).unit
			local speed = (main.commandSpeeds[commandName])*10
			local move, directionalVector = getNextMovement(delta, speed)
			local pos = hrp.Position
			local targetCFrame = CFrame.new(pos,pos+look) * move
			local responsiveness = 12000/speed
			if move.p ~= Vector3.new() then
				tiltAmount = tiltAmount + tiltInc
				flyForce.Responsiveness = responsiveness
				flyPart.CFrame = targetCFrame
			else
				tiltAmount = 1
				if (hrp.Position - lastPosition).magnitude > 6 then
					flyPart.CFrame = hrp.CFrame
				end
			end
			if math.abs(tiltAmount) > tiltMax then
				tiltAmount = tiltMax
			end
			if flyForce.Responsiveness == responsiveness then
				--bodyGyro.CFrame = targetCFrame
				local tiltX = tiltAmount * directionalVector.X * -0.5
				local tiltZ = tiltAmount * directionalVector.Z
				bodyGyro.CFrame = targetCFrame * CFrame.Angles(math.rad(tiltZ), 0, 0)
			end
			lastUpdate = tick()
			lastPosition = hrp.Position
			humanoid[lockType] = true
			wait()
		until not main.commandsActive[commandName] or not humanoid or not hrp
		flyPart:Destroy()
		flyForce:Destroy()
		flyAttachment0:Destroy()
		bodyGyro:Destroy()
		if humanoid then
			humanoid[lockType] = false
		end--]]
		local flyForce = Instance.new("BodyPosition")
		flyForce.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		flyForce.Position = hrp.Position + Vector3.new(0,4,0)
		flyForce.Name = "HDAdminFlyForce"
		flyForce.Parent = hrp
		local bodyGyro = Instance.new("BodyGyro")
		bodyGyro.D = 50
		bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bodyGyro.P = 200
		bodyGyro.Name = "HDAdminFlyGyro"
		bodyGyro.CFrame = hrp.CFrame
		bodyGyro.Parent = hrp
		local tiltMax = 25
		local tiltAmount = 0
		local tiltInc = 1
		local static = 0
		-------------------------------------
		local lastUpdate = tick()
		local lastPosition = hrp.Position
		repeat
			local delta = tick()-lastUpdate
			local look = (main.camera.Focus.p-main.camera.CFrame.p).unit
			local speed = main.commandSpeeds[commandName]
			local move, directionalVector = module:GetNextMovement(delta, speed*10)
			local pos = hrp.Position
			local targetCFrame = CFrame.new(pos,pos+look) * move
			local targetD = 750 + (speed*0.2)
			if move.p ~= Vector3.new() then
				static = 0
				flyForce.D = targetD
				tiltAmount = tiltAmount + tiltInc
				flyForce.Position = targetCFrame.p
			else
				static = static + 1
				tiltAmount = 1
				local maxMag = 6
				local mag = (hrp.Position - lastPosition).magnitude
				if mag > maxMag and static >= 4 then
					flyForce.Position = hrp.Position
				end
			end
			if math.abs(tiltAmount) > tiltMax then
				tiltAmount = tiltMax
			end
			if flyForce.D == targetD then
				local tiltX = tiltAmount * directionalVector.X * -0.5
				local tiltZ = tiltAmount * directionalVector.Z
				bodyGyro.CFrame = targetCFrame * CFrame.Angles(math.rad(tiltZ), 0, 0)
			end
			lastUpdate = tick()
			lastPosition = hrp.Position
			humanoid[lockType] = true
			wait()
		until not main.commandsActive[commandName] or not humanoid or not hrp
		flyForce:Destroy()
		bodyGyro:Destroy()
		if humanoid then
			humanoid[lockType] = false
		end--]]
	
	end
	main.commandsActive[commandName] = nil
end

function module:GetAssetImage(assetId)
	return("https://www.roblox.com/asset-thumbnail/image?assetId="..assetId.."&width=420&height=420&format=png")
end

function module:GetUserImage(userId)
	return("https://www.roblox.com/headshot-thumbnail/image?userId="..userId.."&width=420&height=420&format=png")
end

function module:ShowPermRankedUser(details)
	local plrName, userId, rankedById = details[1], details[2], details[3]
	permRank.PlrName.Text = plrName
	permRank.PlrImage.Image = module:GetUserImage(userId)
	permRank.RankedBy.TextLabel.Text = modules.cf:GetName(rankedById)
	modules.cf:ShowWarning("PermRank")
end

function module:ShowBannedUser(banDetails)
	local plrName, userId, reason, bannedById = banDetails[1], banDetails[2], banDetails[3], banDetails[4]
	print(tostring(plrName).. " | ".. tostring(userId).. " | ".. tostring(reason).. " | ".. tostring(bannedById))
	local reasonLabel = unBan.Reason.TextLabel
	unBan.PlrName.Text = plrName
	unBan.PlrImage.Image = module:GetUserImage(userId)
	unBan.BannedBy.TextLabel.Text = modules.cf:GetName(bannedById)
	reasonLabel.Text = "'"..reason.."'"
	if reasonLabel.Text == "" or reasonLabel.Text == " " then
		reasonLabel.Text = "Empty"
		reasonLabel.Font = Enum.Font.SourceSansItalic
	else
		reasonLabel.Font = Enum.Font.SourceSans
	end
	modules.cf:ShowWarning("UnBan")
end

function module:ShowWarning(warningName)
	for a,b in pairs(main.warnings:GetChildren()) do
		if b.Name == warningName then
			b.Visible = true
			main.warnings.Visible = true
		else
			b.Visible = false
		end
	end
end

function module:ChangeCameraSubject(newSubject)
	local face = modules.cf:GetFace()
	if face then
		local originalT = face.Transparency
		main.camera.CameraSubject = newSubject
		face.Transparency = originalT
	end
end

function module:DestroyCommandMenuFrame(frame)
	if frame then
		for i,v in pairs(main.commandMenus) do
			if v == frame then
				table.remove(main.commandMenus, i)
			end
		end
		frame:Destroy()
	end
end

function module:UpdateCommandMenu(commandName, frame)
	if frame == nil then
		frame = main.gui:FindFirstChild("CommandMenu"..commandName)
	end
	if frame then
		local mainFrame = frame.MainFrame
		local status = mainFrame:FindFirstChild("Status")
		if status then
			if (main.commandsToDisableCompletely[commandName] and main.commandsAllowedToUse[commandName]) or main.commandsActive[commandName] then
				mainFrame.Status.TextLabel.Text = "On"
				mainFrame.Status.TextLabel.TextColor3 = Color3.fromRGB(0, 225, 0)
				mainFrame.ChangeStatus.TextLabel.Text = "DISABLE"
			else
				mainFrame.Status.TextLabel.Text = "Off"
				mainFrame.Status.TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
				mainFrame.ChangeStatus.TextLabel.Text = "ENABLE"
			end
		end
	end
end
function module:CreateNewCommandMenu(commandName, menuDetails, menuType, forceOnTop)
	----------------------
	local framesToDestroyOnClose = {4, 8, 11, 12}
	local framesWithIncrementalNames = {4}
	local framesToDestroyExistingFrames = {--[[1,]] 6, 6, 7, 9, 12}
	----------------------
	menuType = tonumber(menuType)
	local destroyFrameOnClose = modules.cf:FindValue(framesToDestroyOnClose, menuType)
	local isAnIncrementalName = modules.cf:FindValue(framesWithIncrementalNames, menuType)
	local destroyExistingFrames = modules.cf:FindValue(framesToDestroyExistingFrames, menuType)
	local frameName = "CommandMenu"..commandName
	if isAnIncrementalName then
		frameName = "CommandMenu"..commandName..pmId
		pmId = pmId + 1
	end
	local frame = main.gui:FindFirstChild(frameName)
	if frame and destroyExistingFrames then
		frame:Destroy()
		frame = nil
	end
	if not frame then
		local frameTemplate = menuTemplates["Template"..menuType]
		local mainFrameTemplate = frameTemplate.MainFrame
		frame = frameTemplate:Clone()
		frame.Name = frameName
		local dragBar = frame.DragBar
		local mainFrame = frame.MainFrame
		local commandNameSplit = string.upper(string.gsub(commandName, "%u", function(c) return " "..c end))
		dragBar.Title.Text = commandNameSplit
		modules.InputHandler:MakeFrameDraggable(frame)
		dragBar.Close.MouseButton1Down:Connect(function()
			if destroyFrameOnClose then
				module:DestroyCommandMenuFrame(frame)
			else
				frame.Visible = false
			end
		end)
		local originalY = mainFrame.Position.Y.Scale
		local yTweenTarget = -(1 - dragBar.Size.Y.Scale - originalY)
		local minimise = dragBar:FindFirstChild("Minimise")
		if minimise then
			minimise.MouseButton1Down:Connect(function()
				if minimise.TextLabel.Text == "-" then
					main.tweenService:Create(mainFrame, TweenInfo.new(0.5), {Position = UDim2.new(0,0,yTweenTarget,-1)}):Play()
					minimise.TextLabel.Text = "+"
				else
					main.tweenService:Create(mainFrame, TweenInfo.new(0.5), {Position = UDim2.new(0,0,originalY,0)}):Play()
					minimise.TextLabel.Text = "-"
				end
			end)
		end
		
		-- << SHARED >>
		--updateCanvasSize(scrollFrame, scrollFrame["Answer"..#data.Answers], scrollFrame.Question)
		local function updateCanvasSize(scrollFrame, finalLabel, firstLabel)
			scrollFrame.CanvasSize = UDim2.new(0, 0, 0, (finalLabel.AbsolutePosition.Y - firstLabel.AbsolutePosition.Y) + finalLabel.AbsoluteSize.Y)
		end
		
		local function selectToggle(selectFrame, toggleName, ov)
			local defaultToggles, finalFunction, scrollFrame, finalLabel, firstLabel = ov[1],ov[2],ov[3],ov[4],ov[5]
			local button = selectFrame:FindFirstChild(toggleName)
			if not button then
				toggleName = defaultToggles[selectFrame.Name]
			end
			---------------
			if selectFrame.Name == "AC Server" and toggleName == "All" and main.pdata.Rank < main.commandRanks.globalvote then
				modules.Notices:Notice("Error", "HD Admin", "Must be '".. modules.cf:GetRankName(main.commandRanks.globalvote).."' to use ;globalVote")
			else
			--------------
				for a,b in pairs(selectFrame:GetChildren()) do
					if b:IsA("TextButton") then
						finalFunction(b, toggleName, selectFrame)
					end
				end
				if finalLabel and firstLabel then
					updateCanvasSize(scrollFrame, finalLabel, firstLabel)
				end
			end
		end
		
		local function setupDefaultToggles(defaultToggles, scrollFrame, playerTextBox, organisedVariables, setupFunction, timeFrame, playerValue)
			local focused = false
			playerTextBox.Focused:Connect(function()
				focused = true
			end)
			playerTextBox.FocusLost:Connect(function()
				wait()
				focused = false
			end)
			for frameName, _ in pairs(defaultToggles) do
				local selectFrame = scrollFrame[frameName]
				for a,b in pairs(selectFrame:GetChildren()) do
					if b:IsA("TextButton") then
						b.MouseButton1Down:Connect(function()
							if not focused then
								selectToggle(selectFrame, b.Name, organisedVariables)
							end
						end)
					end
				end
				setupFunction(selectFrame)
			end
			if timeFrame then
				for a,b in pairs(timeFrame:GetChildren()) do
					local textBox = b:FindFirstChild("TextBox")
					if textBox then
						local originalNumber = textBox.Text
						textBox.Focused:Connect(function()
							focused = true
						end)
						textBox.FocusLost:connect(function(property)
							local newNumber = tonumber(textBox.Text)
							if newNumber then
								if newNumber < 0 then
									newNumber = 0
								elseif b.Name == "Minutes" and newNumber > 60 then
									newNumber = 60
								elseif b.Name == "Hours" and newNumber > 24 then
									newNumber = 24
								elseif b.Name == "Days" and newNumber > 100000 then
									newNumber = 100000
								end
								originalNumber = newNumber
							end
							textBox.Text = originalNumber
							wait()
							focused = false
						end)
					end
				end
			end
			if playerValue then
				playerValue = string.lower(playerValue)
				local newPlayerValue
				for i,v in pairs(main.qualifiers) do
					if v == playerValue then
						newPlayerValue = v
						break
					end
				end
				if not newPlayerValue then
					for i,plr in pairs(main.players:GetChildren()) do
						if string.sub(string.lower(plr.Name), 1, #playerValue) == playerValue then
							newPlayerValue = plr.Name
							break
						end
					end
				end
				playerTextBox.Text = newPlayerValue or ""
			end
		end
		
		local function setupFinalResult(frame, submitButton, loadingButton, serverInvocationFunction, retrievedDataFunction, broadcastFunction)
			local fr = frame.FinalResult
			local frFrame = fr.Frame
			local example = frFrame.Example
			local frLoading = frFrame.Loading
			local frBroadcast = frFrame.Broadcast
			fr.Visible = false
			frFrame.CloseX.MouseButton1Down:Connect(function()
				fr.Visible = false
			end)
			frBroadcast.MouseButton1Down:Connect(function()
				frLoading.Visible = true
				frBroadcast.Visible = false
				broadcastFunction()
				module:DestroyCommandMenuFrame(frame)
			end)
			submitButton.MouseButton1Down:Connect(function()
				loadingButton.Visible = true
				submitButton.Visible = false
				local data = serverInvocationFunction()
				if type(data) == "table" then
					retrievedDataFunction(data)
				else
					local errorMessage = tostring(data) or "Error"
					loadingButton.TextLabel.Text = errorMessage
					wait(1)
					loadingButton.TextLabel.Text = "Loading..."
				end
				loadingButton.Visible = false
				submitButton.Visible = true
			end)
		end
		
		local function setupPollResults(scrollFrame, data)
			local exampleAnswerTemplate = scrollFrame.AnswerTemplate
			exampleAnswerTemplate.Visible = false
			scrollFrame.Question.TextLabel.Text = data.Question
			for i,v in pairs(scrollFrame:GetChildren()) do
				if v:IsA("TextButton") and v ~= exampleAnswerTemplate then
					v:Destroy()
				end
			end
			for i,answer in pairs(data.Answers) do
				local answerButton = exampleAnswerTemplate:Clone()
				answerButton.Visible = true
				answerButton.Name = "Answer"..i
				answerButton.TextLabel.Text = i..". "..answer
				answerButton.BackgroundColor3 = module:GetLabelBackgroundColor(i)
				---------------
				local fade = answerButton.Fade
				local selectedAnswer = false
				if data.Remote then
					answerButton.MouseButton1Up:Connect(function()
						scrollFrame.Parent.Parent.Visible = false
						pcall(function() data.Remote:FireServer(i) end)
					end)
				end
				answerButton.InputBegan:Connect(function(input)
					main.tweenService:Create(fade, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
				end)
				answerButton.InputEnded:Connect(function(input)
					main.tweenService:Create(fade, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
				end)
				---------------
				answerButton.Parent = scrollFrame
			end
			spawn(function()
				wait(0.1)
				updateCanvasSize(scrollFrame, scrollFrame["Answer"..#data.Answers], scrollFrame.Question)
			end)
		end
		
		
		
		-------------- << MENU TYPE 1 >> --------------
		if menuType == 1 then
			if main.device ~= "Mobile" then
				frame.Position = UDim2.new(1, -255, 1, -155)
				frame.Size = UDim2.new(0, 250, 0, 150)
			end
			local infoFrame = mainFrame.InfoFrame
			local min
			infoFrame.Visible = false
			mainFrame.Desc.Visible = false
			mainFrame.InputFrame.Visible = false
			local menuType = menuDetails[1]
			if menuType == "Info" then
				mainFrame.Desc.Text = menuDetails[2]
				mainFrame.Desc.Visible = true
			elseif menuType == "Input" then
				local inputType = menuDetails[2]
				local textBox = mainFrame.InputFrame.Frame.TextBox
				local defaultValue = main.commandSpeeds[commandName]
				mainFrame.InputFrame.InputName.Text = inputType..":"
				textBox.Text = defaultValue
				--
				if main.infoFramesViewed[inputType] then
					main.infoFramesViewed[inputType] = nil
					if inputType == "Speed" then
						local infoLabels = {}
						if main.device == "Computer" then
							infoLabels = {
								{"Movement", "WASD"};
								{"Toggle flight", "E"};
								{"Up & Down", "R & F"};
								}
						else
							infoLabels = {
								{"Movement", "Thumbstick"};
								{"Toggle flight", "Double-jump"};
								}
						end
						for i = 1,3 do
							local label = infoFrame["Info"..i]
							local labelInfo = infoLabels[i]
							if labelInfo then
								label.Text = labelInfo[1]..":"
								label.TextLabel.Text = labelInfo[2]
								label.Visible = true
							else
								label.Visible = false
							end
						end
						infoFrame.Okay.MouseButton1Down:Connect(function()
							infoFrame.Visible = false
						end)
						infoFrame.Visible = true
					end
				end
				textBox.FocusLost:Connect(function()
					local newValue = tonumber(textBox.Text)
					if not newValue then
						newValue = defaultValue
					end
					textBox.Text = newValue
					main.commandSpeeds[commandName] = newValue
				end)
				mainFrame.InputFrame.Visible = true
			end
			module:UpdateCommandMenu(commandName, frame)
			mainFrame.ChangeStatus.MouseButton1Down:Connect(function()
				mainFrame.Loading.Visible = true
				if main.commandsToDisableCompletely[commandName] then
					local commandNameToSend
					if mainFrame.ChangeStatus.TextLabel.Text == "DISABLE" then
						commandNameToSend = "!Un"..commandName
					else
						commandNameToSend = "!"..commandName
					end
					main.signals.RequestCommand:InvokeServer(commandNameToSend)
					wait(1)
				elseif main.commandsActive[commandName] then
					main.commandsActive[commandName] = nil
				else
					modules.cf:ActivateClientCommand(commandName)
					wait(0.5)
				end
				module:UpdateCommandMenu(commandName, frame)
				mainFrame.Loading.Visible = false
			end)
		
		
		
		-------------- << MENU TYPE 2 >> --------------
		elseif menuType == 2 then
			if commandName == "cmdbar2" then
				dragBar.Title.Text = "CMDBAR2"
			end
			if main.device ~= "Mobile" then
				frame.Position = UDim2.new(0, 5, 1, -75)
				frame.Size = UDim2.new(0, 315, 0, 70)
			end
			local searchFrame = mainFrame.SearchFrame
			local textBox = searchFrame.TextBox
			local props = {
				maxSuggestions = 3;
				mainParent = mainFrame.Parent;
				textBox = textBox;
				rframe = searchFrame.ResultsFrame;
				suggestionPos = 1;
				suggestionDisplayed = 0;
				forceExecute = false;
				highlightColor = Color3.fromRGB(50,50,50);
				otherColor = Color3.fromRGB(80,80,80);
				suggestionLabels = {};
				currentBarCommand = nil;
				}
			modules.CmdBar:SetupTextbox(commandName, props)
			local loading = mainFrame.Loading
			mainFrame.Execute.MouseButton1Down:Connect(function()
				loading.Visible = true
				if #textBox.Text > 1 then
					local commandToRequest = textBox.Text
					local firstChar = string.sub(commandToRequest,1,1)
					if firstChar ~= main.settings.UniversalPrefix and firstChar ~= main.pdata.Prefix then
						commandToRequest = main.pdata.Prefix..commandToRequest
					end
					local endChar = string.sub(commandToRequest,-1)
					if endChar == " " then
						commandToRequest = string.sub(commandToRequest,1,-1)
					end
					main.signals.RequestCommand:InvokeServer(commandToRequest)
				end
				loading.Visible = false
			end)
		
		
		
		-------------- << MENU TYPE 3 >> --------------
		elseif menuType == 3 then
			if commandName == "cmdbar2" then
				dragBar.Title.Text = "CMDBAR2"
			end
			if main.device ~= "Mobile" then
				frame.Position = UDim2.new(0, 5, 1, -110)
				frame.Size = UDim2.new(0, 315, 0, 105)
			end
			
			local playerSearchFrame = mainFrame.PlayerFrame.SearchFrame
			local playerTextBox = playerSearchFrame.TextBox
			playerTextBox.Text = main.player.Name
			--
			local props = {
				maxSuggestions = 3;
				mainParent = mainFrame.Parent;
				textBox = playerTextBox;
				rframe = playerSearchFrame.ResultsFrame;
				suggestionPos = 1;
				suggestionDisplayed = 0;
				forceExecute = false;
				highlightColor = Color3.fromRGB(50,50,50);
				otherColor = Color3.fromRGB(80,80,80);
				suggestionLabels = {};
				currentBarCommand = nil;
				specificArg = "player";
				}
			modules.CmdBar:SetupTextbox(commandName, props)
			--
			
			local messageSearchFrame = mainFrame.MessageFrame.SearchFrame
			local messageTextBox = messageSearchFrame.TextBox
			messageTextBox.FocusLost:connect(function(enter)
				if enter then
					local targetPlayerText = playerTextBox.Text
					local endChar = string.sub(targetPlayerText,-1)
					if endChar == " " then
						targetPlayerText = string.sub(targetPlayerText,1,-1)
					end
					local commandToRequest = main.pdata.Prefix.."talk"..main.pdata.SplitKey..targetPlayerText..main.pdata.SplitKey..messageTextBox.Text
					messageTextBox.Text = ""
					main.signals.RequestCommand:InvokeServer(commandToRequest)
				end
			end)
		
		
		
		-------------- << MENU TYPE 4 (messages) >> --------------
		elseif menuType == 4 then
			local speaker = menuDetails[1]
			local message = menuDetails[2]
			local textBox = mainFrame.ReplyFrame.TextBox
			local send = mainFrame.Send
			dragBar.Title.Text = "Message from "..speaker.Name
			mainFrame.MessageFrame.Message.Text = message
			textBox.Changed:connect(function(property)
				if property == "Text" then
					if #textBox.Text > 0 then
						send.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
						send.AutoButtonColor = true
					else
						send.TextLabel.TextColor3 = Color3.fromRGB(125, 125, 125)
						send.AutoButtonColor = false
					end
				end
			end)
			send.MouseButton1Down:Connect(function()
				if send.AutoButtonColor then
					module:DestroyCommandMenuFrame(frame)
					main.signals.ReplyToPrivateMessage:InvokeServer{speaker, textBox.Text}
				end
			end)
		
		
		
		-------------- << MENU TYPE 5 (logs) >> --------------
		elseif menuType == 5 then
			local log = menuDetails
			local labelY = math.ceil(mainFrameTemplate.ScrollFrame.AbsoluteSize.Y/14)
			local template = mainFrameTemplate.ScrollFrame.Template
			local marginX = labelY/3
			local scrollFrame = mainFrame.ScrollFrame
			scrollFrame.Template:Destroy()
			frame.Parent = main.gui
			----
			local function getLabelText(record)
				local message = record.message
				local timeAdded = record.timeAdded-- -(record.timeAdded-os.time())
				local localTimeData = os.date("*t", timeAdded)
				local speakerName = record.speakerName
				local hour = localTimeData.hour
				local minute = localTimeData.min
				if hour < 10 then
					hour = "0"..hour
				end
				if minute < 10 then
					minute = "0"..minute
				end
				return("["..hour..":"..minute.."] "..speakerName..": "..message)
			end
			local function updateLog(newLog)
				local maxX = 0
				for i,v in pairs(scrollFrame:GetChildren()) do
					if v.Name ~= "UIListLayout" then
						v:Destroy()
					end
				end
				for i,record in pairs(newLog) do
					local label = template:Clone()
					local textLabel = label.TextLabel
					local labelText = getLabelText(record)
					local labelTextSize = main.textService:GetTextSize(labelText, tonumber(textLabel.TextSize), textLabel.Font, Vector2.new(math.huge, labelY))
					--print(labelText, tonumber(textLabel.TextSize), tostring(textLabel.Font), tostring(Vector2.new(labelY, math.huge)).." = ".. tostring(labelTextSize))
					local labelX = labelTextSize.X
					if labelX > maxX then
						maxX = labelX
					end
					textLabel.Text = labelText
					label.BackgroundColor3 = module:GetLabelBackgroundColor(i)
					label.Visible = true
					label.Name = "Record"..i
					label.Size = UDim2.new(1,0,0,labelY)
					textLabel.Position = UDim2.new(0, marginX, 0.15, 0)
					textLabel.Size = UDim2.new(1,-marginX*2,0.7,0)
					label.Parent = scrollFrame
				end
				scrollFrame.CanvasSize = UDim2.new(0, maxX, 0, #newLog*labelY)
			end
			updateLog(log)
			----
			local searchDe = true
			local textBox = mainFrame.SearchBar.Frame.TextBox
			local specialChars = {}
			textBox.FocusLost:connect(function(property)
				if searchDe then
					searchDe = false
					local searchText = string.lower(textBox.Text)
					local newLog = {}
					for i,record in pairs(log) do
						local labelText = string.lower(getLabelText(record))
						if string.find(labelText, searchText, 1, true) then
							table.insert(newLog, record)
						end
					end
					updateLog(newLog)
					setupOriginalZIndex(scrollFrame)
					updateZIndex(main.commandMenus, scrollFrame)
					wait(0.5)
					searchDe = true
				end
			end)
			----
		
		
		
		-------------- << MENU TYPE 6 (banMenu) >> --------------
		elseif menuType == 6 then
			local scrollFrame = mainFrame.ScrollFrame
			local defaultToggles = {["AG Server"] = "Current", ["AJ Length"] = "Infinite"}
			local selectedToggles = {}
			local playerSearchFrame = scrollFrame["AC Target Player"].SearchFrame
			local playerTextBox = playerSearchFrame.TextBox
			local playerValue = menuDetails.targetPlayer
			local timeFrame = scrollFrame["AJA Time"]
			local firstLabel = scrollFrame["AA Space"]
			local finalLabel = scrollFrame["AZ Space"]
			local banButton = scrollFrame["AX Ban"]
			local reasonTextBox = scrollFrame["AM Reason"].SearchFrame.TextBox
			local finalFunction = function(b, toggleName, selectFrame)
				if b.Name == toggleName then
					b.BackgroundTransparency = 0.1
					b.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					selectedToggles[selectFrame.Name] = toggleName
					if selectFrame.Name == "AJ Length" then
						if b.Name == "Time" then
							timeFrame.Visible = true
						else
							timeFrame.Visible = false
						end
					end
				else
					b.BackgroundTransparency = 0.8
					b.TextLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
				end
			end
			local organisedVariables = {defaultToggles, finalFunction, scrollFrame, finalLabel, firstLabel}
			local setupFunction = function(selectFrame)
				if selectFrame.Name == "AG Server" then
					selectToggle(selectFrame, menuDetails.server, organisedVariables)
				elseif selectFrame.Name == "AJ Length" then
					selectToggle(selectFrame, menuDetails.length, organisedVariables)
				end
			end
			setupDefaultToggles(defaultToggles, scrollFrame, playerTextBox, organisedVariables, setupFunction, timeFrame, playerValue)
			local props = {
				maxSuggestions = 3;
				mainParent = mainFrame.Parent;
				textBox = playerTextBox;
				rframe = playerSearchFrame.ResultsFrame;
				suggestionPos = 1;
				suggestionDisplayed = 0;
				forceExecute = false;
				highlightColor = Color3.fromRGB(50,50,50);
				otherColor = Color3.fromRGB(80,80,80);
				suggestionLabels = {};
				currentBarCommand = nil;
				specificArg = "player";
				}
			modules.CmdBar:SetupTextbox(commandName, props)
			--Time
			local timeDetails = menuDetails.timeDetails
			if timeDetails then
				timeDetails:gsub("%d+%a", function(c)
					local d = tonumber(c:match("%d+"))
					if d then
						local timeType = c:match("%a")
						local amount, frameName, newD = modules.cf:GetTimeAmount(timeType, d)
						timeFrame[frameName].TextBox.Text = newD
					end
					return
				end)
			end
			--
			local defaultReason = menuDetails.reason
			if defaultReason and defaultReason ~= "" and defaultReason ~= " " then
				reasonTextBox.Text = defaultReason
			end
			banButton.MouseButton1Down:Connect(function()
				local banReason = reasonTextBox.Text
				local playerName = playerTextBox.Text
				local minutes, hours, days = timeFrame.Minutes.TextBox.Text, timeFrame.Hours.TextBox.Text, timeFrame.Days.TextBox.Text
				local details = {server=selectedToggles["AG Server"], length=selectedToggles["AJ Length"], lengthTime=minutes.."m"..hours.."h"..days.."d"}
				module:DestroyCommandMenuFrame(frame)
				main.signals.RequestCommand:InvokeServer(main.pdata.Prefix.."directBan"..main.pdata.SplitKey..playerName..main.pdata.SplitKey..banReason, details)
			end)
			spawn(function()
				wait(0.1)
				updateCanvasSize(scrollFrame, finalLabel, firstLabel)
			end)
			
		
		-------------- << MENU TYPE 7 (global announcement) >> --------------
		elseif menuType == 7 then
			local scrollFrame = mainFrame.ScrollFrame
			local defaultToggles = {["AG DisplayFrom"] = "Enabled"}
			local selectedToggles = {}
			local colorSearchFrame = scrollFrame["AJ MessageColor"].SearchFrame
			local colorTextBox = colorSearchFrame.TextBox
			local submitButton = scrollFrame["AX Submit"]
			local loadingButton = scrollFrame["AZ Loading"]
			local displayFromTitle = scrollFrame["AF Title"]
			local titleTextBox = scrollFrame["AC MessageTitle"].SearchFrame.TextBox
			local messageTextBox = scrollFrame["AM Message"].SearchFrame.TextBox
			local finalFunction = function(b, toggleName, selectFrame)
				if b.Name == toggleName then
					b.BackgroundTransparency = 0.1
					b.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					selectedToggles[selectFrame.Name] = toggleName
				else
					b.BackgroundTransparency = 0.8
					b.TextLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
				end
			end
			local organisedVariables = {defaultToggles, finalFunction, scrollFrame, --[[finalLabel, firstLabel--]]}
			displayFromTitle.TextLabel.Text = "Display 'From ".. main.player.Name.."'"
			local setupFunction = function(selectFrame)
				if selectFrame.Name == "AG DisplayFrom" then
					selectToggle(selectFrame, "Enabled", organisedVariables)
				end
			end
			setupDefaultToggles(defaultToggles, scrollFrame, colorTextBox, organisedVariables, setupFunction)
			local props = {
				maxSuggestions = 3;
				mainParent = mainFrame.Parent;
				textBox = colorTextBox;
				rframe = colorSearchFrame.ResultsFrame;
				suggestionPos = 1;
				suggestionDisplayed = 0;
				forceExecute = false;
				highlightColor = Color3.fromRGB(50,50,50);
				otherColor = Color3.fromRGB(80,80,80);
				suggestionLabels = {};
				currentBarCommand = nil;
				specificArg = "color";
				}
			modules.CmdBar:SetupTextbox(commandName, props)
			
			--Final result
			local fr = frame.FinalResult
			local frFrame = fr.Frame
			local example = frFrame.Example
			local serverInvocationFunction = function()
				local displayFrom = false
				if selectedToggles["AG DisplayFrom"] == "Enabled" then
					displayFrom = true
				end
				local data = main.signals.RetrieveBroadcastData:InvokeServer{["Title"] = titleTextBox.Text, ["DisplayFrom"] = displayFrom, ["Color"] = colorTextBox.Text, ["Message"] = messageTextBox.Text}
				return data
			end
			local retrievedDataFunction = function(data)
				example.Title.Text = data.Title
				local displayFrom = data.DisplayFrom
				example.Pic.Visible = displayFrom
				example.SubTitle.Visible = displayFrom
				if displayFrom then
					example.Pic.Image = module:GetUserImage(data.SenderId)
					example.SubTitle.Text = "From ".. data.SenderName
				end
				example.Desc.TextColor3 = Color3.new(data.Color[1], data.Color[2], data.Color[3])
				example.Desc.Text = data.Message
				fr.Visible = true
			end
			local broadcastFunction = function()
				main.signals.ExecuteBroadcast:InvokeServer()
			end
			setupFinalResult(frame, submitButton, loadingButton, serverInvocationFunction, retrievedDataFunction, broadcastFunction)
			
		
		
		
		-------------- << MENU TYPE 8 (alert) >> --------------
		elseif menuType == 8 then
			local title = menuDetails[1]
			local message = menuDetails[2]
			local mute = dragBar.Mute
			local muteLabel = mute.TextLabel
			local soundPlayingIcon = "🔊"
			local soundMutedIcon = "🔇"
			local sound = Instance.new("Sound")
			sound.SoundId = "rbxassetid://"..main.pdata.AlertSoundId
			sound.Volume = main.pdata.AlertVolume
			sound.Pitch = main.pdata.AlertPitch
			sound.Looped = true
			sound.Parent = frame
			sound:Play()
			dragBar.Title.Text = title
			mainFrame.MessageFrame.Message.Text = message
			mute.MouseButton1Down:Connect(function()
				if muteLabel.Text == soundPlayingIcon then
					muteLabel.Text = soundMutedIcon
					sound:Pause()
				else
					muteLabel.Text = soundPlayingIcon
					sound:Play()
				end
			end)	
		
		
		
		-------------- << MENU TYPE 9 (pollMenu) >> --------------
		elseif menuType == 9 then
			local scrollFrame = mainFrame.ScrollFrame
			local defaultToggles = {["AC Server"] = "Current", ["AG ShowResultsTo"] = "You"}
			local selectedToggles = {}
			local targetPlayerLabel = scrollFrame["AD Target Player"]
			local playerSearchFrame = targetPlayerLabel.SearchFrame
			local playerTextBox = playerSearchFrame.TextBox
			local playerValue = menuDetails.targetPlayer
			local firstLabel = scrollFrame["AA Space"]
			local finalLabel = scrollFrame["AZ Space"]
			local loadingButton = scrollFrame["AZ Loading"]
			local submitButton = scrollFrame["AX Submit"]
			local questionTextBox = scrollFrame["AP Question"].SearchFrame.TextBox
			local finalFunction = function(b, toggleName, selectFrame)
				local selectFrameName = selectFrame.Name
				if b.Name == toggleName then
					b.BackgroundTransparency = 0.1
					b.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					selectedToggles[selectFrame.Name] = toggleName
					if selectFrameName == "AC Server" then
						if b.Name == "Current" then
							targetPlayerLabel.Visible = true
						else
							targetPlayerLabel.Visible = false
						end
					end
				else
					b.BackgroundTransparency = 0.8
					b.TextLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
				end
			end
			local organisedVariables = {defaultToggles, finalFunction, scrollFrame, finalLabel, firstLabel}
			local setupFunction = function(selectFrame)
				if selectFrame.Name == "AC Server" then
					selectToggle(selectFrame, menuDetails.server, organisedVariables)
				elseif defaultToggles[selectFrame.Name] then
					selectToggle(selectFrame, defaultToggles[selectFrame.Name], organisedVariables)
				end
			end
			setupDefaultToggles(defaultToggles, scrollFrame, playerTextBox, organisedVariables, setupFunction, nil, playerValue)
			local props = {
				maxSuggestions = 3;
				mainParent = mainFrame.Parent;
				textBox = playerTextBox;
				rframe = playerSearchFrame.ResultsFrame;
				suggestionPos = 1;
				suggestionDisplayed = 0;
				forceExecute = false;
				highlightColor = Color3.fromRGB(50,50,50);
				otherColor = Color3.fromRGB(80,80,80);
				suggestionLabels = {};
				currentBarCommand = nil;
				specificArg = "player";
				}
			modules.CmdBar:SetupTextbox(commandName, props)
			local defaultQuestion = menuDetails.question
			if defaultQuestion and defaultQuestion ~= "" and defaultQuestion ~= " " then
				questionTextBox.Text = defaultQuestion
			end
			--Answers
			local answersLimit = 10
			local answerTemplate = scrollFrame["AS Answer"]
			local addAnswer = scrollFrame["AT AddAnswer"]
			local answerBoxes = {}
			answerTemplate.Visible = false
			local function removeAnswerBox(box)
				for i,v in pairs(answerBoxes) do
					if v == box then
						table.remove(answerBoxes, i)
						break
					end
				end
				box:Destroy()
				updateCanvasSize(scrollFrame, finalLabel, firstLabel)
			end
			local function createAnswerBox()
				local newBox = answerTemplate:Clone()
				newBox.Visible = true
				newBox.Parent = scrollFrame
				newBox.RemoveBox.MouseButton1Down:Connect(function()
					removeAnswerBox(newBox)
				end)
				table.insert(answerBoxes, newBox)
				updateCanvasSize(scrollFrame, finalLabel, firstLabel)
				return newBox
			end
			local defaultAnswers = menuDetails.answers
			if type(defaultAnswers) == "table" then
				for i, answer in pairs(defaultAnswers) do
					if answer and answer ~= "" and answer ~= " " then
						local box = createAnswerBox()
						box.SearchFrame.TextBox.Text = answer
						if #answerBoxes >= answersLimit then
							break
						end
					end
				end
			end
			addAnswer.Add.MouseButton1Down:Connect(function()
				if #answerBoxes >= answersLimit then
					modules.Notices:Notice("Error", "HD Admin", "Cannot exceed "..answersLimit.." answers!")
				else
					local box = createAnswerBox()
					scrollFrame.CanvasPosition = Vector2.new(0, scrollFrame.CanvasPosition.Y + box.AbsoluteSize.Y)
				end
			end)
			--VoteTime
			local voteTimeLabel = scrollFrame["AC VoteTime"]
			local voteTimeTextBox = voteTimeLabel.SearchFrame.TextBox
			local originalVoteTime = voteTimeTextBox.Text
			voteTimeTextBox.FocusLost:connect(function(property)
				local newNumber = tonumber(voteTimeTextBox.Text)
				if newNumber then
					if newNumber < 1 then
						newNumber = 1
					elseif newNumber > 60 then
						newNumber = 60
					end
				else
					newNumber = originalVoteTime
				end
				voteTimeTextBox.Text = newNumber
				originalVoteTime = newNumber
			end)
			--
			spawn(function()
				wait(0.1)
				updateCanvasSize(scrollFrame, finalLabel, firstLabel)
			end)
			
			--Final result
			local fr = frame.FinalResult
			local frFrame = fr.Frame
			local example = frFrame.Example
			local serverInvocationFunction = function()
				local voteTime = voteTimeTextBox.Text
				local question = questionTextBox.Text
				local server = selectedToggles["AC Server"]
				local showResultsTo = selectedToggles["AG ShowResultsTo"]
				local playerArg = playerTextBox.Text:gsub(" ", function(c) return "" end)
				local answers = {}
				for i,v in pairs(answerBoxes) do
					table.insert(answers, v.SearchFrame.TextBox.Text)
				end
				--
				local data = main.signals.RetrievePollData:InvokeServer{["VoteTime"] = voteTime, ["Question"] = question, ["Answers"] = answers, ["Server"] = server, ["ShowResultsTo"] = showResultsTo, ["PlayerArg"] = playerArg}
				--
				return data
			end
			local retrievedDataFunction = function(data)
				setupPollResults(example, data)
				fr.Visible = true--]]
			end
			local broadcastFunction = function()
				main.signals.ExecutePoll:InvokeServer()
			end
			setupFinalResult(frame, submitButton, loadingButton, serverInvocationFunction, retrievedDataFunction, broadcastFunction)
			
		
		
		
		-------------- << MENU TYPE 10 (pollSelection) >> --------------
		elseif menuType == 10 then
			main.audio.Notice:Play()
			local scrollFrame = mainFrame.ScrollFrame
			local questionLabel = scrollFrame.Question.TextLabel
			local titleLabel = dragBar.Title
			local data = menuDetails
			local voteTime = data.VoteTime
			local voteTimePlusOne = voteTime+1
			setupPollResults(scrollFrame, data)
			questionLabel.Text = data.Question
			coroutine.wrap(function()
				for i = 1, voteTime do
					titleLabel.Text = string.upper(data.SenderName).."'S POLL (".. voteTimePlusOne-i..")"
					wait(1)
				end
				module:DestroyCommandMenuFrame(frame)
			end)()
			
			
		
		-------------- << MENU TYPE 10 (pollSelection) >> --------------
		elseif menuType == 11 then
			main.audio.Notice:Play()
			local barColors = modules.cf:RandomiseTable{
				Color3.fromRGB(220, 30, 30);
				Color3.fromRGB(220, 93, 29);
				Color3.fromRGB(188, 161, 23);
				Color3.fromRGB(107, 186, 22);
				Color3.fromRGB(19, 179, 46);
				Color3.fromRGB(20, 197, 197);
				Color3.fromRGB(24, 120, 255);
				Color3.fromRGB(101, 24, 255);
				Color3.fromRGB(217, 24, 255);
				Color3.fromRGB(255, 24, 128);
			}
			local scrollFrame = mainFrame.ScrollFrame
			local questionLabel = scrollFrame.Question.TextLabel
			local titleLabel = dragBar.Title
			local data = menuDetails
			questionLabel.Text = data.Question
			local resultTemplate = scrollFrame.ResultTemplate
			resultTemplate.Visible = false
			local totalResults = #data.Results
			for i,result in pairs(data.Results) do
				local answerButton = resultTemplate:Clone()
				answerButton.Visible = true
				answerButton.Name = "Answer"..i
				answerButton.Bar.BackgroundColor3 = barColors[i] --Color3.fromHSV(i/10, 1, 1)
				local resultTextStart = i..". "..result.Answer.." ("
				if i == totalResults then
					resultTextStart = result.Answer.." ("
					answerButton.Bar.BackgroundColor3 = Color3.fromRGB(175, 175, 175)
				end
				answerButton.TextLabel.Text = resultTextStart.."0)"
				answerButton.BackgroundColor3 = module:GetLabelBackgroundColor(i)
				answerButton.Bar.Size = UDim2.new(0, 0, 1, 0)
				delay((i-1)/10, function()
					local tweenTime = 2
					local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quart)
					local intValue = Instance.new("IntValue")
					intValue.Value = 0
					main.tweenService:Create(answerButton.Bar, tweenInfo, {Size = UDim2.new(result.Percentage, 0, 1, 0)}):Play()
					main.tweenService:Create(intValue, tweenInfo, {Value = result.Votes}):Play()
					intValue.Changed:Connect(function(newVal)
						answerButton.TextLabel.Text = resultTextStart..newVal..")"
					end)
					wait(tweenTime)
					intValue:Destroy()
				end)
				answerButton.Parent = scrollFrame
			end
			spawn(function()
				wait(0.1)
				updateCanvasSize(scrollFrame, scrollFrame["Answer"..#data.Answers], scrollFrame.Question)
			end)
			
			
			
		
		-------------- << MENU TYPE 12 (globalAlert) >> --------------
		elseif menuType == 12 then
			local scrollFrame = mainFrame.ScrollFrame
			local defaultToggles = {["AC Server"] = "Current"}
			local selectedToggles = {}
			local targetPlayerLabel = scrollFrame["AD Target Player"]
			local playerSearchFrame = targetPlayerLabel.SearchFrame
			local playerTextBox = playerSearchFrame.TextBox
			local playerValue = menuDetails.targetPlayer
			local firstLabel = scrollFrame["AA Space"]
			local finalLabel = scrollFrame["AZ Space"]
			local spaceX = scrollFrame["AX Space"]
			local loadingButton = scrollFrame["AZ Loading"]
			local submitButton = scrollFrame["AX Submit"]
			local titleTextBox = scrollFrame["AG MessageTitle"].SearchFrame.TextBox
			local messageTextBox = scrollFrame["AM Message"].SearchFrame.TextBox
			local finalFunction = function(b, toggleName, selectFrame)
				local selectFrameName = selectFrame.Name
				if b.Name == toggleName then
					b.BackgroundTransparency = 0.1
					b.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					selectedToggles[selectFrame.Name] = toggleName
					if selectFrameName == "AC Server" then
						if b.Name == "Current" then
							targetPlayerLabel.Visible = true
							spaceX.Visible = false
						else
							targetPlayerLabel.Visible = false
							spaceX.Visible = true
						end
					end
				else
					b.BackgroundTransparency = 0.8
					b.TextLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
				end
			end
			local organisedVariables = {defaultToggles, finalFunction, scrollFrame, finalLabel, firstLabel}
			local setupFunction = function(selectFrame)
				if selectFrame.Name == "AC Server" then
					selectToggle(selectFrame, menuDetails.server, organisedVariables)
				elseif defaultToggles[selectFrame.Name] then
					selectToggle(selectFrame, defaultToggles[selectFrame.Name], organisedVariables)
				end
			end
			setupDefaultToggles(defaultToggles, scrollFrame, playerTextBox, organisedVariables, setupFunction, nil, playerValue)
			local props = {
				maxSuggestions = 3;
				mainParent = mainFrame.Parent;
				textBox = playerTextBox;
				rframe = playerSearchFrame.ResultsFrame;
				suggestionPos = 1;
				suggestionDisplayed = 0;
				forceExecute = false;
				highlightColor = Color3.fromRGB(50,50,50);
				otherColor = Color3.fromRGB(80,80,80);
				suggestionLabels = {};
				currentBarCommand = nil;
				specificArg = "player";
				}
			modules.CmdBar:SetupTextbox(commandName, props)
			local defaultMessage = menuDetails.message
			if defaultMessage and defaultMessage ~= "" and defaultMessage ~= " " then
				messageTextBox.Text = defaultMessage
			end
			titleTextBox.Text = "Alert from ".. main.player.Name
			
			--Final result
			local fr = frame.FinalResult
			local frFrame = fr.Frame
			local example = frFrame.Example
			local serverInvocationFunction = function()
				local title = titleTextBox.Text
				local message = messageTextBox.Text
				local server = selectedToggles["AC Server"]
				local playerArg = playerTextBox.Text:gsub(" ", function(c) return "" end)
				--
				local data = main.signals.RetrieveAlertData:InvokeServer{
					["Title"] = title,
					["Message"] = message,
					["Server"] = server,
					["PlayerArg"] = playerArg
					}
				--
				return data
			end
			local retrievedDataFunction = function(data)
				example.Title.Text = data.Title
				example.Message.Text = data.Message
				fr.Visible = true
			end
			local broadcastFunction = function()
				main.signals.ExecuteAlert:InvokeServer()
			end
			setupFinalResult(frame, submitButton, loadingButton, serverInvocationFunction, retrievedDataFunction, broadcastFunction)
			
		
		
		
			
		end
		--
		setupOriginalZIndex(frame, forceOnTop)
		table.insert(main.commandMenus, frame)
		updateZIndex(main.commandMenus)
		--
	end
	frame.Parent = main.gui
	frame.Visible = true
end

function module:GetMousePoint(hitPosition)
	local rayMag1 = main.camera:ScreenPointToRay(main.lastHitPosition.X, main.lastHitPosition.Y)
	local newRay = Ray.new(rayMag1.Origin, rayMag1.Direction * 100)
	local hit, position = workspace:FindPartOnRay(newRay, main.player.Character)
	return hit, position
end

function module:GetLabelBackgroundColor(i)
	if i%2 == 0 then
		return(Color3.fromRGB(50, 50, 50))
	else
		return(Color3.fromRGB(40, 40, 40))
	end
end

function module:GenerateTagFromId(ID)
	local values = main.alphabet
	local totalValues = #values
	local loops2 = math.ceil(ID/#values)
	local loops3 = math.ceil(ID/(#values)^2)
	local v1 = values[ID%totalValues] or values[totalValues]
	local v2 = values[loops2%totalValues] or values[totalValues]
	local v3 = values[loops3%totalValues] or values[totalValues]
	return v3..v2..v1
end

function module:ClearPage(page)
	for _,label in pairs(page:GetChildren()) do
		if label.Name ~= "UIListLayout" and string.sub(label.Name,1,8) ~= "Template" then
			label:Destroy()
		elseif label:IsA("Frame") then
			label.Visible = false
		end
	end
end

function module:UpdateClientData()
	main.pdata = main.rfunction:InvokeServer("RetrievePlayerData")
end




--[[
local frame = game.StarterGui.HDAdminGUIs.MainFrame
for a,b in pairs(frame:GetDescendants()) do
	if b:IsA("GuiObject") then
		b.ZIndex = b.ZIndex + 10
	end
end

game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)	
game:GetService("StarterGui"):SetCore("TopbarEnabled", false)

--]]



return module
