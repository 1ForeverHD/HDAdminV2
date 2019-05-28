local module = {}

-- Main Setup
function module:Initialize(loaderFolder)
	local main = require(script.Client.SharedModules.MainFramework)
	for a,b in pairs(loaderFolder:GetChildren()) do
		if b:IsA("ModuleScript") and b.Name == "Settings" then
			main.settings = require(b)
		end
	end
	main:Initialize("Server", script)
	main.modules.LoaderHandler:Setup(loaderFolder)
end



-- Old Setup (will remain for a few weeks to enable developers to update their Loaders)
function module:UpdateSettings(oldSettings)
	local main = require(script.Client.SharedModules.MainFramework)
	local loaderFolder = script.Server.Assets.LoaderCopy
	for a,b in pairs(loaderFolder:GetChildren()) do
		if b:IsA("ModuleScript") and b.Name == "Settings" then
			main.settings = require(b)
		end
	end
	for a,b in pairs(oldSettings) do
		main.settings[a] = b
	end
	main.oldLoader = true
	main:Initialize("Server", script)
	main.modules.LoaderHandler:Setup(loaderFolder)
end



return module
