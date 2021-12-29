local REPLICATED_STORAGE = game:GetService("ReplicatedStorage")

local EVENTS = REPLICATED_STORAGE:WaitForChild("Events",math.huge)
local CLAN_EVENTS = EVENTS:WaitForChild("ClanEvents")
local CLAN_GUI = script.Parent.Parent

local ev_isplayerinclan = CLAN_EVENTS:WaitForChild("IsPlayerInClan",math.huge)

script.Parent.MouseButton1Down:Connect(function()
	if CLAN_GUI.CLAN_CREATION_MENU.Visible == true then
		CLAN_GUI.CLAN_CREATION_MENU.Visible = false
		return
	elseif CLAN_GUI.CLAN_INFO_MENU.Visible == true then
		CLAN_GUI.CLAN_INFO_MENU.Visible = false
		return
	end
	
	local a = ev_isplayerinclan:InvokeServer()
	if a == true then
		CLAN_GUI.CLAN_INFO_MENU.Visible = true
	else
		CLAN_GUI.CLAN_CREATION_MENU.Visible = true
	end
end)