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

local ClanNetwork = {}

    ClanNetwork.Init = function(M)
        modules = M
        modules.ClanUiHandler.Init(modules)

        local MenuButton = ClanGui:WaitForChild("MenuButton")
        local InviteNotificationYes = ClanGui:WaitForChild("CLAN_INVITE_NOTIFICATION"):WaitForChild("Notification"):WaitForChild("Y")
        local InviteNotificationNo = ClanGui:WaitForChild("CLAN_INVITE_NOTIFICATION"):WaitForChild("Notification"):WaitForChild("N")
        local CreationMenuCreate = ClanGui:WaitForChild("CLAN_CREATION_MENU"):WaitForChild("Menu"):WaitForChild("Create")
        local ClanInfoMenuLeave = ClanGui:WaitForChild("CLAN_INFO_MENU"):WaitForChild("Menu"):WaitForChild("Leave")

       MenuButton.MouseButton1Down:Connect(function()
            if ClanNetwork.IsInClan() == true then
                modules.ClanUiHandler.ClanInfoMenu(MenuButtonToggle)
            else
                if MenuButtonToggle == true then
                    modules.ClanUiHandler.CreationMenu(MenuButtonToggle,{0.2,Enum.EasingStyle.Back,UDim2.new(0.111, 0,0.208, 0)})
                else
                    modules.ClanUiHandler.CreationMenu(MenuButtonToggle,{0.2,Enum.EasingStyle.Back,UDim2.new(0.111, 0,-0.208, 0)})
                end
            end
            if MenuButtonToggle == true then
                MenuButtonToggle = false
            else
                MenuButtonToggle = true
            end
       end)

        CreationMenuCreate.MouseButton1Down:Connect(function()
            local TextBox = CreationMenuCreate.Parent:WaitForChild("ClanName")
            if TextBox.Text ~= "" then
               local ans = events.MakeClan:InvokeServer(table.pack(TextBox.Text))
               if ans == true then
                warn("Clan created")
                modules.ClanUiHandler.CreationMenu(false,{0.2,Enum.EasingStyle.Back,UDim2.new(0.111, 0,-0.208, 0)})
                return true
               else
                warn("Issue with creating clan")
                return ans
               end
            end
        end)

        ClanInfoMenuLeave.MouseButton1Down:Connect(function()
            events.LeaveClan:FireServer()
        end)
    end

    ClanNetwork.IsInClan = function()
       return events.IsPlayerInClan:InvokeServer()
    end
return ClanNetwork