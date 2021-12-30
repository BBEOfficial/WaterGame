local module = {}
    module.Leave = function(player,args)
        local modules,events = table.unpack(args)

        local ClanGUID = modules.ClanData["ListOfPlayersInAnyClan"][player.UserId]["GUID"]
        local CurrentClan = modules.ClanData[ClanGUID]
        
        if CurrentClan.Leader == player.Name then
            -- Pick a random follower to make the leader of the clan if there is any
           if #CurrentClan.Followers > 0 then
                local ChosenFollower = CurrentClan.Followers[math.random(1,#CurrentClan.Followers)]

                CurrentClan.Leader = ChosenFollower
                modules.ClanData["ListOfPlayersInAnyClan"][player.UserId] = nil
                
                for i,v in pairs(CurrentClan.Followers) do
                    if v.UserId == ChosenFollower.UserId then
                        CurrentClan.Followers[i] = nil
                    end
                end

                modules.ClanRefreshUI.Refresh(ClanGUID,table.pack(modules,events))
                warn("Handed over ownership")
                return true
           else
                modules.ClanData["ListOfPlayersInAnyClan"][player.UserId] = nil
                modules.ClanData[ClanGUID] = nil


                warn("Clan deleted")
                return true
           end
        else
            for i,v in pairs(CurrentClan.Followers) do
                if v.UserId == player.UserId then
                    CurrentClan.Followers[i] = nil
                end
            end
            modules.ClanData["ListOfPlayersInAnyClan"][player.UserId] = nil

            modules.ClanRefreshUI.Refresh(ClanGUID,table.pack(modules,events))
            warn("Left clan")
            return true
        end
    end
return module