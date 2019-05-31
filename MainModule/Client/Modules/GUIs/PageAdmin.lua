local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules



-- << VARIABLES >>
local frame = main.gui.MainFrame.Pages.Admin
local buyFrame = main.warnings.BuyFrame
local unBan = main.warnings.UnBan
local pages = {
	ranks = frame.Ranks;
	serverRanks = frame["Server Ranks"],
	banland = frame.Banland;
}
local templates = {
	rankTitle = pages.ranks.TemplateRankTitle;
	rankItem = pages.ranks.TemplateRankItem;
	space = pages.ranks.TemplateSpace;
	admin = pages.serverRanks.TemplateAdmin;
	ban = pages.banland.TemplateBan;
	banTitle = pages.banland.TemplateTitle
}
local otherPermissions = {
	{"friends", 		main.ownerName.."'s Friends", 	"For friends of the Owner"};
	{"freeadmin", 		"Free Admin", 					"For everyone"};
	{"vipserverowner", 	"VIP Server Owner", 			"For VIP Server owners"};
	{"vipserverplayer", "VIP Server Player", 			"For VIP Server players"};
}



-- << RANKS >>
---------------------------------------------------
function module:SetupRanks()
	
	module:CreateRanks()
	
end
	
---------------------------------------------------
function module:CreateRanks()
	coroutine.wrap(function()
		
		local ranksInfo = main.signals.RetrieveRanksInfo:InvokeServer()
		local permRanksInfo = ranksInfo.PermRanks
		local ranksToSort = ranksInfo.Ranks
		local permissions = ranksInfo.Permissions
		
		--Organise ranks
		local rankPositions = {}
		local ranks = {}
		for i, rankDetails in pairs(ranksToSort) do
			local rankId = rankDetails[1]
			local rankName = rankDetails[2]
			table.insert(ranks, 1, {rankId, rankName, {}})
		end
		for i,v in pairs(ranks) do
			rankPositions[v[1]] = i
		end
		
		for pName, pDetails in pairs(permissions) do
			--Owner
			if pName == "owner" and rankPositions[5] then
				local ownerRankDetail = ranks[rankPositions[5]]
				table.insert(ownerRankDetail[3], {main.ownerName, "Owner", modules.cf:GetUserImage(main.ownerId)})
			--SpecificUsers and PermRanks
			elseif pName == "specificusers" then
				for plrName, rankId in pairs(pDetails) do
					if #plrName > 1 then
						local rankDetail = ranks[rankPositions[rankId]]
						local boxInfo = {plrName, "Specific User", modules.cf:GetUserImage(modules.cf:GetUserId(plrName))}
						table.insert(rankDetail[3], boxInfo)
					end
				end
				for i, record in pairs(permRanksInfo) do
					if not record.RemoveRank then
						local rankDetail = ranks[rankPositions[record.Rank]]
						if rankDetail then
							local boxInfo = {modules.cf:GetName(record.UserId), "PermRank", modules.cf:GetUserImage(record.UserId), record}
							table.insert(rankDetail[3], boxInfo)
						end
					end
				end
			elseif pName == "gamepasses" then
				--Gamepasses
				for gamepassId, gamepassInfo in pairs(pDetails) do
					if not modules.cf:FindValue(main.products, gamepassId) then
						local rankDetail = ranks[rankPositions[gamepassInfo.Rank]]
						if rankDetail then
							local boxInfo = {gamepassInfo.Name, "Gamepass", gamepassInfo.IconImageAssetId, tonumber(gamepassId), gamepassInfo.PriceInRobux}
							table.insert(rankDetail[3], boxInfo)
						end
					end
				end
			elseif pName == "assets" then
				--Assets
				for assetId, assetInfo in pairs(pDetails) do
					local rankDetail = ranks[rankPositions[assetInfo.Rank]]
					if rankDetail then
						local boxInfo = {assetInfo.Name, "Asset", modules.cf:GetAssetImage(assetId), tonumber(assetId), assetInfo.PriceInRobux}
						table.insert(rankDetail[3], boxInfo)
					end
				end
			elseif pName == "groups" then
				--Groups
				for groupId, groupInfo in pairs(pDetails) do
					for roleName, roleInfo in pairs(groupInfo.Roles) do
						if roleInfo.Rank then
							local rankDetail = ranks[rankPositions[roleInfo.Rank]]
							if rankDetail then
								local boxInfo = {groupInfo.Name.." | "..roleName, "Group", groupInfo.EmblemUrl, tonumber(groupId)}
								table.insert(rankDetail[3], boxInfo)
							end
						end
					end
				end
			elseif otherPermissions[pName] then
				--Other
				local info = otherPermissions[pName]
				local rank = permissions[info[1]]
				if rank > 0 then
					local rankDetail = ranks[rankPositions[rank]]
					if rankDetail then
						local boxInfo = {info[2], info[3], string.upper(string.sub(info[1], 1, 1))}
						table.insert(rankDetail[3], boxInfo)
					end
				end
			end
		end
		--Can view PermRank menu
		local canModifyPermRanks = false
		if main.pdata.Rank >= (main.commandRanks.permrank or 4) then
			canModifyPermRanks = true
		end
		
		--Clear labels
		modules.cf:ClearPage(pages.ranks)
			
		--Setup labels
		local labelCount = 0
		for i,v in pairs(ranks) do
			local rankId = v[1]
			local rankName = v[2]
			local boxes = v[3]
			--
			labelCount = labelCount + 1
			local rankTitle = templates.rankTitle:Clone()
			rankTitle.Name = "Label".. labelCount
			rankTitle.RankIdFrame.TextLabel.Text = rankId
			rankTitle.RankName.Text = rankName
			rankTitle.Visible = true
			rankTitle.Parent = pages.ranks
			--
			for _, boxInfo in pairs(boxes) do
				labelCount = labelCount + 1
				local boxTitle = boxInfo[1]
				local boxDesc = boxInfo[2]
				local boxImage = boxInfo[3]
				local rankItem = templates.rankItem:Clone()
				rankItem.Name = "Label".. labelCount
				rankItem.ItemTitle.Text = boxTitle
				rankItem.ItemDesc.Text = boxDesc
				if #tostring(boxImage) == 1 then
					rankItem.ItemIcon.Text = boxImage
					rankItem.ItemIcon.Visible = true
					rankItem.ItemImage.Visible = false
				else
					if tonumber(boxImage) then
						boxImage = "rbxassetid://"..boxImage
					end
					rankItem.ItemImage.Image = tostring(boxImage)
				end
				local xScale = 0.7
				rankItem.Unlock.Visible = false
				rankItem.ViewMore.Visible = false
				if boxDesc == "Gamepass" or boxDesc == "Asset" then
					local productId = boxInfo[4]
					local productPrice = boxInfo[5]
					rankItem.ItemImage.BackgroundTransparency = 1
					rankItem.Unlock.Visible = true
					rankItem.Unlock.MouseButton1Down:Connect(function()
						buyFrame.ProductName.Text = boxTitle
						buyFrame.ProductImage.Image = boxImage
						buyFrame.PurchaseToUnlock.TextLabel.Text = rankName
						buyFrame.InGame.TextLabel.Text = main.gameName
						buyFrame.MainButton.Price.Text = (productPrice or 0).." "
						buyFrame.MainButton.ProductId.Value = productId
						buyFrame.MainButton.ProductType.Value = boxDesc
						modules.cf:ShowWarning("BuyFrame")
					end)
					xScale = 0.4
				elseif boxDesc == "PermRank" then
					local record = boxInfo[4]
					if canModifyPermRanks then
						local viewMore = rankItem.ViewMore
						viewMore.Visible = true
						viewMore.MouseButton1Down:Connect(function()
							modules.cf:ShowPermRankedUser{boxTitle, record.UserId, record.RankedBy}
						end)
					end
					xScale = 0.6
				else
					xScale = 0.7
				end
				rankItem.ItemTitle.Size = UDim2.new(xScale, 0, rankItem.ItemTitle.Size.Y.Scale, 0)
				rankItem.ItemDesc.Size = UDim2.new(xScale, 0, rankItem.ItemDesc.Size.Y.Scale, 0)
				rankItem.Visible = true
				rankItem.Parent = pages.ranks
			end
		end
		
		--Canvas Size
		if labelCount >= 2 then
			for i = 1,2 do
				local firstLabel = pages.ranks["Label1"]
				local finalLabel = pages.ranks["Label".. labelCount]
				pages.ranks.CanvasSize = UDim2.new(0, 0, 0, (finalLabel.AbsolutePosition.Y + finalLabel.AbsoluteSize.Y - firstLabel.AbsolutePosition.Y))
			end
		end
	
	end)()
end



-- << SERVER RANKS >>
function module:CreateServerRanks()
	coroutine.wrap(function()
	
		local serverRankInfo = main.signals.RetrieveServerRanks:InvokeServer()
		
		--Organise ranks
		local rankPositions = {}
		local ranks = {}
		local plrRanks = {}
		for i, rankDetails in pairs(main.settings.Ranks) do
			local rankId = rankDetails[1]
			local rankName = rankDetails[2]
			table.insert(ranks, 1, {rankId, rankName, {}})
		end
		for i,v in pairs(ranks) do
			rankPositions[v[1]] = i
		end
		
		--Split players into ranks
		for i, playerRankInfo in pairs(serverRankInfo) do
			local plr = playerRankInfo.Player
			local rankId = playerRankInfo.RankId
			local rankTypeId = playerRankInfo.RankType
			local rankDetail = ranks[rankPositions[rankId]]
			if rankDetail then
				table.insert(rankDetail[3], {plr, rankTypeId})
			end
		end
	
		--Sort ranks by RankType (Perm > Server > Temp)
		for i, rankInfo in pairs(ranks) do
			local listOfPlrs = rankInfo[3]
			table.sort(listOfPlrs, function(a,b) return a[2] < b[2] end)
		end
		
		--Clear labels
		modules.cf:ClearPage(pages.serverRanks)
		
		--Setup labels
		local rankTypesReversed = {}
		for a,b in pairs(main.rankTypes) do
			rankTypesReversed[b] = a
		end
		local labelCount = 0
		for i, rankInfo in pairs(ranks) do
			local rankId = rankInfo[1]
			local rankName = rankInfo[2]
			local listOfPlrs = rankInfo[3]
			for _, playerRankDetail in pairs(listOfPlrs) do
				labelCount = labelCount + 1
				local plr = playerRankDetail[1]
				local rankTypeId = playerRankDetail[2]
				local rankTypeName = rankTypesReversed[rankTypeId]
				local label = templates.admin:Clone()
				label.Name = "Label".. labelCount
				label.PlrName.Text = plr.Name
				label.PlrRank.Text = rankName.." ("..rankTypeName..")"
				label.PlayerImage.Image = modules.cf:GetUserImage(plr.UserId)
				label.BackgroundColor3 = modules.cf:GetLabelBackgroundColor(labelCount)
				label.Visible = true
				label.Parent = pages.serverRanks
			end
		end
		
		--Canvas Size
		pages.serverRanks.CanvasSize = UDim2.new(0, 0, 0, labelCount*templates.admin.AbsoluteSize.Y)
		
	end)()
end



-- << BANLAND >>
local banlandDe = true
function module:CreateBanland()
	coroutine.wrap(function()
	
		if not banlandDe then
			return
		else
			banlandDe = false
		end
		local totalY = 0
		if main.pdata.Rank < main.settings.ViewBanland then
			modules.cf:ClearPage(pages.banland)
			local label = templates.banTitle:Clone()
			label.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
			label.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			label.TextLabel.Text = "Must be rank '".. modules.cf:GetRankName(main.settings.ViewBanland).."' or higher to view the Banland"
			label.Name = "TitleLabel"
			label.Visible = true
			label.Parent = pages.banland
		else
			
			--Retrieve Info
			local banlandInfo = main.signals.RetrieveBanland:InvokeServer()
			local canModifyBans = false
			if main.pdata.Rank >= (main.commandRanks.directban or 4) then
				canModifyBans = true
			end		
			
			--Clear labels
			modules.cf:ClearPage(pages.banland)
			
			--Setup Labels
			local sectionNames = {"Current Server", "All Servers"}
			for section, records in pairs(banlandInfo) do
				--
				if #records > 0 then
					local label = templates.banTitle:Clone()
					label.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
					label.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					label.TextLabel.Text = sectionNames[section]
					label.Name = "TitleLabel"
					totalY = totalY + templates.banTitle.AbsoluteSize.Y
					label.Visible = true
					label.Parent = pages.banland
				end
				--
				for i, record in pairs(records) do
					totalY = totalY + templates.ban.AbsoluteSize.Y
					local label = templates.ban:Clone()
					local userId = record.UserId
					label.Name = "BanLabel"
					label.PlrName.Text = modules.cf:GetName(userId)
					local banDateString
					local banTime = record.BanTime
					if tonumber(banTime) then
						banDateString = modules.cf:GetBanDateString(os.date("*t", banTime))
					else
						banDateString = "Infinite"
					end
					label.BanLength.Text = banDateString
					label.PlayerImage.Image = modules.cf:GetUserImage(userId)
					label.BackgroundColor3 = modules.cf:GetLabelBackgroundColor(i)
					if canModifyBans then
						label.ViewMore.Visible = true
						label.ViewMore.MouseButton1Down:Connect(function()
							modules.cf:ShowBannedUser{label.PlrName.Text, userId, record.Reason, record.BannedBy}
						end)
					else
						label.ViewMore.Visible = false
					end
					label.Visible = true
					label.Parent = pages.banland
				end
			end
		
		
		end
		
		--Canvas Size
		pages.banland.CanvasSize = UDim2.new(0, 0, 0, totalY)
		
		banlandDe = true
	
	end)()
end

function module:UpdatePages()
	module:CreateServerRanks()
	module:CreateBanland()
	module:CreateRanks()
end



-- << AUTO UPDATE FRAMES >>
spawn(function()
	while wait(20) do
		if frame.Visible and main.gui.MainFrame.Visible then
			module:UpdatePages()
		end
	end
end)





return module
