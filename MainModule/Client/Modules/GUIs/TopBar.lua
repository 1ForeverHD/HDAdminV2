local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules



-- << VARIABLES >>
local topBarFrame = main.gui.CustomTopBar
local topBarY = main.guiService:GetGuiInset().Y
local mainFrame = main.gui.MainFrame
local imageButton = topBarFrame.ImageButton



-- << FUNCTIONS >>
function module:CoreGUIsChanged()
	if main.topbarEnabled then
	
		--TopBar Icon Position
		local enabledCount = 1
		if main.starterGui:GetCoreGuiEnabled("Chat") and main.device ~= "Console" then
			if main.device == "Mobile" then
				enabledCount = enabledCount + 2
			else
				enabledCount = enabledCount + 1
			end
		end
		if main.starterGui:GetCoreGuiEnabled("Backpack") then
			enabledCount = enabledCount + 1
		end
		imageButton.Position = UDim2.new(0,50*enabledCount,0.1,0)
		
		--TopBar Transparency
		main.playerGui:SetTopbarTransparency(1)
		
	end
end



-- << SETUP >>
-- Toggle MainFrame through TopBar Icon
topBarFrame.Size = UDim2.new(1,0,0,topBarY)
topBarFrame.Position = UDim2.new(0,0,0,-topBarY)
imageButton.MouseButton1Down:Connect(function()
	if imageButton.ImageColor3 == Color3.fromRGB(255,255,255) then
		modules.GUIs:OpenMainFrame()
	else
		modules.GUIs:CloseMainFrame()
	end
end)

-- TopBar Icons changed
--[[
	I would like to fire only when the topbar is changed, however the event is locked: https://devforum.roblox.com/t/are-there-any-alternatives-to-coreguichangedsignal/175837
	For now I'll be using a loop. If you have a better solution, please get in contact with ForeverHD on the DevForum.
--]]
spawn(function()
	imageButton.ImageTransparency = 1
	topBarFrame.Visible = main.topbarEnabled
	while true do
		module:CoreGUIsChanged()
		wait(0.5)
	end
end)

--[[
	At this point in time, developers will have to manually modify the HD Admin TopBar as Roblox don't provide much support when working with the TopBar:
		hd:SetTopbarTransparency(number)
		hd:SetTopbarEnabled(boolean)
--]]


return module
