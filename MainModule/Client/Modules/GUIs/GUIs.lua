local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules


-- << VARIABLES >>
local subPageOrders = {
	["About"] = {"Info", "Updates", "Credits"};
	["Commands"] = {"Commands", "Morphs", "Details"};
	["Special"] = {"Donor", "Coming soon"};
	["Admin"] = {"Ranks", "Server Ranks", "Banland"};
	["Settings"] = {"Custom"};
}
local mainFrame = main.gui.MainFrame
local TopBarFrame = main.gui.CustomTopBar
local pages = mainFrame.Pages
local currentPage = pages.Home
local guiDe = true



-- << LOCAL FUNCTIONS >>
local function displayHomeArrowIcons(status)
	for a,b in pairs(mainFrame.Pages.Home:GetChildren()) do
		if b:FindFirstChild("Arrow") then
			b.Arrow.Visible = status
		end
	end
end

local function updateDragBar()
	if currentPage.Name == "Home" then
		mainFrame.DragBar.Title.Text = "HD ADMIN"
		mainFrame.DragBar.Back.Visible = false
		mainFrame.DragBar.Title.Position = UDim2.new(0.04, 0, 0.15, 0)
		displayHomeArrowIcons(true)
	else
		mainFrame.DragBar.Title.Text = string.upper(currentPage.Name)
		mainFrame.DragBar.Back.Visible = true
		mainFrame.DragBar.Title.Position = UDim2.new(0.15, 0, 0.15, 0)
		displayHomeArrowIcons(false)
	end
end

local function tweenPages(tweenOutPosition, tweenInPage, instantTween)
	local tweenTime
	if instantTween then
		tweenTime = 0
	else
		tweenTime = 0.3
	end
	local tweenInfoSlide = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad)
	local oldPage = currentPage
	local tweenOut =  main.tweenService:Create(currentPage, tweenInfoSlide, {Position = tweenOutPosition})
	local tweenIn = main.tweenService:Create(tweenInPage, tweenInfoSlide, {Position = UDim2.new(0, 0, 0, 0)})
	if tweenInPage.Name == "Home" then
		tweenInPage.Position = UDim2.new(-1,0,0,0)
	else
		tweenInPage.Position = UDim2.new(1,0,0,0)
		if tweenInPage.Name == "Admin" then
			spawn(function() modules.PageAdmin:UpdatePages() end)
		end
	end
	tweenInPage.Visible = true
	tweenOut:Play()
	tweenIn:Play()
	currentPage = tweenInPage
	updateDragBar()
	tweenIn.Completed:Wait()
	oldPage.Visible = false
end


-- << SETUP >>
mainFrame.Visible = false

--Hover and select home buttons
local hovering = nil
for a,b in pairs(pages.Home:GetChildren()) do
	if b:IsA("TextButton") then
		local fade = b.Fade
		local function pressButton()
			if guiDe then
				guiDe = false
				local pageIn = pages:FindFirstChild(b.Name)
				if pageIn then
					tweenPages(UDim2.new(-1,0,0,0), pageIn)
				end
				guiDe = true
			end
		end
		if main.device == "Mobile" then
			b.MouseButton1Up:Connect(function()
				pressButton()
			end)
		else
			b.MouseButton1Down:Connect(function()
				pressButton()
			end)
		end
		b.InputBegan:Connect(function(input)
			if not b.RankBlocker.Visible then
				main.tweenService:Create(fade, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
			end
		end)
		b.InputEnded:Connect(function(input)
			main.tweenService:Create(fade, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
		end)
	end
end

-- Navigate SubPages (using NavigateButtons)
local function navigateNewPage(page, oldPos, newPos, direction, instantTween)
	local tweenTime
	if instantTween then
		tweenTime = 0
	else
		tweenTime = 0.3
	end
	local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local subPageNames = subPageOrders[page.Name]
	local pageOut
	if tonumber(oldPos) then
		pageOut = page[subPageNames[oldPos]]
	end
	local pageIn = page[subPageNames[newPos]]
	local startX
	if pageOut and pageOut:IsA("ScrollingFrame") then
		pageOut.ScrollBarImageTransparency = 1
	end
	if pageIn:IsA("ScrollingFrame") then
		pageIn.ScrollBarImageTransparency = 0
	end
	local searchBar = page:FindFirstChild("SearchBar")
	if searchBar then
		if pageIn.Size.Y.Scale < 0.85 then
			searchBar.Visible = true
		else
			searchBar.Visible = false
		end
	end
	--
	for i,v in pairs(subPageNames) do
		local subPage = page[v]
		if subPage ~= pageIn and subPage ~= pageOut then
			subPage.Position = UDim2.new(-2,0,subPage.Position.Y.Scale,0)
		end
	end
	--
	if direction == "Right" then
		startX = 1
	elseif direction == "Left" then
		startX = -1
	end
	local endX = startX*-1
	page.NavigateButtons.TextLabel.Text = string.upper(pageIn.Name)
	pageIn.Position = UDim2.new(startX, 0, pageIn.Position.Y.Scale, pageIn.Position.Y.Offset)
	local tweenIn = main.tweenService:Create(pageIn, tweenInfo, {Position = UDim2.new(0,0,pageIn.Position.Y.Scale,0)})
	tweenIn:Play()
	if pageOut then
		local tweenOut = main.tweenService:Create(pageOut, tweenInfo, {Position = UDim2.new(endX,0,pageOut.Position.Y.Scale,0)})
		tweenOut:Play()
		spawn(function()
			tweenOut.Completed:Wait()
			if pageOut.Position.X.Scale == endX then
				pageOut.Position = UDim2.new(-2,0,pageOut.Position.Y.Scale,0)
			end
		end)
	end
end
for a,b in pairs(pages:GetChildren()) do
	if b:FindFirstChild("NavigateButtons") then
		local pos = 1
		local pageX = 0
		local subPages = subPageOrders[b.Name]
		for i,v in pairs(subPages) do
			local subPage = b[v]
			if i == 1 then
				b.NavigateButtons.TextLabel.Text = string.upper(v)
			else
				pageX = 1
			end
			subPage.Position = UDim2.new(pageX,0,subPage.Position.Y.Scale,0)
			subPage.Visible = true
		end
		for c,d in pairs(b.NavigateButtons:GetChildren()) do
			if d:IsA("TextButton") then
				d.MouseButton1Down:Connect(function()
					local oldPos = pos
					if d.Name == "Right" then
						pos = pos + 1
						if pos > #subPages then
							pos = 1
						end
					elseif d.Name == "Left" then
						pos = pos - 1
						if pos < 1 then
							pos = #subPages
						end
					end
					navigateNewPage(b, oldPos, pos, d.Name)
				end)
			end
		end
	end
end

for a,b in pairs(mainFrame.DragBar:GetChildren()) do
	if b:IsA("TextButton") then
		b.MouseButton1Down:Connect(function()
			if guiDe then
				guiDe = false
				if b.Name == "Minimise" then
					if b.TextLabel.Text == "-" then
						main.tweenService:Create(pages, TweenInfo.new(0.5), {Position = UDim2.new(0,0,-0.8,0)}):Play()
						b.TextLabel.Text = "+"
					else
						pages.Parent.Visible = true
						main.tweenService:Create(pages, TweenInfo.new(0.5), {Position = UDim2.new(0,0,0.1,0)}):Play()
						b.TextLabel.Text = "-"
					end
				elseif b.Name == "Close" then
					module:CloseMainFrame()
				elseif b.Name == "Back" then
					tweenPages(UDim2.new(1,0,0,0), pages.Home)
				end
				guiDe = true
			end
		end)
	end
end
		


-- << FUNCTIONS >>
--Open MainFrame
function module:OpenMainFrame()
	TopBarFrame.ImageButton.ImageColor3 = Color3.fromRGB(0,162,255)
	TopBarFrame.ImageButton.Image = "rbxassetid://2309051372"
	mainFrame.Visible = true
end
		
--Close MainFrame
function module:CloseMainFrame()
	TopBarFrame.ImageButton.Image = "rbxassetid://2309045130"
	TopBarFrame.ImageButton.ImageColor3 = Color3.fromRGB(255,255,255)
	mainFrame.Visible = false
end
module:CloseMainFrame()
updateDragBar()

--Show a specific page
function module:ShowSpecificPage(pageName, subPageName)
	for a,b in pairs(pages:GetChildren()) do
		if b.Name == pageName then
			if currentPage == b then
				b.Visible = true
			else
				tweenPages(UDim2.new(-1,0,0,0), b, true)
			end
			local subPages = subPageOrders[b.Name]
			if subPages then
				local oldPos
				local newPos
				for i,v in pairs(subPages) do
					local subPage = b[v]
					if subPage.Name == subPageName then
						newPos = i
					elseif subPage.Position.X.Scale == 0 then
						oldPos = i
					end
				end
				--
				if oldPos == nil then
					for i = 1, #subPages do
						if i ~= newPos then
							oldPos = i
						end
					end
				end
				--
				if pageName == "Admin" and currentPage.Name == "Admin" then
					spawn(function() modules.PageAdmin:UpdatePages() end)
				end
				module:OpenMainFrame()
				if b:FindFirstChild("NavigateButtons") then
					navigateNewPage(b, oldPos, newPos, "Left", true)
				end
			end
		else
			b.Visible = false	
		end
	end
end
module:ShowSpecificPage("Home")



-- << WARNINGS >>
--CloseX
local function showLoading(warningFrame, status)
	if status then
		warningFrame.LoadingButton.Visible = true
		warningFrame.MainButton.Visible = false
	else
		warningFrame.LoadingButton.Visible = false
		warningFrame.MainButton.Visible = true
	end
end
for _, warningFrame in pairs(main.warnings:GetChildren()) do
	warningFrame.CloseX.MouseButton1Down:Connect(function()
		main.warnings.Visible = false
	end)
	local button = warningFrame:FindFirstChild("MainButton")
	if button then
		local buttonDe = true
		button.MouseButton1Down:Connect(function()
			if buttonDe then
				buttonDe = false
				if warningFrame.Name == "BuyFrame" then
					local productId = button.ProductId.Value
					local productType = button.ProductType.Value
					if productType == "Gamepass" then
						main.marketplaceService:PromptGamePassPurchase(main.player, productId)
					else
						main.marketplaceService:PromptPurchase(main.player, productId)
					end
				elseif warningFrame.Name == "UnBan" then
					showLoading(warningFrame, true)
					main.signals.RequestCommand:InvokeServer(main.pdata.Prefix.."undirectban "..warningFrame.PlrName.Text)
					modules.PageAdmin:CreateBanland()
					showLoading(warningFrame, false)
					main.warnings.Visible = false
				elseif warningFrame.Name == "PermRank" then
					showLoading(warningFrame, true)
					local userName = warningFrame.PlrName.Text
					local id = modules.cf:GetUserId(userName)
					main.signals.RemovePermRank:InvokeServer{id, userName}
					modules.PageAdmin:CreateRanks()
					showLoading(warningFrame, false)
					main.warnings.Visible = false
				elseif warningFrame.Name == "Teleport" then
					showLoading(warningFrame, true)
					local placeId = warningFrame.MainButton.PlaceId.Value
					main.teleportService:Teleport(placeId)
					main.teleportService.TeleportInitFailed:Wait()
					showLoading(warningFrame, false)
				end
				buttonDe = true
			end
		end)
	end
end
main.warnings.Visible = false



-- << DISPLAY CERTAIN PAGES >>
local homeSortOrder = {"About", "Commands", "Special", "Admin", "Settings"}
function module:DisplayPagesAccordingToRank(updateCommands)
	for pageName, rankId in pairs(main.settings.RankRequiredToViewPage) do
		local pageButton = pages.Home:FindFirstChild(pageName)
		rankId = tonumber(rankId)
		if not rankId then
			rankId = 0
		end
		if pageButton and pageName ~= "About" and pageName ~= "Special" and main.pdata.Rank < rankId then
			pageButton.RankBlocker.Visible = true
			local rankName = modules.cf:GetRankName(rankId)
			pageButton.RankBlocker.TextLabel.Text = rankName.."+"
		else
			pageButton.RankBlocker.Visible = false
		end
	end
	--[[
	local yScaleTotal = 0.08
	for i, pageName in pairs(homeSortOrder) do
		local pageButton = pages.Home:FindFirstChild(pageName)
		if pageButton and pageButton.Visible then
			pageButton.Position = UDim2.new(0, 0, yScaleTotal, 0)
			yScaleTotal = yScaleTotal + pageButton.Size.Y.Scale
		end
	end--]]
end




-- << HIDE MENU TEMPLATES >>
local menuTemplates = main.gui.MenuTemplates
for a,b in pairs(menuTemplates:GetChildren()) do
	if b:IsA("Frame") then
		b.Visible = false
	end
end




return module
