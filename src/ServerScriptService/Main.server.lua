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
    local IsInClan,CD = isPlayerInClan(from)
    if  IsInClan == false then
        return "Player is not in a clan"
    end

    if modules.ClanData[CD.GUID].Leader.Name ~= from.Name then
        warn("Player does not own clan")
        return
    end

    local plr = Players:FindFirstChild(to)
    if not plr then
        return
    end

    local args = table.pack(plr,CD.Name,CD.GUID)

    modules.ClanInvite.InvitePlayer(from,args)
end) 

events.JoinClan.OnServerEvent:Connect(function(plr,guid,declined)
    if declined == true then
        local clan = modules.ClanData[guid]
        local clanLeader = clan.Leader.Name

        events.SendDebug:FireClient(Players:FindFirstChild(clanLeader), {"Invite Declined.",plr.Name.." declined your invite to '"..clan.Name.."'."})

        return
    end

    local ans = modules.ClanInvite.JoinClan(plr,guid)

    repeat wait() until ans -- just waits until we get a return from the join clan module
    
    modules.ClanRefreshUI.Refresh(guid,table.pack(modules,events))
end)

