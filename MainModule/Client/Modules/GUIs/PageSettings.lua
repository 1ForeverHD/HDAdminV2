local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules



-- << VARIABLES >>
local frame = main.gui.MainFrame.Pages.Settings
local pages = {
	custom = frame.Custom;
}
local themeColors = main.settings.ThemeColors or {
	{"Red", 	Color3.fromRGB(150, 0, 0),		};
	{"Orange", 	Color3.fromRGB(150, 75, 0),		};
	{"Brown", 	Color3.fromRGB(120, 80, 30),	};
	{"Yellow", 	Color3.fromRGB(130, 120, 0),	};
	{"Green", 	Color3.fromRGB(0, 120, 0),		};
	{"Blue", 	Color3.fromRGB(0, 100, 150),	};
	{"Purple", 	Color3.fromRGB(100, 0, 150),	};
	{"Pink",	Color3.fromRGB(150, 0, 100),	};
	{"Black", 	Color3.fromRGB(60, 60, 60),		};
}



-- << CUSTOM >>
-- Theme
local ratio = 6.1/#themeColors
local themeFrame = pages.custom["AB ThemeSelection"]
local themeDe = true
local function updateThemeSelection(themeName, themeColor)
	if themeName == nil then
		for i,v in pairs(themeColors) do
			if v[1] == main.pdata.Theme then
				themeName = v[1]
				themeColor = v[2]
				break
			end
		end
	end
	if themeName then
		local themeFrames = {}
		for a,b in pairs(main.gui:GetDescendants()) do
			if b:IsA("BoolValue") and b.Name == "Theme" then
				table.insert(themeFrames, b.Parent)
			end
		end 
		for _,f in pairs(themeFrames) do
			local newThemeColor = themeColor
			if f.Theme.Value then
				local h,s,v = Color3.toHSV(themeColor)
				newThemeColor = Color3.fromHSV(h, s, v*1.35)
			end
			if f:IsA("TextLabel") then
				local h,s,v = Color3.toHSV(themeColor)
				newThemeColor = Color3.fromHSV(h, s, v*2)
				f.TextColor3 = newThemeColor
			else
				f.BackgroundColor3 = newThemeColor
			end
		end
		for a,b in pairs(themeFrame:GetChildren()) do
			if b:IsA("TextButton") then
				if b.Name == themeName then
					b.BorderSizePixel = 1
				else
					b.BorderSizePixel = 0
				end
			end
		end
	end
end
for i, theme in pairs(themeColors) do
	local themeName = theme[1]
	local themeColor = theme[2]
	local box = themeFrame.ThemeTemplate:Clone()
	box.Name = themeName
	box.UIAspectRatioConstraint.AspectRatio = ratio
	box.BackgroundColor3 = themeColor
	box.MouseButton1Down:Connect(function()
		if themeDe then
			themeDe = false
			main.signals.ChangeSetting:InvokeServer{"Theme", themeName}
			updateThemeSelection(themeName, themeColor)
			themeDe = true
		end
	end)
	box.Visible = true
	box.Parent = themeFrame
end

--[[
local gui = game.StarterGui.HDAdminGUIs
for a,b in pairs(gui:GetDescendants()) do
	if b:IsA("GuiObject") and b.BackgroundColor3 == Color3.fromRGB(0, 100, 150) and b:FindFirstChild("Theme") == nil then
		local bool = Instance.new("BoolValue")
		bool.Name = "Theme"
		bool.Parent = b
	end
end
--]]

--Commands and Sounds
local function updateSettings()
	for a,b in pairs(pages.custom:GetChildren()) do
		local settingName = string.sub(b.Name, 5)
		if b:FindFirstChild("SettingValue") then
			b.SettingName.TextLabel.Text = settingName..":"
			local settingValue = main.pdata[settingName]
			b.SettingValue.TextBox.Text = tostring(settingValue)
			local soundName
			local propertyStart
			if string.sub(settingName, 1, 5) == "Error" then
				soundName = "Error"
				propertyStart = 6
			elseif string.sub(settingName, 1, 6) == "Notice" then
				soundName = "Notice"
				propertyStart = 7
			end
			if soundName then
				local sound = main.audio[soundName]
				local propertyName = string.sub(settingName, propertyStart)
				if propertyName == "SoundId" then
					settingValue = "rbxassetid://"..settingValue
				end
				sound[propertyName] = settingValue
			end
		end
	end
	updateThemeSelection()
end
for a,b in pairs(pages.custom:GetChildren()) do
	local settingName = string.sub(b.Name, 5)
	if b:FindFirstChild("SettingValue") then
		local settingDe = true
		local textBox = b.SettingValue.TextBox
		local textLabel = b.SettingValue.TextLabel
		b.SettingValue.TextBox.FocusLost:connect(function(property)
			if settingDe then
				local newValue = b.SettingValue.TextBox.Text
				settingDe = false
				textBox.Visible = false
				textLabel.Visible = true
				textLabel.Text = "Loading..."
				local returnMsg = main.signals.ChangeSetting:InvokeServer{settingName, newValue}
				if returnMsg == "Success" then
					updateSettings()
					local noticeType = "Notice"
					local settingType = string.sub(settingName, 1, 5)
					if settingType == "Error" or settingType == "Alert" then
						noticeType = settingType
					end
					if settingName == "Prefix" then
						modules.PageCommands:CreateCommands()
					end
					local noticeMessage = "Successfully changed '"..settingName.."' to '"..newValue.."'"
					if noticeType == "Alert" then
						modules.cf:CreateNewCommandMenu("settings", {"Settings Alert", noticeMessage}, 8, true)
					else
						modules.Notices:Notice(noticeType, "Settings", noticeMessage)
					end
				else
					textLabel.Text = returnMsg
					wait(1)
				end
				textBox.Visible = true
				textLabel.Visible = false
				b.SettingValue.TextBox.Text = tostring(main.pdata[settingName])
				settingDe = true
			end
		end)
	end
end
updateSettings()

--Restore Default Settings
local restore = pages.custom["AX Restore"]
local loading = restore.Loading
local restoreDe = 0
restore.MouseButton1Down:Connect(function()
	if restoreDe < 2 then
		local h,s,v = Color3.toHSV(restore.BackgroundColor3)
		loading.BackgroundColor3 = Color3.fromHSV(h, s, v*0.5)
		loading.Visible = true
		if restoreDe == 0 then
			restoreDe = 1
			loading.Blocker.Visible = false
			loading.TextLabel.Text = "Confirm?"
			wait(1)
		elseif restoreDe == 1 then
			restoreDe = 2
			loading.Blocker.Visible = true
			loading.TextLabel.Text = "Loading..."
			local returnMsg = main.signals.RestoreDefaultSettings:InvokeServer()
			if returnMsg == "Success" then
				updateSettings()
				modules.PageCommands:CreateCommands()
				local notice = modules.cf:FormatNotice("RestoreDefaultSettings")
				modules.Notices:Notice("Notice", notice[1], notice[2])
			else
				restore.TextLabel.Text = returnMsg
			end
			wait(1)
		end
		restoreDe = 0
		loading.Visible = false
		loading.Blocker.Visible = false
	end
end)

--Canvas Size
local firstLabel = pages.custom["AA Space"]
local finalLabel = pages.custom["AZ Space"]
pages.custom.CanvasSize = UDim2.new(0, 0, 0, (finalLabel.AbsolutePosition.Y - firstLabel.AbsolutePosition.Y) + finalLabel.AbsoluteSize.Y*1)



return module
