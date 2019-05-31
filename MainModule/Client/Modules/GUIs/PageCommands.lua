local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules


-- << VARIABLES >>
local frame = main.gui.MainFrame.Pages.Commands
local pages = {
	commands = frame.Commands;
	morphs = frame.Morphs;
	details = frame.Details;
}
local templateC1 = pages.commands.TemplateOne
local templateC2 = pages.commands.TemplateTwo
local templateM = pages.morphs.Template
local infoOrder = {"Aliases", "Undo", "Desc", "Rank", "Loop", "Tags", "Credit"}
local infoMatch = {"Aliases", "UnFunction", "Description", "Rank", "Loopable", "Tags", "Contributors"}



-- << SETUP SEARCH BAR >>
local searchDe = true
frame.SearchBar.Frame.TextBox.FocusLost:connect(function(property)
	if searchDe then
		searchDe = false
		local page
		for i,v in pairs(pages) do
			if v.Position.X.Scale == 0 then
				page = v
			end
		end
	    if page then
			local functionName = "Create".. page.Name
			module[functionName]()
	    end
		wait(0.5)
		searchDe = true
	end
end)



-- << COMMANDS >>
--Create command labels
local creatingCommands = false
function module:SetupCommands(commands, page, totalLabels)
	for i, command in pairs(commands) do
		local commandNameLower = string.lower(command.Name)
		totalLabels = totalLabels + 1
		local labelId 
		if page.Name == "Donor" then
			labelId = "AE Command"..totalLabels
		else
			labelId = modules.cf:GenerateTagFromId(totalLabels)
		end
		local label = templateC1:Clone()
		label.BackgroundColor3 = modules.cf:GetLabelBackgroundColor(i)
		label.TextLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
		local UP = false
		if command.Prefixes[1] == main.settings.UniversalPrefix then
			UP = true
			label.TextLabel.Text = main.settings.UniversalPrefix..command.Name
		else
			label.TextLabel.Text = main.pdata.Prefix..command.Name
		end
		-------------
		spawn(function()
			wait(0.1)
			local boundX = label.TextLabel.TextBounds.X
			if command.SpecialColor then
				label.TextLabel.Text = command.OriginalName
				spawn(function()
					wait(0.1)
					local newBoundX = label.TextLabel.TextBounds.X
					local colorLabel = label.TextLabel:Clone()
					colorLabel.ZIndex = colorLabel.ZIndex + 2
					colorLabel.Position = label.TextLabel.Position + UDim2.new(0, newBoundX, 0, 0)
					colorLabel.TextColor3 = command.SpecialColor
					colorLabel.Name = "ColorLabel"
					colorLabel.Text = command.SpecialColorName
					colorLabel.Parent = label
				end)
			end
			local newDetail = {}
			local detaialsLabel = label.TextLabel:Clone()
			detaialsLabel.Position = label.TextLabel.Position + UDim2.new(0, boundX+5, 0, 0)
			detaialsLabel.TextColor3 = Color3.fromRGB(175, 175, 175)
			detaialsLabel.Name = "DetailsLabel"
			for i,v in pairs(command.Args) do
				if (not UP or v ~= "player") and v ~= "details" then
					if v == "playerarg" then
						v = "player"
					end
					table.insert(newDetail, "<"..v..">")
				end
			end
			detaialsLabel.Text = table.concat(newDetail, "  ")
			detaialsLabel.Parent = label
		end)
		------------
		label.Name = labelId
		label.Arrow.Text = "►"
		label.Visible = true
		local info = {}
		local button = Instance.new("TextButton")
		button.BackgroundTransparency = 1
		button.ZIndex = label.ZIndex + 5
		button.Size = UDim2.new(1,0,1,0)
		button.Text = ""
		--
		local function pressButton()
			if #info > 0 then
				page.CanvasSize = page.CanvasSize - UDim2.new(0,0,0,#info*templateC2.AbsoluteSize.Y)
				for i,v in pairs(info) do
					v:Destroy()
				end
				info = {}
			end
			if label.Arrow.Text == "►" then
				label.Arrow.Text = "▼"
				local amount = 0
				for i,v in pairs(infoOrder) do
					local detail = command[infoMatch[i]]
					if detail and ((type(detail) ~= "table" and type(detail) ~= "string") or #detail > 0) then
						amount = amount + 1
						local infoPart = templateC2:Clone()
						infoPart.Name = labelId.." Info"..main.alphabet[amount]
						infoPart.Title.Text = v..":"
						if amount%2 == 0 then
							infoPart.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
						else
							infoPart.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
						end
						local infoTextLabel = infoPart.TextLabel
						infoPart.Parent = page
						--------------------------------------------------
						local prefix = main.pdata.Prefix
						if UP then
							prefix = main.settings.UniversalPrefix
						end
						if v == "Loop" then
							if detail == true then
								infoTextLabel.Text = "Yes"
							else
								infoTextLabel.Text = "No"
							end
						elseif v == "Undo" then
							infoTextLabel.Text = prefix..command.UnFunction
						elseif v == "Alias" then
							local newDetail = {}
							for i,v in pairs(detail) do
								table.insert(newDetail, prefix..v)
							end
							infoTextLabel.Text = table.concat(newDetail, " | ")
						elseif type(detail) == "table" then
							infoTextLabel.Text = table.concat(detail, ", ")
						elseif v == "Rank" then
							if command.RankName == "Donor" then
								infoTextLabel.Text = command.Rank
							else
								infoTextLabel.Text = command.Rank.." (".. command.RankName .. ")"
							end
						else
							infoTextLabel.Text = detail
							if v == "Desc" then
								local titleSize = infoPart.Title.AbsoluteSize
								local infoSize = infoPart.AbsoluteSize
								local newY = (infoPart.Title.AbsolutePosition.Y - infoPart.AbsolutePosition.Y)/2
								local absoluteSize = infoTextLabel.AbsoluteSize
								local fontSize = absoluteSize.Y
								local textFont = infoTextLabel.Font
								local bounds = Vector2.new(absoluteSize.X, absoluteSize.Y*100)
								local textSize = main.textService:GetTextSize(detail, fontSize, textFont, bounds)
								infoPart.UIAspectRatioConstraint:Destroy()
								infoTextLabel.Size = UDim2.new(0, textSize.X, 0, textSize.Y)
								infoPart.Title.Size = UDim2.new(0, titleSize.X, 0, titleSize.Y)
								infoPart.Size = UDim2.new(0, infoSize.X, 0, infoSize.Y + (textSize.Y - math.ceil(absoluteSize.Y)))
								infoPart.Title.Position = UDim2.new(infoPart.Title.Position.X.Scale, 0, 0, newY)
								infoPart.TextLabel.Position = UDim2.new(infoPart.TextLabel.Position.X.Scale, 0, 0, newY)
							end
						end
						--------------------------------------------------
						infoPart.Visible = true
						table.insert(info, infoPart)
					end
				end
				local increase = #info*templateC2.AbsoluteSize.Y
				page.CanvasSize = page.CanvasSize + UDim2.new(0,0,0,increase)
				if label.AbsolutePosition.Y > page.AbsolutePosition.Y + page.AbsoluteSize.Y - increase/1.5 then
					page.CanvasPosition = page.CanvasPosition + Vector2.new(0,increase)
				end
			else
				label.Arrow.Text = "►"
			end
		end
		if main.device == "Mobile" then
			button.MouseButton1Click:Connect(function()
				pressButton()
			end)
		else
			button.MouseButton1Down:Connect(function()
				pressButton()
			end)
		end
		--
		button.Parent = label
		label.Parent = page
	end
	return totalLabels
end
			
function module:CreateCommands()
	if not creatingCommands then
		creatingCommands = true
		
		modules.cf:ClearPage(pages.commands)
		
		--Organise commands
		local rankPositions = {}
		local ranks = {}
		local totalLabels = 0
		local searchText = frame.SearchBar.Frame.TextBox.Text
		for i, rankDetails in pairs(main.settings.Ranks) do
			local rankId = rankDetails[1]
			local rankName = rankDetails[2]
			table.insert(ranks, {rankId, rankName, {}})
			rankPositions[rankName] = i
		end
		for _, command in pairs(main.commandInfo) do
			local cName = string.lower(command.Name)
			if command.RankName ~= "Donor" then
				--
				local aliasMatch = false
				if #searchText > 0 then
					for i,alias in pairs(command.Aliases) do
						if string.lower(string.sub(searchText, 1, #alias)) == alias then
							aliasMatch = true
							break
						end
					end
				end
				--
				if string.match(cName, searchText) or aliasMatch then
					local groupPos = rankPositions[command.RankName]
					if not groupPos then
						local missingRankId = command.Rank
						for i, rankDetails in pairs(main.settings.Ranks) do
							local rankId = rankDetails[1]
							local rankName = rankDetails[2]
							if rankId > missingRankId then
								groupPos = rankPositions[rankName]
								break
							end
						end
					end
					if groupPos then
						table.insert(ranks[groupPos][3], command)
					end
				end
			end
		end
				
		for _, rankGroupDetails in pairs(ranks) do
			local rankId = rankGroupDetails[1]
			local rankName = rankGroupDetails[2]
			local commands = rankGroupDetails[3]
			if #commands > 0 and (not main.settings.OnlyShowUsableCommands or main.pdata.Rank >= rankId) then
				local rankLabel = templateC1:Clone()
				rankLabel.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
				rankLabel.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				if rankId == 5 then
					rankLabel.TextLabel.Text = rankName
				else
					rankLabel.TextLabel.Text = rankName.." +"
				end
				totalLabels = totalLabels + 1
				rankLabel.Name = modules.cf:GenerateTagFromId(totalLabels)
				rankLabel.TextLabel.Position = rankLabel.Arrow.Position
				rankLabel.Arrow:Destroy()
				rankLabel.Visible = true
				rankLabel.Parent = pages.commands
				------------------------------------------------------------------------------
				totalLabels = module:SetupCommands(commands, pages.commands, totalLabels)
				------------------------------------------------------------------------------
			end
		end
		
		--Canvas size
		pages.commands.CanvasSize = UDim2.new(0,0,0,totalLabels*templateC1.AbsoluteSize.Y)
		
		coroutine.wrap(function()
			wait(0.5)
			creatingCommands = false
		end)()
	end
end



-- << MORPHS >>
function module:CreateMorphs()
	modules.cf:ClearPage(pages.morphs)
	
	--Organise morphs
	local morphsList = {}
	local searchText = frame.SearchBar.Frame.TextBox.Text
	for morphName,_ in pairs(main.morphNames) do
		local cName = string.lower(morphName)
		if string.match(cName, searchText) then
			table.insert(morphsList, morphName)
		end
	end
	table.sort(morphsList)
	table.insert(morphsList, 1, main.pdata.Prefix.. "morph <player> <morphName>")
				
	--Create morph labels
	for i,morphName in pairs(morphsList) do
		local label = templateM:Clone()
		if i == 1 then
			label.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
			label.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			label.BackgroundColor3 = modules.cf:GetLabelBackgroundColor(i)
			label.TextLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
		end
		label.TextLabel.Text = morphName
		label.Name = morphName
		label.Visible = true
		label.Parent = pages.morphs
	end
	
	--Canvas size
	pages.morphs.CanvasSize = UDim2.new(0,0,0,#morphsList*templateM.AbsoluteSize.Y)
end




-- << DETAILS >>
local details = {
	
	{
	{0, "Colors"};
	};
	
	{
	{0, "Qualifiers (select certain players)"};
	{"Me"};
	{"All"};
	{"Random"};
	{"Admins/NonAdmins"};
	{"Friends/NonFriends"};
	{"NBC/BC/TBC/OBC"};
	{"R6/R15"};
	{"Rthro/NonRthro"};
	{"@(RankName)"};
	{"%(TeamName)"};
	};
	
	{
	{0, "Shortcuts"};
	{"' (Quote) to toggle cmdbar (computer)"};
	{"; (Semicolon) to toggle cmdbar2 (computer)"};
	--{"Double-jump to toggle flight (m & c)"};
	};
	
	{
	{0, "Tips"};
	{"/e for silent commands   (/e ;jump me)"};
	{"Batch commands   (;jump me ;kill me)"};
	{"Select multiple players   (;jump me,bc,r15)"};
	{"Shorten names   (;jump ForeverHD = ;jump for)"};
	{"Cases do not matter   (;jUmP mE = ;jump me)"};
	};
	
}
local colorId
for i,v in pairs(details) do
	if v[1][1] == 0 and v[1][2] == "Colors" then
		colorId = i
	end
end
for i, colorInfo in pairs(main.settings.Colors) do
	local shortName = colorInfo[1]
	local fullName = colorInfo[2]
	local tag = {fullName.." ("..shortName..")"}
	table.insert(details[colorId], tag)
	table.insert(main.colors, fullName)
end

function module:CreateDetails()
	modules.cf:ClearPage(pages.details)
	
	--Create labels
	local totalLabels = 0
	for _, detailGroup in pairs(details) do
		for i,v in pairs(detailGroup) do
			local label = templateM:Clone()
			if i == 1 then
				label.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
				label.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				label.TextLabel.Text = v[2]
			else
				label.BackgroundColor3 = modules.cf:GetLabelBackgroundColor(i)
				label.TextLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
				label.TextLabel.Text = v[1]
			end
			label.Visible = true
			label.Parent = pages.details
			totalLabels = totalLabels + 1
		end
	end
	
	--Canvas size
	pages.details.CanvasSize = UDim2.new(0,0,0,totalLabels*templateM.AbsoluteSize.Y)
end
	



return module
