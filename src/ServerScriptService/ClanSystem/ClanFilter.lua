local TEXT_SERVICE = game:GetService("TextService")
local HTTP_SERVICE = game:GetService("HttpService")

local module = {}
    module.FilterClanName = function(player,args)
        local modules = args[2]
        local events = args[3]

        if type(args[1]) == "string" then
            local text = args[1]
            local filteredText = ""
            local s,e = pcall(function()
                filteredText = TEXT_SERVICE:FilterStringAsync(text,player.UserId)
            end)
            
            if s == false then
                warn("Filtering system failed || "..e)
                events.SendDebug:FireClient(player,"Filtering system failed, please try again later")
                return false
            end 
            
            filteredText = filteredText:GetNonChatStringForBroadcastAsync()
            
            if filteredText ~= text then
                warn("Text was filtered")
                events.SendDebug:FireClient(player,"Clan Name was filtered.")
                return false
            end
            
            local clanTable = {
                ["Name"] = filteredText,
                ["GUID"] = HTTP_SERVICE:GenerateGUID(false),
                ["Leader"] = player.Name,
                ["Followers"] = {}
            }
            modules.ClanData[clanTable.GUID] = clanTable
            modules.ClanData["ListOfPlayersInAnyClan"][player.UserId] = {["UID"] = player.UserId,["Name"] = filteredText,["GUID"] = clanTable.GUID}
            return true
        else
            return false
        end
    end
return module