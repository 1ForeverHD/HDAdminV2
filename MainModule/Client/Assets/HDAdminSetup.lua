local module = {}

function module:GetClientFolder()
	return(game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"))
end

function module:GetMain(skipCheck)
	local main = require(module:GetClientFolder():WaitForChild("SharedModules").MainFramework)
	if skipCheck ~= true then
		main = main:CheckInitialized()
	end
	return main
end

return module
