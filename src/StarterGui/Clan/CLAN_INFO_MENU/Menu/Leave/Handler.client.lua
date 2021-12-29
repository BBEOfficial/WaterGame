local REPLICATED_STORAGE = game:GetService("ReplicatedStorage")

local EVENTS = REPLICATED_STORAGE:WaitForChild("Events",math.huge)
local CLAN_EVENTS = EVENTS:WaitForChild("ClanEvents")

local ClanTextBox = script.Parent.Parent:WaitForChild("ClanName",math.huge)

local ev_leaveclan = CLAN_EVENTS:WaitForChild("LeaveClan",math.huge)
local debounce = false

script.Parent.MouseButton1Down:Connect(function()
	if debounce == false then
		debounce = true
		ev_leaveclan:FireServer()
		wait(5)
		debounce = false
	end
end)