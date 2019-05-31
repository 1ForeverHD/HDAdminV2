local hd = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules




-- << VARIABLES >>
local errors = {
	Player = "Player does not exist!";
}



-- << API >>
function hd:DisableCommands(player, boolean)
	if boolean then
		main.commandBlocks[player] = true
		local pdata = main.pd[player]
		if pdata and pdata.Donor then
			modules.Parser:ParseMessage(player, "!unlasereyes", false)
		end
	else
		main.commandBlocks[player] = nil
	end
end


function hd:SetRank(player, rank, rankType)
	if tonumber(rank) == nil then
		rank = modules.cf:GetRankId(rank)
	end
	if not player then
		return(errors.Player)
	elseif rank > 5 or (rank == 5 and player.UserId ~= main.ownerId) then
		return("Cannot set a player's rank above or equal to 5 (Owner)!")
	else
		modules.cf:SetRank(player, main.ownerId, rank, rankType)
	end
end


function hd:UnRank(player)
	modules.cf:Unrank(player)
end


function hd:GetRank(player)
	local pdata = main.pd[player]
	if not pdata then
		return(errors.Player)
	else
		local rankId = pdata.Rank
		local rankName = modules.cf:GetRankName(rankId)
		local rankType = modules.cf:GetRankType(player)
		return rankId, rankName, rankType
	end
end



return hd
