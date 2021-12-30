local ReplicatedStorage = game:GetService("ReplicatedStorage")

local modules = {}
local events = {}

function eventScraper(loc)
    for _,v in pairs(loc:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            events[v.Name] = v
        end
    end
end

function isPlayerInClan(player)
	for _,v in pairs(modules.ClanData["ListOfPlayersInAnyClan"]) do
		if v.UID == player.UserId then
			return true,v
		end
	end
	
	return false
end

eventScraper(ReplicatedStorage)

local module = {}
    module.Init = function(M)
        modules = M
    end

    module.InvitePlayer = function(from,args)
        events.ReceiveInvite:FireClient(args[1],args)
    end

    module.JoinClan = function(from,clanGUID)
        -- checks if player is already in clan
        local IsInClan,ClanData = isPlayerInClan(from)
        if IsInClan then
            modules.ClanLeave.Leave(from,table.pack(modules,events))
        end
        -- gets clans data_table
        local Data_table = modules.ClanData[clanGUID]
        if not Data_table then
            return false
        end
        if #Data_table.Followers >= 4 then
            return false
        end

        table.insert(modules.ClanData[clanGUID]["Followers"],{["Name"] = from.Name,["UserId"] = from.UserId})
        modules.ClanData["ListOfPlayersInAnyClan"][from.UserId] = {["UID"] = from.UserId,["Name"] = Data_table.Name,["GUID"] = Data_table.GUID}

        return true
    end
return module