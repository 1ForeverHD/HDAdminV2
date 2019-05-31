local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules



-- << VARIABLES >>
local dragInput = Enum.UserInputType.MouseMovement
local clickInput = Enum.UserInputType.MouseButton1
local touchInput = Enum.UserInputType.Touch



-- << CHATTING >>
main.chatting = false
main.userInputService.TextBoxFocused:connect(function()
	main.chatting = true
end)
main.userInputService.TextBoxFocusReleased:connect(function()
	main.chatting = false
end)



-- << DRAG BARS >>
local dragFrames = {main.gui.MainFrame}
local frameDragging
local dragStart
local startPos
local function dragFrame(input, frame)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	if frame.AbsolutePosition.Y < 0 then
		frame.Position = frame.Position + UDim2.new(0,0,0,-frame.AbsolutePosition.Y)
	end
end
function module:MakeFrameDraggable(frame)
	local dragFrame = frame.DragBar.Drag
	dragFrame.InputBegan:Connect(function(input)
		if input.UserInputType == clickInput or input.UserInputType == touchInput then
			frameDragging = frame
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					frameDragging = nil
				end
			end)
		end
	end)
end
for _,frame in pairs(dragFrames) do
	module:MakeFrameDraggable(frame)
end



-- << SCREEN CLICKED/DRAGGED/TOUCHED >>
--Check to activate any Client Commands
local functionsToCheck = {"laserEyes"}
local function checkPressFunctions(hitPosition)
	main.lastHitPosition = hitPosition
	for _,commandName in pairs(functionsToCheck) do
		modules.cf:ActivateClientCommand(commandName)
	end
end

--Drag
main.userInputService.InputChanged:Connect(function(input, pressedUI)
	if (input.UserInputType == dragInput or input.UserInputType == touchInput) and (not pressedUI or frameDragging) then
		if main.mouseDown then
			local distanceBetweenLastPos = (main.lastHitPosition - input.Position).magnitude
			if distanceBetweenLastPos < 150 or main.device ~= "Mobile" then --Prevent weird behavior with multiple touch inputs
				if frameDragging then
					dragFrame(input, frameDragging)
				end
				checkPressFunctions(input.Position)
			end
		end
	end
end)

--Click/Touch
local cmdBar = main.gui.CmdBar
local textBox = cmdBar.SearchFrame.TextBox
local arrowKeys = {[Enum.KeyCode.Left] = true, [Enum.KeyCode.Right] = true, [Enum.KeyCode.Up] = true, [Enum.KeyCode.Down] = true}
local movementKeys = {[Enum.KeyCode.Left]="Left",[Enum.KeyCode.Right]="Right",[Enum.KeyCode.Up]="Forwards",[Enum.KeyCode.Down]="Backwards",[Enum.KeyCode.A]="Left",[Enum.KeyCode.D]="Right",[Enum.KeyCode.W]="Forwards",[Enum.KeyCode.S]="Backwards", [Enum.KeyCode.Space]="Up", [Enum.KeyCode.R]="Up", [Enum.KeyCode.Q]="Down", [Enum.KeyCode.LeftControl]="Down", [Enum.KeyCode.F]="Down"}
main.movementKeysPressed = {}
main.userInputService.InputBegan:Connect(function(input, pressedUI)
	if (input.UserInputType == clickInput or input.UserInputType == touchInput) and (not pressedUI or frameDragging) and not main.mouseDown then
		main.mouseDown = true
		checkPressFunctions(input.Position)
	elseif not main.chatting or (cmdBar.Visible and #textBox.Text < 2) then
		local direction = movementKeys[input.KeyCode]
		if direction then
			table.insert(main.movementKeysPressed, direction)
		elseif input.KeyCode == Enum.KeyCode.E then
			for speedCommandName, _ in pairs(main.commandSpeeds) do
				if main.commandsActive[speedCommandName] then
					modules.cf:EndCommand(speedCommandName)
				else
					modules.cf:ActivateClientCommand(speedCommandName)
				end
			end
			
		elseif input.KeyCode == Enum.KeyCode.Quote or input.KeyCode == Enum.KeyCode.Semicolon then
			modules.CmdBar:ToggleBar(input.KeyCode)
		end
	end
	if arrowKeys[input.KeyCode] then
		modules.CmdBar:PressedArrowKey(input.KeyCode)
	end
end)
main.userInputService.InputEnded:Connect(function(input, pressedUI)
	local direction = movementKeys[input.KeyCode] 
	if input.UserInputType == clickInput or input.UserInputType == touchInput then
		main.mouseDown = false
	elseif direction then
		for i,v in pairs(main.movementKeysPressed) do
			if v == direction then
				table.remove(main.movementKeysPressed,i)
			end
		end
	end
end)





return module
