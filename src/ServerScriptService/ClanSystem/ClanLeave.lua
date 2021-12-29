local module = {}
    module.Leave = function(player,args)
        local modules,events = args[1],args[2]

        local ClanGUID = modules.ClanData["ListOfPlayersInAnyClan"][player.UserId]["GUID"]
        local CurrentClan = modules.ClanData[ClanGUID]
        
        if CurrentClan.Leader == player.Name then
            -- Pick a random follower to make the leader of the clan if there is any
           if #CurrentClan.Followers > 0 then
                local ChosenFollower = CurrentClan.Followers[math.random(1,#CurrentClan.Followers)]

                CurrentClan.Leader = ChosenFollower
                modules.ClanData["ListOfPlayersInAnyClan"][player.UserId] = nil

                warn("Handed over ownership")
                print(modules.ClanData)
                return true
           else
                modules.ClanData["ListOfPlayersInAnyClan"][player.UserId] = nil
                modules.ClanData[ClanGUID] = nil

                warn("Clan deleted")
                print(modules.ClanData)
                return true
           end
        else
            CurrentClan.Followers[player.UserId] = nil
            warn("Left clan")
            print(modules.ClanData)
            return true
        end
    end
return module