local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules



-- << VARIABLES >>
local frame = main.gui.MainFrame.Pages["Special"]
local pages = {
	donor = frame.Donor;
}
local templateGame = pages.donor.TemplateGame
local firstLabel = pages.donor["A Space"]
local finalLabel = pages.donor["AZ Space"]
local unlockDonor = pages.donor["AG Unlock"]
local teleportFrame = main.warnings.Teleport



-- << SETUP >>
-- Donor Commands
local donorCommands = {}
for _, command in pairs(main.commandInfo) do
	if command.RankName == "Donor" then
		table.insert(donorCommands, command)
	end
end

--Game which use Donor
local gamesWithDonor = {
	{1828225164, "Guest World"};
	{2921400152, "4PLR Tycoon"};
	{574407221, "Super Hero Tycoon"};
	{2317684217, "Family Life"};
	{591993002, "OHD Roleplay World"};
	{2776301757, "Life In Paradise"};
	{2482656387, "Rap Battles"};
	{2493148083, "SkyWars 2"};
	{1128497210, "Adopt and Raise"};
	{2692178444, "Planet L. Simulator"};
	{2616211189, "Parkour Obby"};
	{1869852507, "Iceberg Hotels"};
	{49254942, "2 Player House Tycoon"};
	{2764548803, "Island Hotel"};
}
for i, gameData in pairs(gamesWithDonor) do
	local gameId = gameData[1]
	local gameName = gameData[2]
	local row = math.ceil(i/2)
	local column = i % 2 
	local gamePage
	if column == 1 then
		gamePage = templateGame:Clone()
		gamePage.Name = "AI Game".. row
		gamePage.Visible = true
		gamePage.Parent = pages.donor
	else
		gamePage = pages.donor["AI Game".. row]
	end
	local gameThumbnail = gamePage["GameImage"..column]
	local gameLabel = gamePage["GameName"..column]
	local image = "https://assetgame.roblox.com/Game/Tools/ThumbnailAsset.ashx?aid=".. gameId .."&fmt=png&wd=420&ht=420"
	gameThumbnail.Image = image
	gameLabel.Text = gameName
	gameThumbnail.Visible = true
	gameLabel.Visible = true
	
	--Teleport to game
	local selectButton = gameThumbnail.Select
	local clickFrame = gameThumbnail.ClickFrame
	selectButton.MouseButton1Click:Connect(function()
		teleportFrame.ImageLabel.Image = image
		teleportFrame.TeleportTo.TextLabel.Text = gameName.."?"
		teleportFrame.MainButton.PlaceId.Value = gameId
		modules.cf:ShowWarning("Teleport")
	end)
	selectButton.MouseEnter:Connect(function()
		if not main.warnings.Visible then
			clickFrame.Visible = true
		end
	end)
	selectButton.MouseLeave:Connect(function()
		clickFrame.Visible = false
	end)
	teleportFrame.Visible = true
	
end

--Unlock
pages.donor["AG Unlock"].Unlock.MouseButton1Down:Connect(function()
	main.marketplaceService:PromptGamePassPurchase(main.player, main.products.Donor)
end)



-- << FUNCTIONS >>
function module:SetupDonorCommands()
	modules.PageCommands:SetupCommands(donorCommands, pages.donor, 0)
	module:UpdateDonorFrame()
end

function module:UpdateDonorFrame()
	if main.pdata.Donor then
		unlockDonor.Visible = false
	else
		unlockDonor.Visible = true
	end
	pages.donor.CanvasSize = UDim2.new(0, 0, 0, (finalLabel.AbsolutePosition.Y - firstLabel.AbsolutePosition.Y) + finalLabel.AbsoluteSize.Y*1)
end



return module
