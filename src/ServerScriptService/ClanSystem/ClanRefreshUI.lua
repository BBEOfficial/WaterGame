local Players = game:GetService("Players")

local module = {}
    module.Refresh = function(guid,args)
        local modules,events = table.unpack(args)

        warn("Refreshing Clan Information")
        for index,player in ipairs(modules.ClanData[guid]["Followers"]) do -- fixed an error here i just wasnt passing guid through like the fucking idiot i am
            local actualPlayer = Players:FindFirstChild(player.Name)
            events.RefreshClanInfo:FireClient(actualPlayer)
        end
        events.RefreshClanInfo:FireClient(Players:FindFirstChild(modules.ClanData[guid].Leader.Name))
    end
return module