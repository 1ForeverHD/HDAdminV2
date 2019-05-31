local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules



-- << VARIABLES >>
local topBarFrame = main.gui.CustomTopBar



-- << SETUP >>
for _,revent in pairs(main.signals:GetChildren()) do
	if revent:IsA("RemoteEvent") then
		revent.OnClientEvent:Connect(function(args)
			if not main.initialized then main.client.Signals.Initialized.Event:Wait() end
			
			---------------------------------------------
			if revent.Name == "ChangeStat" then
				local statName, newValue = args[1], args[2]
				main.pdata[statName] = newValue
				if statName == "Donor" then
					modules.PageSpecial:UpdateDonorFrame()
				end
			
			elseif revent.Name == "InsertStat" then
				local locationName, newValue = args[1], args[2]
				table.insert(main.pdata[locationName], newValue)
				
			elseif revent.Name == "RemoveStat" then
				local locationName, newValue = args[1], args[2]
				for i,v in pairs(main.pdata[locationName]) do
					if tostring(v) == tostring(newValue) then
						table.remove(main.pdata[locationName], i)
						break
					end
				end
			
			elseif revent.Name == "Notice" or revent.Name == "Error" then
				modules.Notices:Notice(revent.Name, args[1], args[2], args[3])
					
			elseif revent.Name == "ShowPage" then
				modules.GUIs:ShowSpecificPage(args[1], args[2])
				
			elseif revent.Name == "ShowBannedUser" then
				modules.GUIs:ShowSpecificPage("Admin", "Banland")
				if type(args) == "table" then
					modules.cf:ShowBannedUser(args)
				end
			
			elseif revent.Name == "ChangeCameraSubject" then
				modules.cf:ChangeCameraSubject(args)
				
			elseif revent.Name == "Clear" then
				modules.Messages:ClearMessageContainer()
				
			elseif revent.Name == "ShowWarning" then
				modules.cf:ShowWarning(args)
			
			elseif revent.Name == "Message" then
				modules.Messages:Message(args)
			
			elseif revent.Name == "Hint" then
				modules.Messages:Hint(args)
				
			elseif revent.Name == "GlobalAnnouncement" then
				modules.Messages:GlobalAnnouncement(args)
			
			elseif revent.Name == "SetCoreGuiEnabled" then
				main.starterGui:SetCoreGuiEnabled(Enum.CoreGuiType[args[1]], args[2])
			
			elseif revent.Name == "CreateLog" then
				modules.cf:CreateNewCommandMenu(args[1], args[2], 5)
			
			elseif revent.Name == "CreateAlert" then
				modules.cf:CreateNewCommandMenu("alert", {args[1], args[2]}, 8, true)
			
			elseif revent.Name == "CreateBanMenu" then
				modules.cf:CreateNewCommandMenu("banMenu", args, 6)
			
			elseif revent.Name == "CreatePollMenu" then
				modules.cf:CreateNewCommandMenu("pollMenu", args, 9)
			
			elseif revent.Name == "CreateMenu" then
				modules.cf:CreateNewCommandMenu(args.MenuName, args.Data, args.TemplateId)
			
			elseif revent.Name == "CreateCommandMenu" then
				local title = args[1]
				local details = args[2]
				local menuType = args[3]
				modules.cf:CreateNewCommandMenu(title, details, menuType)
			
			elseif revent.Name == "RankChanged" then
				modules.GUIs:DisplayPagesAccordingToRank(true)
				if main.initialized then
					modules.PageCommands:CreateCommands()
				end
				
			elseif revent.Name == "ExecuteClientCommand" then
				local speaker, args, commandName, other = args[1], args[2], args[3], args[4]
				local unFunction = other.UnFunction
				local functionType = "Function"
				if unFunction then
					functionType = "UnFunction"
				end
				local clientCommand = modules.ClientCommands[commandName]
				if clientCommand then
					local Function = clientCommand[functionType]
					if Function then
						Function(speaker, args, clientCommand)
					end
				end
			
			elseif revent.Name == "ActivateClientCommand" then
				local commandName = args[1]
				local extraDetails = args[2]
				--Custom speed
				local speed = extraDetails and ((extraDetails.Speed ~= 0 and extraDetails.Speed) or nil)
				if speed then
					main.commandSpeeds[commandName] = speed
					local oldMenu = main.gui:FindFirstChild("CommandMenufly")
					modules.cf:DestroyCommandMenuFrame(oldMenu)
				end
				--Deactivate other flight commands 
				if main.commandSpeeds[commandName] then
					for otherCommandName, _ in pairs(main.commandSpeeds) do
						if otherCommandName ~= commandName then
							modules.cf:DeactivateCommand(otherCommandName)
						end
					end
				end
				--Activate command
				main.commandsAllowedToUse[commandName] = true
				modules.cf:ActivateClientCommand(commandName, extraDetails)
				--Setup command menu
				local menuDetails, menuType
				for menuTypeName, menuCommands in pairs(main.commandsWithMenus) do
					menuDetails = menuCommands[commandName]
					if menuDetails then
						menuType = tonumber(menuTypeName:match("%d+"))
						break
					end
				end
				if menuDetails then
					modules.cf:CreateNewCommandMenu(commandName, menuDetails, menuType)
				end
			
			elseif revent.Name == "DeactivateClientCommand" then
				modules.cf:DeactivateCommand(args[1])
			
			elseif revent.Name == "FadeInIcon" then
				local topBarFrame = main.gui.CustomTopBar
				local imageButton = topBarFrame.ImageButton
				imageButton.ImageTransparency = 1
				main.tweenService:Create(imageButton, TweenInfo.new(1), {ImageTransparency = 0}):Play()
				
				
					
			end
			---------------------------------------------
			
		end)
	
	
	
	
	
	
	
	
	elseif revent:IsA("RemoteFunction") then
		function revent.OnClientInvoke(args)
			if not main.initialized then main.client.Signals.Initialized.Event:Wait() end
			
			---------------------------------------------
			if revent.Name == "GetLocalDate" then
				return os.date("*t", args)
				
				
			end
		end
	
	
	
	
	
	
	end
end
			



return module
