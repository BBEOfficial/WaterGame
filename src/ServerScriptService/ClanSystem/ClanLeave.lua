local module = {}
    module.Leave = function(player,args)
        local modules,events = args[1],args[2]

        local clan = nil
        local delete = false
        local id = nil
        local ClanData = modules.ClanData

        for x,c in pairs(ClanData) do
            if c["Leader"] == player.UserId then
                clan = c
                id = x
                delete = true
                break
            else
                for i,v in pairs(c["Followers"]) do
                    if v.UserId == player.UserId then
                        clan = c
                        id = i
                        break
                    end
                end
            end
        end
        
        if clan == nil then
            return
        end

        if delete == true then
            ClanData["ListOfPlayersInAnyClan"][clan["Leader"]] = nil
            if #clan["Followers"] > 0 then
                for i,_ in pairs(clan["Followers"]) do
                    ClanData["ListOfPlayersInAnyClan"][clan["Followers"][i]] = nil
                end
            end

            ClanData[id] = nil

            warn("clan deleted")
        else
            ClanData["ListOfPlayersInAnyClan"][clan["Follower"][id]] = nil
            if #clan["Followers"] > 0 then
                for i,_ in pairs(clan["Followers"]) do
                    ClanData["ListOfPlayersInAnyClan"][clan["Followers"][i]] = nil
                end
            end
        end
    end
return module