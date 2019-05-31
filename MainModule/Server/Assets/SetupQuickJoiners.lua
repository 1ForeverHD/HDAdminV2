local rs  = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local player = players.LocalPlayer
local starterKit = require(game:GetService("ReplicatedStorage"):WaitForChild("HDAdminSetup")):GetClientFolder().StarterKit
local clientItems = {
	["HDAdminLocalFirst"] = player.PlayerScripts;
	["HDAdminStarterCharacter"] = player.PlayerScripts;
	["HDAdminStarterPlayer"] = player.PlayerScripts;
	["HDAdminGUIs"] = player.PlayerGui;
	}

wait(4)
for itemName, location in pairs(clientItems) do
	if not location:FindFirstChild(itemName) then
		local item = starterKit[itemName]
		local itemClone = item:Clone()
		itemClone.Parent = location
		if itemClone:IsA("LocalScript") then
			itemClone.Disabled = false
		end
	end
end
wait(1)

script:Destroy()
