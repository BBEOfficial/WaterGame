local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ClanGui = PlayerGui:WaitForChild("Clan")

local ClanUiHandler = script.Parent:WaitForChild("ClanUiHandler")

local modules = {}
local events = {}


function eventScraper(loc)
    for _,v in pairs(loc:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            events[v.Name] = v
        end
    end
end

eventScraper(ReplicatedStorage)

local MenuButtonToggle = true
local inviteQueue = {}
local InviteOpen = false

function openInvite(ClanName,ClanGUID)
    InviteOpen = true
    modules.ClanUiHandler.ApplyInviteInfoToUI(ClanName)
    modules.ClanUiHandler.InviteNotification(true,{0.25,Enum.EasingStyle.Back,UDim2.new(0.85, 0,0.7, 0)})

    -- countdown
    local currentTime = 20
    local countdownEnd = false

    task.spawn(function()
        ClanGui:WaitForChild("CLAN_INVITE_NOTIFICATION"):WaitForChild("Notification"):WaitForChild("Timer").Text = "00:20"
        repeat
            wait(1)
            currentTime -= 1
            ClanGui:WaitForChild("CLAN_INVITE_NOTIFICATION"):WaitForChild("Notification"):WaitForChild("Timer").Text = (if currentTime >= 10 then "00:"..currentTime else "00:0"..currentTime)
        until currentTime == 0 or countdownEnd == true

        if countdownEnd == true then
            return
        end

        modules.ClanUiHandler.InviteNotification(false,{0.5,Enum.EasingStyle.Back,UDim2.new(1.5, 0,0.7, 0)})
        events.JoinClan:FireServer(ClanGUID,true)

        InviteOpen = false
        return
    end)

    local InviteNotificationYes = ClanGui:WaitForChild("CLAN_INVITE_NOTIFICATION"):WaitForChild("Notification"):WaitForChild("Y")
    local InviteNotificationNo = ClanGui:WaitForChild("CLAN_INVITE_NOTIFICATION"):WaitForChild("Notification"):WaitForChild("N")

    InviteNotificationYes.MouseButton1Down:Connect(function()
        modules.ClanUiHandler.InviteNotification(false,{0.5,Enum.EasingStyle.Back,UDim2.new(1.5, 0,0.7, 0)})
        events.JoinClan:FireServer(ClanGUID)
        countdownEnd = true
        return
    end)

    InviteNotificationNo.MouseButton1Down:Connect(function()
        modules.ClanUiHandler.InviteNotification(false,{0.5,Enum.EasingStyle.Back,UDim2.new(1.5, 0,0.7, 0)})
        events.JoinClan:FireServer(ClanGUID,true)
        countdownEnd = true
        return
    end)
end

local ClanNetwork = {}

    ClanNetwork.SetupInviteConnection = function()
        events.ReceiveInvite.OnClientEvent:Connect(function(args)
            warn("recieved invite")
            local For = args[1]
            local ClanName = args[2]
            local ClanGUID = args[3]

            if InviteOpen == false then
               openInvite(ClanName,ClanGUID)
            else
                table.insert(inviteQueue,ClanGUID)
                task.spawn(function()
                    repeat
                        wait()
                    until InviteOpen == false and inviteQueue[1] == ClanGUID
                    table.remove(inviteQueue,1)
                end)

                openInvite(ClanName,ClanGUID)
            end
        end)
    end

    ClanNetwork.SetupClanInfoRefresh = function()
        events.RefreshClanInfo.OnClientEvent:Connect(function()
            warn("refresh")
            local clanInfo = events.GetClanInfo:InvokeServer()

            if clanInfo ~= false then
                warn("applying")
                warn("clandata", clanInfo)
                modules.ClanUiHandler.ApplyClanInfoToUI(clanInfo)
            end
        end)
    end

    ClanNetwork.SendInvite = function()
        local textBox = ClanGui:WaitForChild("CLAN_INFO_MENU"):WaitForChild("Menu"):WaitForChild("InviteBox")
        events.SendInvite:FireServer(textBox.Text)
        warn("fired to server")
    end

    ClanNetwork.Init = function(M)
        modules = M
        modules.ClanUiHandler.Init(modules)

        local MenuButton = ClanGui:WaitForChild("MenuButton")
        local CreationMenuCreate = ClanGui:WaitForChild("CLAN_CREATION_MENU"):WaitForChild("Menu"):WaitForChild("Create")
        local ClanInfoMenuLeave = ClanGui:WaitForChild("CLAN_INFO_MENU"):WaitForChild("Menu"):WaitForChild("Leave")

       MenuButton.MouseButton1Down:Connect(function()
            if ClanNetwork.IsInClan() == true then
                if MenuButtonToggle == true then
                    MenuButtonToggle = false
                    modules.ClanUiHandler.ClanInfoMenu(true,{0.5,Enum.EasingStyle.Back,UDim2.new(0.111, 0,0.358, 0)})
                else
                    MenuButtonToggle = true
                    modules.ClanUiHandler.ClanInfoMenu(false,{0.5,Enum.EasingStyle.Back,UDim2.new(0.111, 0,-0.358, 0)})
                end
            else
                if MenuButtonToggle == true then
                    MenuButtonToggle = false
                    modules.ClanUiHandler.CreationMenu(true,{0.2,Enum.EasingStyle.Back,UDim2.new(0.111, 0,0.208, 0)})
                else
                    MenuButtonToggle = true
                    modules.ClanUiHandler.CreationMenu(false,{0.2,Enum.EasingStyle.Back,UDim2.new(0.111, 0,-0.208, 0)})
                end
            end
       end)

        CreationMenuCreate.MouseButton1Down:Connect(function()
            local TextBox = CreationMenuCreate.Parent:WaitForChild("ClanName")
            if TextBox.Text ~= "" then
               local ans = events.MakeClan:InvokeServer(table.pack(TextBox.Text))
               if ans == true then
                warn("Clan created") 
                task.spawn(function()
                    local clanInfo = events.GetClanInfo:InvokeServer()

                    if clanInfo ~= false then
                        modules.ClanUiHandler.ApplyClanInfoToUI(clanInfo)
                    end
                end)

                modules.ClanUiHandler.CreationMenu(false,{0.2,Enum.EasingStyle.Back,UDim2.new(0.111, 0,-0.208, 0)})

                MenuButtonToggle = false
                modules.ClanUiHandler.ClanInfoMenu(true,{0.5,Enum.EasingStyle.Back,UDim2.new(0.111, 0,0.358, 0)})
                
               

                return true
               else
                warn("Issue with creating clan")
                return ans
               end
            end
        end)

        ClanInfoMenuLeave.MouseButton1Down:Connect(function()
            warn("leaving")
            events.LeaveClan:FireServer()
            MenuButtonToggle = true
            modules.ClanUiHandler.ClanInfoMenu(false,{0.5,Enum.EasingStyle.Back,UDim2.new(0.111, 0,-0.358, 0)})
        end)
    end

    ClanNetwork.IsInClan = function()
       return events.IsPlayerInClan:InvokeServer()
    end
return ClanNetwork

-- Creation Menu Presets:
-- Open: {0.2,Enum.EasingStyle.Back,UDim2.new(0.111, 0,0.208, 0)}
-- Closed: {0.2,Enum.EasingStyle.Back,UDim2.new(0.111, 0,-0.208, 0)}

-- Info Menu Presets:
-- Open: {0.5,Enum.EasingStyle.Back,UDim2.new(0.111, 0,0.358, 0)}
-- Closed: {0.5,Enum.EasingStyle.Back,UDim2.new(0.111, 0,-0.358, 0)}

-- Invite Notif Presets:
-- Open: {0.25,Enum.EasingStyle.Back,UDim2.new(0.85, 0,0.7, 0)}
-- Closed: {0.25,Enum.EasingStyle.Back,UDim2.new(1.5, 0,0.7, 0)}