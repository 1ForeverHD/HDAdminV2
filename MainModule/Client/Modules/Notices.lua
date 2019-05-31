local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules



-- << VARIABLES >>
local notices = main.gui.Notices
local template = notices.Template
local XOffset = 0
local noticeDe = true
local noticeQueue = {}
local currentNotices = {}
local inverted = false
local maxNotices = 4
local maxTime = 7
local waitTime = 0.5
local tweenInfoUp = TweenInfo.new(waitTime,Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfoDown = TweenInfo.new(waitTime*1.25,Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfoEnd = TweenInfo.new(waitTime*1.25,Enum.EasingStyle.Back, Enum.EasingDirection.In)


-- << SETUP >>
if main.device ~= "Mobile" then
	local newY = 90
	template.Position = UDim2.new(1, 0, 1, -newY)
	template.Size = UDim2.new(0, 2.73*newY, 0, newY)
	template.Desc.UITextSizeConstraint.MaxTextSize = 17 + (newY-77)*0.25
end


-- << LOCAL FUNCTIONS >>
local function updateNotices(newNotice)
	for i,notice in pairs(currentNotices) do
		if not notice.Complete.Value then
			local tweenInfo = tweenInfoUp
			local destination
			if i == 1 then
				destination = template.Position + UDim2.new(0,-notice.Size.X.Offset,0,0)
			else
				local noticeBefore = currentNotices[i-1]
				destination = UDim2.new(notice.Position.X.Scale, notice.Position.X.Offset, notice.Position.Y.Scale, template.Position.Y.Offset-((i-1)*(template.Size.Y.Offset+5)))
			end
			if destination.Y.Offset > notice.Position.Y.Offset then
				tweenInfo = tweenInfoDown
			end
			if destination then
				main.tweenService:Create(notice, tweenInfo, {Position = destination}):Play()
			end
		end
	end
end

local function endNotice(notice)
	if notice:FindFirstChild("Complete") and not notice.Complete.Value then
		notice.Complete.Value = true
		for i,v in pairs(currentNotices) do
			if v == notice then
				table.remove(currentNotices, i)
				local tween = main.tweenService:Create(notice, tweenInfoEnd, {Position = notice.Position + UDim2.new(0,(notice.Size.X.Offset-XOffset),0,0)})
				tween:Play()
				tween.Completed:Wait()
				notice:Destroy()
			end
		end
	end
	updateNotices()
end

local function Queue()
	if noticeDe then
		noticeDe = false
		repeat wait()
			if #noticeQueue > 0 then
				local notice = noticeQueue[1]
				notice.Parent = notices
				if notice.NoticeType.Value == "Error" then
					main.audio.Error:Play()
				else
					main.audio.Notice:Play()
				end
				table.insert(currentNotices, 1, notice)
				--
				if notice.Countdown.Value < 900 then
					spawn(function()
						if notice.Countdown.Value > 0 then
							local alignTime = os.time()
							repeat wait() until os.time() ~= alignTime
							local originalDesc = notice.Desc.Text
							for i = 1, notice.Countdown.Value do
								if not notice:FindFirstChild("Desc") or notice.Desc.Text == "Teleporting..." then
									break
								end
								notice.Desc.Text = originalDesc.." ("..notice.Countdown.Value+1-i..")"
								wait(1)
							end
						else
							local startTick = tick()
							repeat wait(0.1) until tick() - startTick >= maxTime
						end
						endNotice(notice)
					end)
				end
				--
				updateNotices(true)
				--
				wait(waitTime)
				table.remove(noticeQueue,1)
			end
		until #noticeQueue < 1
		noticeDe = true
	end
end


-- << FUNCTIONS >>
function module:Notice(noticeType, title, description, args)
	if not main.pdata or not main.pdata.SetupData then
		repeat wait(0.1) until (main.pdata and main.pdata.SetupData)
	end
	if main.settings.DisableAllNotices ~= true then
		spawn(function()
			local notice = template:Clone()
			notice.Visible = true
			notice.Title.Text = title
			notice.Desc.Text = description
			notice.NoticeType.Value = noticeType
			--[[spawn(function()
				wait()
				if notice.Desc.TextBounds.Y > 35 then
					notice.Desc.Position = UDim2.new(0.05, 0, 0.37, 0)
				end
			end)--]]
			if type(args) == "table" then
				local de = true
				local function checkDe()
					if de then
						de = false
						return true
					end
				end
				local clickAction = args[1]
				if clickAction == "ShowSpecificPage" then
					notice.Countdown.Value = 20
					notice.TextButton.MouseButton1Down:Connect(function()
						if not checkDe() then return end
						modules.GUIs:ShowSpecificPage(args[2], args[3])
						endNotice(notice)
					end)
				elseif clickAction == "Teleport" then
					notice.Countdown.Value = 25
					notice.TextButton.MouseButton1Down:Connect(function()
						if not checkDe() then return end
						main.teleportService:Teleport(args[2])
						notice.Desc.Text = "Teleporting..."
					end)
				elseif clickAction == "PM" then
					notice.Countdown.Value = 999
					notice.TextButton.MouseButton1Down:Connect(function()
						if not checkDe() then return end
						modules.cf:CreateNewCommandMenu("privateMessage", {args[2], args[3]}, 4)
						endNotice(notice)
					end)
				end
			end
			notice.CloseX.MouseButton1Down:Connect(function()
				endNotice(notice)
			end)
			table.insert(noticeQueue, notice)
			Queue()
		end)
	end
end


--[[spawn(function()
	while wait(5) do
		for i = 1,5 do
			module:Notice("HD Admin", "Your rank is 'Owner'! Click to view the commands.", {"ShowSpecificPage", "Commands", "Commands"})
			wait(1)
			--module:Notice("HD Admin", "You're a Donor! Click to view Donor commands." )
			--wait(1)
		end
	end
end)--]]


return module
