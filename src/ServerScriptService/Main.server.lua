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
    if isPlayerInClan(plr) then
        modules.ClanLeave.Leave(plr,table.pack(modules,events))
    end
    modules.DataInteractions.PlayerLeft(plr)
end)

-- Clan Stuff
warn("clan stuff")

modules.ClanInvite.Init(modules)

function isPlayerInClan(player)
	for _,v in pairs(modules.ClanData["ListOfPlayersInAnyClan"]) do
		if v.UID == player.UserId then
			return true,v
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

events.GetClanInfo.OnServerInvoke = function(player)
    local IsInClan,ClanData = isPlayerInClan(player)
    if  IsInClan == false then
        return "Player is not in a clan"
    end
 
    local ClanGuid= ClanData["GUID"]

    return modules.ClanData[ClanGuid]
end

events.SendInvite.OnServerEvent:Connect(function(from,to)
    warn("sending invite")
    local IsInClan,ClanData = isPlayerInClan(from)
    if  IsInClan == false then
        return "Player is not in a clan"
    end

    local plr = Players:FindFirstChild(to)
    if not plr then
        return
    end

    local args = table.pack(plr,ClanData.Name,ClanData.GUID)

    modules.ClanInvite.InvitePlayer(from,args)
end)

events.JoinClan.OnServerEvent:Connect(function(plr,guid)
    local ans = modules.ClanInvite.JoinClan(plr,guid)

    repeat wait() until ans

    warn("Refreshing Clan Information")
    for index,player in ipairs(modules.ClanData[guid]["Followers"]) do -- this is where the error is ----------------------------------------------------
        print(player.Name)
        local actualPlayer = Players:FindFirstChild(player.Name)
        events.RefreshClanInfo:FireClient(actualPlayer)
    end
    events.RefreshClanInfo:FireClient(Players:FindFirstChild(modules.ClanData[guid].Leader))
    events.RefreshClanInfo:FireClient(plr)
end)

