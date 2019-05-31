local module = {}

function module:Initialize(loader)
	local main = require(script.Client.SharedModules.MainFramework)
	main:Initialize("Server", loader)
end

return module
