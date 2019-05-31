-- << RETRIEVE FRAMEWORK >>
local main = require(game:GetService("ReplicatedStorage"):WaitForChild("HDAdminSetup")):GetMain()
local modules = main.modules



-- << HUMANOID CHANGED >>
local character = main.player.Character or main.player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local jumps = 0
local jumpDe = true
if main.device ~= "Computer" then
	humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
		if jumpDe then
			jumpDe = false
			jumps = jumps + 1
			if jumps == 4 then
				coroutine.wrap(function()
					for speedCommandName, _ in pairs(main.commandSpeeds) do
						if main.commandsActive[speedCommandName] then
							modules.cf:EndCommand(speedCommandName)
						else
							modules.cf:ActivateClientCommand(speedCommandName)
						end
					end
				end)()
			end
			wait()
			jumpDe = true
			wait(0.2)
			jumps = jumps - 1
		end
	end)
end



-- << SETUP >>
wait(1)
for speedCommandName, _ in pairs(main.commandSpeeds) do
	if main.commandsActive[speedCommandName] then
		main.commandsActive[speedCommandName] = nil
		modules.cf:ActivateClientCommand(speedCommandName)
	end
end
