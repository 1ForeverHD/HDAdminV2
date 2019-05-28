local hd = {}


-- << RETRIEVE FRAMEWORK >>
local main = require(game:GetService("ReplicatedStorage").HDAdminContainer.SharedModules.MainFramework) local modules = main.modules



-- << API >>
function hd:GetRankName(rankId)
	return(modules.cf:GetRankName(rankId))
end

function hd:GetRankId(rankName)
	return(modules.cf:GetRankId(rankName))
end

function hd:Notice(player, message)
	if main.player then
		if message then
			modules.Notices:Notice("Notice", "Game Notice", message)
		end
	else
		main.network.Notice:FireClient(player, {"Game Notice", message})
	end
end

function hd:Error(player, message)
	if main.player then
		if message then
			modules.Notices:Notice("Error", "Game Notice", message)
		end
	else
		main.network.Error:FireClient(player, {"Game Notice", message})
	end
end




return hd
