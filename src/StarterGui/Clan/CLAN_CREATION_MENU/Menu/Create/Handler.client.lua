local REPLICATED_STORAGE = game:GetService("ReplicatedStorage")

local EVENTS = REPLICATED_STORAGE:WaitForChild("Events",math.huge)
local CLAN_EVENTS = EVENTS:WaitForChild("ClanEvents")

local ClanTextBox = script.Parent.Parent:WaitForChild("ClanName",math.huge)

local ev_makeclan = CLAN_EVENTS:WaitForChild("MakeClan",math.huge)

script.Parent.MouseButton1Down:Connect(function()
	local a = ev_makeclan:InvokeServer({ClanTextBox.Text})
	if a == true then
		script.Parent.Parent.Parent.Visible = false
	end
end)