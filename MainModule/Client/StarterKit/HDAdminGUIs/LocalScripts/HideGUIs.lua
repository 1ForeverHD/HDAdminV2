local framesToShow = {
	Notices = true
	}
local gui = script.Parent.Parent
for a,b in pairs(gui:GetChildren()) do
	if b:IsA("Frame") then
		if framesToShow[b.Name] then
			b.Visible = true
		else
			b.Visible = false
		end
	elseif b:IsA("Folder") then
		for c,d in pairs(b:GetChildren()) do
			if d:IsA("Frame") then
				d.Visible = false
			end
		end
	end
end
