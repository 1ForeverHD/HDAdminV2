-- This is for commands which continue on respawn
local module = {}


-- << RETRIEVE FRAMEWORK >>
local main = _G.HDAdminMain
local modules = main.modules
local settings = main.settings



-- << SETUP ITEMS (items which continue on respawn) >>
function module:SetupItem(player, itemName, playerRespawned)
	if playerRespawned then
		wait(0.1)
	end
	local pdata = main.pd[player]
	local item = pdata.Items[itemName]
	local head = modules.cf:GetHead(player)
	if head and pdata then
		
		if itemName == "FreezeBlock" then
			modules.cf:Movement(false, player)
			modules.cf:SetTransparency(player.Character, 1)
			if item:FindFirstChild("FreezeClone") then
				main.signals.ChangeCameraSubject:FireClient(player, (item.FreezeClone.Humanoid))
			end
			
		elseif itemName == "JailCell" then
			head.CFrame = item.Union.CFrame
		
		elseif itemName == "ControlPlr" then
			local plr = item.Value
			local controllerHumanoid = modules.cf:GetHumanoid(player)
			if plr and controllerHumanoid then
				modules.MorphHandler:BecomeTargetPlayer(player, plr.UserId)
				main.signals.ChangeCameraSubject:FireClient(player, (controllerHumanoid))
				modules.cf:CreateFakeName(player, plr.Name)
			else
				modules.cf:RemoveControlPlr(player)
			end
			
		elseif itemName == "UnderControl" then
			local controller = item.Value
			local controllerHumanoid = modules.cf:GetHumanoid(controller)
			if controller and controllerHumanoid then
				main.signals.ChangeCameraSubject:FireClient(player, (controllerHumanoid))
				--modules.cf:SetTransparency(player.Character, 1, true)
				--modules.cf:Movement(false, player)
				player.Character.Parent = nil
			else
				modules.cf:RemoveUnderControl(player)
			end
			
			-- Controler
			-- Plr
			
		end
	end
end



return module
