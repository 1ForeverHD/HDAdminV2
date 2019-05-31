local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules



-- << VARIABLES >>
local topBar = main.gui.CustomTopBar
local coreToHide = {"Chat", "PlayerList"}
local originalCoreStates = {};
local cmdBar = main.gui.CmdBar
local currentProps = {}
local originalTopBarTransparency = 0.5
local originalTopBarVisibility = true
local mainProps
mainProps = {
	maxSuggestions = 5;
	mainParent = cmdBar;
	textBox = cmdBar.SearchFrame.TextBox;
	rframe = cmdBar.ResultsFrame;
	suggestionPos = 1;
	suggestionDisplayed = 0;
	forceExecute = false;
	highlightColor = Color3.fromRGB(50,50,50);
	otherColor = Color3.fromRGB(80,80,80);
	suggestionLabels = {};
	currentBarCommand = nil;
}



-- << LOCAL FUNCTION >>
local function selectSuggestion(props)
	local newInput = ""
	local suggestion = props.suggestionLabels["Label"..props.suggestionPos]
	if props.specificArg then
		newInput = suggestion.Name.." "
		--
		props.textBox.Text = newInput
		coroutine.wrap(function()
			for i = 1,10 do
				props.textBox:ReleaseFocus()
				wait()
			end
		end)()
		wait()
		props.textBox.Text = newInput
	else
		local newInputTable = {}
		local argPosCount = -1
		local firstChar = string.sub(props.textBox.Text,1,1)
		props.textBox.Text:gsub('([^'..main.pdata.SplitKey..']+)',function(c) argPosCount = argPosCount + 1 if argPosCount > suggestion.ArgPos-1 then return end table.insert(newInputTable, c.." ") end);
		if argPosCount == 0 and (firstChar == main.settings.UniversalPrefix or firstChar == main.pdata.Prefix) then
			newInput = firstChar
		end
		newInput = newInput..table.concat(newInputTable, "")
		newInput = newInput..suggestion.Name
		newInput = newInput..main.pdata.SplitKey
		--
		props.textBox.Text = newInput
		wait()
		props.textBox.Text = newInput
		props.textBox:CaptureFocus()
		props.textBox.CursorPosition = #newInput+1
	end
end



-- << SETUP >>
--Hide
cmdBar.Visible = false

--Create suggestion labels
local function createSuggestionLabels(props)
	for i = 1,props.maxSuggestions do
		local label = props.rframe.LabelTemplate:Clone()
		label.Name = "Label"..i
		label.Visible = false
		label.Parent = props.rframe
		label.MouseEnter:Connect(function()
			props.suggestionPos = i
		end)
		label.MouseButton1Up:Connect(function()
			props.suggestionPos = i
			selectSuggestion(props)
		end)
	end
end

--Hide cmdbar and request command when FocusLost
local function setupEnterPress(props)
	props.textBox.FocusLost:connect(function(enter)
		if props.mainParent.Name ~= "CmdBar" or props.specificArg then
			if props.suggestionDisplayed > 0 then
				selectSuggestion(props, props.specificArg)
			end
		else
			if props.suggestionDisplayed > 0 and not forceExecute and main.device ~= "Mobile" then
				selectSuggestion(props)
			elseif enter then
				if forceExecute then
					selectSuggestion(props)
					--wait()
				end
				module:CloseCmdBar()
				if #props.textBox.Text > 1 then
					local commandToRequest = props.textBox.Text
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
			end
		end
	end)
end

--Search Bar suggestions
function module:SetupTextbox(commandName, props)
	local function collectArguments(suggestions, currentBarArg, totalArgs, argName)
		if string.sub(string.lower(argName), 1, #currentBarArg) == currentBarArg then
			table.insert(suggestions, {Name = argName, ArgPos = totalArgs})
			if #suggestions == props.maxSuggestions then
				return true
			end
		end
	end
	local specificArg = props.specificArg
	currentProps[commandName] = props
	createSuggestionLabels(props)
	setupEnterPress(props)
	local originalPosition
	props.textBox.Changed:connect(function(property)
		if property == "Text" then
			local totalArgs = -1
			local barCommandName
			local args = {}
			if specificArg then
				totalArgs = 1
				table.insert(args, props.textBox.Text)
			else
				props.textBox.Text:gsub('([^'..main.pdata.SplitKey..']+)',function(c) totalArgs = totalArgs + 1 if totalArgs == 0 then barCommandName = c elseif totalArgs > 0 then table.insert(args, c) end end);
				if totalArgs > 0 and not props.currentBarCommand then
					local firstChar = string.sub(barCommandName,1,1)
					if firstChar == main.settings.UniversalPrefix or firstChar == main.pdata.Prefix then
						barCommandName = string.sub(barCommandName,2)
					end
					barCommandName = string.lower(barCommandName)
					--
					for _, command in pairs(main.commandInfo) do
						local cName = string.lower(command.Name)
						if cName == barCommandName then
							props.currentBarCommand = command
						elseif command.Aliases then
							for i,v in pairs(command.Aliases) do
								if string.lower(v) == barCommandName then
									props.currentBarCommand = command
								end
							end
						end
					end
					--
				elseif totalArgs <= 0 then
					props.currentBarCommand = nil
				end
			end
			local suggestions = {}
			props.suggestionPos = 1
			if #props.textBox.Text > 1 or (specificArg and #props.textBox.Text > 0) then
				if totalArgs == 0 then
					local barInput = string.lower(string.sub(props.textBox.Text, 2))
					local barPrefix = string.lower(string.sub(props.textBox.Text, 1,1))
					for _, command in pairs(main.commandInfo) do
						local cName = string.lower(command.Name)
						local cPrefix = command.Prefixes[1]
						if string.sub(cName, 1, #barInput) == barInput and cPrefix == barPrefix then
							table.insert(suggestions, {Name = command.Name, Args = command.Args, Prefixes = command.Prefixes, ArgPos = 0})
							if #suggestions == props.maxSuggestions then
								break
							end
						end
						local unName = command.UnFunction
						if unName then
							if string.sub(string.lower(unName), 1, #barInput) == barInput and cPrefix == barPrefix then
								table.insert(suggestions, {Name = unName, Args = {}, Prefixes = command.Prefixes, ArgPos = 0})
								if #suggestions == props.maxSuggestions then
									break
								end
							end
						end
					end
				elseif props.currentBarCommand or specificArg then
					local cArg
					if specificArg then
						cArg = specificArg
					else
						cArg = props.currentBarCommand.Args[totalArgs]
					end
					local newSuggestion = {}
					local currentBarArg = string.lower(args[totalArgs])
					local endChar = string.sub(props.textBox.Text,-1)
					if endChar ~= " " and endChar ~= main.pdata.SplitKey then
						if cArg == "player" or cArg == "playerarg" then
							for i,v in pairs(main.qualifiers) do
								if collectArguments(suggestions, currentBarArg, totalArgs, v) then
									break
								end
							end
							if #suggestions < props.maxSuggestions then
								for i,plr in pairs(main.players:GetChildren()) do
									if collectArguments(suggestions, currentBarArg, totalArgs, plr.Name) then
										break
									end
								end
							end
						elseif cArg == "colour" or cArg == "color" or cArg == "color3" then
							for i,v in pairs(main.colors) do
								if collectArguments(suggestions, currentBarArg, totalArgs, v) then
									break
								end
							end
						elseif cArg == "material" then
							for i,v in pairs(main.materials) do
								if collectArguments(suggestions, currentBarArg, totalArgs, v) then
									break
								end
							end
						elseif cArg == "rank" then
							for _, rankDetails in pairs(main.settings.Ranks) do
								if collectArguments(suggestions, currentBarArg, totalArgs, rankDetails[2]) then
									break
								end
							end
						elseif cArg == "team" or cArg == "teamcolor" then
							for _,team in pairs(main.teams:GetChildren()) do
								if collectArguments(suggestions, currentBarArg, totalArgs, team.Name) then
									break
								end
							end
						elseif cArg == "morph" then
							for morphName,_ in pairs(main.morphNames) do
								if collectArguments(suggestions, currentBarArg, totalArgs, morphName) then
									break
								end
							end
						elseif cArg == "tools" or cArg == "gears" or cArg == "tool" or cArg == "gear" then
							for toolName,_ in pairs(main.toolNames) do
								if collectArguments(suggestions, currentBarArg, totalArgs, toolName) then
									break
								end
							end
						end
					end
				end
			end
			
			props.suggestionDisplayed = #suggestions
			if props.currentBarCommand and #props.currentBarCommand.Args == totalArgs and props.suggestionDisplayed > 0 then
				forceExecute = true
			else
				forceExecute = false
			end
			
			for i = 1, props.maxSuggestions do
				local suggestion = suggestions[i]
				local label = props.rframe["Label"..i]
				if suggestion then
					local command = false
					if suggestion.Args then
						command = true
					end
					local UP = false
					if command and suggestion.Prefixes[1] == main.settings.UniversalPrefix then
						UP = true
					end
					local newDetail = {}
					if command then
						for i,v in pairs(suggestion.Args) do
							if not UP or v ~= "player" or v == "playerarg" then
								table.insert(newDetail, "<"..v..">")
							end
						end
					end
					label.TextLabel.Text = suggestion.Name.." "..table.concat(newDetail, " ")
					if i == props.suggestionPos then
						label.BackgroundColor3 = props.highlightColor
					else
						label.BackgroundColor3 = props.otherColor
					end
					props.suggestionLabels["Label"..i] = suggestion
					--
					if props.mainParent.Name ~= "CmdBar" then
						local sizeY = props.rframe.LabelTemplate.AbsoluteSize.Y
						local totalSizeY = sizeY * i
						local finalY = props.rframe.AbsolutePosition.Y + totalSizeY
						local limitY = main.gui.Notices.AbsoluteSize.Y
						if finalY+5 > limitY then
							if not originalPosition then
								originalPosition = props.mainParent.Position
							end
							props.mainParent.Position = props.mainParent.Position - UDim2.new(0,0,0,sizeY)
						end
					end
					--
					label.Visible = true
				else
					label.Visible = false
				end
			end
			--
			if originalPosition and #suggestions < 1 then
				props.mainParent.Position = originalPosition
				originalPosition = nil
			end
			if #suggestions < 1 and props.mainParent.Name ~= "CmdBar" then
				props.mainParent.ClipsDescendants = true
			else
				props.mainParent.ClipsDescendants = false
			end
			--
	    end
	end)
end
module:SetupTextbox("cmdbar1", mainProps)


	
-- << FUNCTIONS >>
function module:ToggleBar(keyCode)
	if keyCode == Enum.KeyCode.Quote then
		local cmdBar = main.gui.CmdBar
		if cmdBar.Visible then
			modules.CmdBar:CloseCmdBar()
		else
			modules.CmdBar:OpenCmdBar()
		end
	elseif keyCode == Enum.KeyCode.Semicolon then
		local requiredRank = main.settings.Cmdbar2
		if main.pdata.Rank > 0 or requiredRank <= 0 then
			if main.pdata.Rank < requiredRank then
				local notice = modules.cf:FormatNotice("CommandBarLocked", "2", modules.cf:GetRankName(requiredRank))
				modules.Notices:Notice("Error", notice[1], notice[2])
			else
				local props = currentProps["cmdbar2"]
				if not props then
					modules.ClientCommands["cmdbar2"].Function()
				else
					if props.mainParent.Visible then
						props.mainParent.Visible = false
					else
						props.mainParent.Visible = true
					end
				end
			end
		end
	end
end

function module:OpenCmdBar()
	local props = mainProps
	local requiredRank = main.settings.Cmdbar
	if main.pdata.Rank > 0 or requiredRank <= 0 then
		if main.pdata.Rank < requiredRank then
			local notice = modules.cf:FormatNotice("CommandBarLocked", "", modules.cf:GetRankName(requiredRank))
			modules.Notices:Notice("Error", notice[1], notice[2])
		else
			props.textBox:CaptureFocus()
			for _,coreName in pairs(coreToHide) do
				originalCoreStates[coreName] = main.starterGui:GetCoreGuiEnabled(coreName)
				main.starterGui:SetCoreGuiEnabled(Enum.CoreGuiType[coreName], false)
			end
			modules.TopBar:CoreGUIsChanged()
			topBar.BackgroundColor3 = Color3.fromRGB(50,50,50)
			originalTopBarTransparency = topBar.BackgroundTransparency
			originalTopBarVisibility = topBar.Visible
			topBar.BackgroundTransparency = 0
			topBar.Visible = true
			props.textBox.Text = ""
			cmdBar.Visible = true
			wait()
			props.textBox.Text = main.pdata.Prefix
			props.textBox.CursorPosition = 3
		end
	end
end

function module:CloseCmdBar()
	local props = mainProps
	cmdBar.Visible = false
	for _,coreName in pairs(coreToHide) do
		local originalState = originalCoreStates[coreName]
		if originalState then
			main.starterGui:SetCoreGuiEnabled(Enum.CoreGuiType[coreName], originalState)
		end
	end
	modules.TopBar:CoreGUIsChanged()
	topBar.BackgroundColor3 = Color3.fromRGB(31,31,31)
	topBar.BackgroundTransparency = originalTopBarTransparency
	topBar.Visible = originalTopBarVisibility
	coroutine.wrap(function()
		for i = 1,10 do
			props.textBox:ReleaseFocus()
			wait()
		end
	end)()
end

function module:PressedArrowKey(key)
	for i, props in pairs(currentProps) do
		if props.mainParent.Visible and props.textBox:IsFocused() then
			local originalLabel = props.rframe:FindFirstChild("Label"..props.suggestionPos)
			if key == Enum.KeyCode.Down then
				props.suggestionPos = props.suggestionPos + 1
				if props.suggestionPos > props.suggestionDisplayed then
					props.suggestionPos = 1
				end
			elseif key == Enum.KeyCode.Up then
				props.suggestionPos = props.suggestionPos - 1
				if props.suggestionPos < 1 then
					props.suggestionPos = props.suggestionDisplayed
				end
			elseif key == Enum.KeyCode.Right then
				selectSuggestion(props)
			end
			local newLabel = props.rframe["Label"..props.suggestionPos]
			if newLabel ~= originalLabel then
				originalLabel.BackgroundColor3 = props.otherColor
				newLabel.BackgroundColor3 = props.highlightColor
			end
		end
	end
end



return module
