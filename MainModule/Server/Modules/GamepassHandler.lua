local module = {}


local main = _G.HDAdminMain
local modules = main.modules


--Purchase and receive gamepasses
main.marketplaceService.PromptGamePassPurchaseFinished:Connect(function(player,assetId,isPurchased)
	local pdata = main.pd[player]
	if isPurchased and pdata then
		local validGamepass = main.permissions.gamepasses[tostring(assetId)]
		if validGamepass and not modules.cf:FindValue(pdata.Gamepasses, assetId) then
			modules.PlayerData:InsertStat(player, "Gamepasses", assetId)
			modules.cf:RankPlayerSimple(player, validGamepass.Rank)
			if not modules.cf:FindValue(main.products, assetId) then
				modules.cf:FormatAndFireNotice(player, "UnlockRank", modules.cf:GetRankName(validGamepass.Rank))
			end
			modules.cf:CheckAndRankToDonor(player, pdata, assetId)
		end
	end
end)




return module
