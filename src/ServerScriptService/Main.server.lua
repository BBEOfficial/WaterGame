local SSS = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local modules = {}
local events = {}

function moduleScraper(loc)
    for _,v in pairs(loc:GetDescendants()) do
        if v:IsA("ModuleScript") and v ~= script then
            modules[v.Name] = require(v)
        end
    end
end

function eventScraper(loc)
    for _,v in pairs(loc:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            events[v.Name] = v
        end
    end
end

moduleScraper(SSS)
eventScraper(ReplicatedStorage)

wait(5)

-- Data Stuff
for _,v in pairs(Players:GetPlayers()) do -- temporary until roblox fixes studio with the player joining before the code runs smh
    modules.DataInteractions.NewPlayer(v)
end

-- Players.PlayerAdded:Connect(function(plr)
--     modules.DataInteractions.NewPlayer(plr)
-- end)

Players.PlayerRemoving:Connect(function(plr)
    modules.DataInteractions.PlayerLeft(plr)
end)

-- Clan Stuff
warn("clan stuff")

function isPlayerInClan(player)
	for _,v in pairs(modules.ClanData["ListOfPlayersInAnyClan"]) do
		if v == player.UserId then
			return true
		end
	end
	
	return false
end

events.MakeClan.OnServerInvoke = function(player,args)
    if isPlayerInClan(player) then
        return "Player is already in a clan"
    end

    args[2] = modules
    args[3] = events

    local response = modules.ClanFilter.FilterClanName(player,args)
    return response
end

events.IsPlayerInClan.OnServerInvoke = function(player)
    return isPlayerInClan(player)
end

events.LeaveClan.OnServerEvent:Connect(function(player)
    if isPlayerInClan(player) == false then
        return false
    end

    modules.ClanLeave.Leave(player,table.pack(modules,events))
end)