local hd = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules



-- << VARIABLES >>
local topBarFrame = main.gui.CustomTopBar



-- << API >>
function hd:SetTopbarTransparency(number)
	number = tonumber(number) or 0.5
	topBarFrame.BackgroundTransparency = number
end

function hd:SetTopbarEnabled(boolean)
	if type(boolean) ~= "boolean" then
		boolean = true
	end
	main.topbarEnabled = boolean
	topBarFrame.Visible = boolean
	modules.TopBar:CoreGUIsChanged()
end



return hd
