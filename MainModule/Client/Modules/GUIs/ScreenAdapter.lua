local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules



-- << VARIABLES >>
local screen_changing = 0
local initialised = false
local framesToAdapt = {
	[main.gui.MainFrame] = 0.78;
	[main.gui.MenuTemplates.Template5] = 0.78;
	[main.gui.MenuTemplates.Template6] = 0.78;
	[main.gui.MenuTemplates.Template7] = 0.78;
	[main.gui.MenuTemplates.Template9] = 0.78;
	[main.gui.MenuTemplates.Template10] = 1.17;
	[main.gui.MenuTemplates.Template11] = 1.17;
	[main.gui.MenuTemplates.Template12] = 0.78;
	}
local deviceFrameSizes = {
	["Phone"] = 1;
	["Tablet"] = 0.8;
	["Computer"] = 0.6;
	}



-- << LOCAL FUNCTIONS >>
local function updateUIs()
	local frameSize = deviceFrameSizes["Computer"]
	if main.device == "Mobile" then
		if main.tablet then
			frameSize = deviceFrameSizes["Tablet"]
		else
			frameSize = deviceFrameSizes["Phone"]
		end
	end
	for frame, aspectRatio in pairs(framesToAdapt) do
		local currentFrameSize = frameSize
		if aspectRatio > 1 then
			currentFrameSize = frameSize/1.5
		end
		frame.Position = UDim2.new(0,0,(1-currentFrameSize)/2,0)
		frame.Size = UDim2.new(0,0,currentFrameSize,0)
		local absoluteX = frame.AbsoluteSize.Y * aspectRatio
		frame.Position = UDim2.new(0.5, -absoluteX/2, frame.Position.Y.Scale, frame.Position.Y.Offset)
		frame.Size = UDim2.new(0, absoluteX, frame.Size.Y.Scale, frame.Size.Y.Offset)
	end
end

local function screenChanged()
	screen_changing = screen_changing + 1
	wait(0.5)
	screen_changing = screen_changing - 1
	if screen_changing == 0 then
		-----------
		updateUIs()
		-----------
		modules.PageAbout:CreateCredits()
	end
end



-- << SETUP >>
main.gui.Changed:Connect(function(prop)
	if prop == "AbsoluteSize" then
		screenChanged()
	end
end)
updateUIs()



return module
