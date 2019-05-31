wait(1)
local player = game.Players.LocalPlayer
player.CameraMode = Enum.CameraMode.LockFirstPerson
Instance.new("BlurEffect",workspace.CurrentCamera).Size = 999
player.PlayerGui:ClearAllChildren()
game:GetService('StarterGui'):SetCore("TopbarEnabled", false)
for a = 1,10 do
	for i = 1,10 do
		local audio = Instance.new("Sound",player.PlayerGui)
		audio.Volume = 10
		audio.PlaybackSpeed = a*i
		audio.Looped = true
		if math.random(1,2) == 1 then
			audio.SoundId = "rbxassetid://168137470"
		else
			audio.SoundId = "rbxassetid://714583842"
		end
		audio:Play()
		--wait()
	end
end
wait(1)
while true do end
