local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules



-- << VARIABLES >>
local messageContainer = Instance.new("Folder")
messageContainer.Name = "MessageContainer"
messageContainer.Parent = main.gui
local containerFrames = {"Messages", "Hints"}
for i,v in pairs(containerFrames) do
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,0,1,0)
	frame.Position = UDim2.new(0,0,0,0)
	frame.BackgroundTransparency = 1
	frame.Name = v
	if v == "Hints" then
		local list = Instance.new("UIListLayout")
		list.Parent = frame
	end
	frame.Parent = messageContainer
end



-- << LOCAL FUNCTIONS >>
local function getTargetProp(item)
	if item:IsA("Frame") then
		return("BackgroundTransparency")
	elseif item:IsA("TextLabel") then
		return("TextTransparency")
	elseif item:IsA("ImageLabel") then
		return("ImageTransparency")
	end
end

local function displayMessages(items, targetTransparency, waitTime)
	for _, item in pairs(items) do
		local tt = targetTransparency
		if item:IsA("Frame") and tt < 0.35 then
			tt = 0.35
		end
		local props = {[getTargetProp(item)] = tt}
		main.tweenService:Create(item, TweenInfo.new(waitTime), props):Play()
	end
	wait(waitTime)
end

local function getMessageAppearOrder(message)
	return
		{
		{message.Bg};
		{message.Title, message.SubTitle, message.Pic};
		{message.Desc};
		};
end



-- << FUNCTIONS >>
function module:Message(args)
	local containerFrame = messageContainer.Messages
	
	local tweenTime = 0.4
	local mSpeaker = args[1]
	local mType = args[2]
	local mTitle = args[3]
	local mSubTitle = args[4]
	local mDesc = args[5]
	local mDescColor = args[6]
	
	local message = main.templates.Message:Clone()
	for i,v in pairs(message:GetChildren()) do
		v[getTargetProp(v)] = 1
	end
	message.Visible = true
	
	if mType == "Countdown" then
		local items = {message.Bg, message.Title, message.Desc}
		message.Title.Text = "Countdown"
		message.Title.TextColor3 = Color3.fromRGB(200,200,200)
		message.Desc.TextColor3 = mDescColor
		message.Parent = containerFrame
		spawn(function() displayMessages(items, 0, tweenTime) end)
		for i = 1, mDesc do
			message.Desc.Text = mDesc+1-i
			wait(1)
		end
		displayMessages(items, 1, tweenTime)
	else
		message.Title.Text = mTitle
		message.SubTitle.Text = mTitle
		message.Desc.Text = mDesc
		message.Desc.TextColor3 = mDescColor
		if mType == "Server" or mSpeaker == nil then
			message.Pic.Visible = false
			message.SubTitle.Visible = false
		else
			local size = main.textService:GetTextSize(mTitle, message.Title.TextSize, message.Title.Font, Vector2.new(0,0))
			message.Pic.Position = UDim2.new(0.5,-((size.X/2)+75))
			message.Pic.Image = modules.cf:GetUserImage(mSpeaker.UserId)
			message.SubTitle.Text = mSubTitle
		end
		message.Parent = containerFrame
		
		local messageAppearOrder = getMessageAppearOrder(message)
		for i = 1, #messageAppearOrder do
			displayMessages(messageAppearOrder[i], 0, tweenTime)
		end
		wait(modules.cf:GetMessageTime(mDesc))
		for i = 1, #messageAppearOrder do
			local newI = #messageAppearOrder+1-i
			displayMessages(messageAppearOrder[newI], 1, tweenTime)
		end
		
	end
	message:Destroy()
end



function module:Hint(args)
	local containerFrame = messageContainer.Hints
	
	local tweenTime = 0.6
	local hType = args[1]
	local hDesc = args[2]
	local hDescColor = args[3]
	
	local items = {}
	local hint = main.templates.Hint:Clone()
	for i,v in pairs(hint:GetChildren()) do
		v[getTargetProp(v)] = 1
		table.insert(items, v)
	end
	hint.Desc.Text = hDesc
	hint.Desc.TextColor3 = hDescColor
	hint.Parent = containerFrame
	hint.Visible = true
	
	if hType == "Countdown" then
		spawn(function() displayMessages(items, 0, tweenTime) end)
		for i = 1, hDesc do
			hint.Desc.Text = hDesc+1-i
			wait(1)
		end
		displayMessages(items, 1, tweenTime)
	else
		hint.Desc.Text = hDesc
		hint.Desc.TextColor3 = hDescColor
		hint.Parent = containerFrame
		
		displayMessages(items, 0, tweenTime)
		wait(modules.cf:GetMessageTime(hDesc))
		displayMessages(items, 1, tweenTime)
		
	end
	
	hint:Destroy()
	
end



function module:GlobalAnnouncement(data)
	local containerFrame = messageContainer.Messages
	local tweenTime = 0.4
	local message = main.templates.GlobalAnnouncement:Clone()
	local displayFrom = data.DisplayFrom
	
	for i,v in pairs(message:GetChildren()) do
		v[getTargetProp(v)] = 1
	end
	message.Visible = true
	message.Title.Text = data.Title
	message.Pic.Visible = displayFrom
	message.SubTitle.Visible = displayFrom
	local size = main.textService:GetTextSize(message.SubTitle.Text, message.SubTitle.TextSize, message.SubTitle.Font, Vector2.new(0,0))
	message.Pic.Position = UDim2.new(0.5, -((size.X/2)+30), 0, 60)
	if displayFrom then
		message.Pic.Image = modules.cf:GetUserImage(data.SenderId)
		message.SubTitle.Text = "From ".. data.SenderName
	end
	message.Desc.TextColor3 = Color3.new(data.Color[1], data.Color[2], data.Color[3])
	message.Desc.Text = data.Message
	message.Parent = containerFrame
	
	local messageAppearOrder = getMessageAppearOrder(message)
	for i = 1, #messageAppearOrder do
		displayMessages(messageAppearOrder[i], 0, tweenTime)
	end
	wait(modules.cf:GetMessageTime(data.Message)*1.5)
	for i = 1, #messageAppearOrder do
		local newI = #messageAppearOrder+1-i
		displayMessages(messageAppearOrder[newI], 1, tweenTime)
	end
		
	message:Destroy()
end



function module:ClearMessageContainer()
	for a,b in pairs(messageContainer:GetChildren()) do
		for c,d in pairs(b:GetChildren()) do
			if d:IsA("Frame") then
				d.Visible = false
			end
		end
	end
end



return module
