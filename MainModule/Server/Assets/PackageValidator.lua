local humanoid = script.Parent
local char = humanoid.Parent
local disableDeath = humanoid:WaitForChild("SetDeathEnabled")
local verifyJoints = humanoid:WaitForChild("VerifyJoints")

function disableDeath.OnClientInvoke(state)
	humanoid:SetStateEnabled("Dead",state)
end

function verifyJoints.OnClientInvoke()
	local passes = true
	for _,part in pairs(char:GetChildren()) do
		if part:IsA("BasePart") then
			for _,att in pairs(part:GetChildren()) do
				if att:IsA("Attachment") and att.Name:sub(-13) == "RigAttachment" then
					local motorName = att.Name:sub(1,-14)
					local motor = char:FindFirstChild(motorName,true)
					if not (motor and motor:IsA("Motor6D")) then
						passes = false
						break
					end
				end
			end
		end
	end
	return passes
end
