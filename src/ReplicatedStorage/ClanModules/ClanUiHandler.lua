local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ClanGui = PlayerGui:WaitForChild("Clan")

local modules = {}
local events = {}

local CM_LastTween = nil
local CI_LastTween = nil
local IN_LastTween = nil

function eventScraper(loc)
    for _,v in pairs(loc:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            events[v.Name] = v
        end
    end
end

eventScraper(ReplicatedStorage)

local UiHandler = {}
    UiHandler.Init = function(m)
        modules = m
    end
    UiHandler.CreationMenu = function(value : boolean,tweenData : table)
        local CreationMenu = ClanGui:WaitForChild("CLAN_CREATION_MENU")
        if tweenData == nil then
            CreationMenu.Visible = value
        else
            if CM_LastTween ~= nil then
                CM_LastTween:Pause()
            end
            -- if value == true then
            --     CreationMenu.Visible = value
            -- end
            CM_LastTween = TweenService:Create(
                CreationMenu,
                TweenInfo.new(tweenData[1],tweenData[2]),
                {Position = tweenData[3]}
            ):Play()
            wait(tweenData[1])
            -- if value == false then
            --     CreationMenu.Visible = value 
            -- end
        end
    end
    UiHandler.ClanInfoMenu = function(value : boolean, tweenData : table)
        local InfoMenu = ClanGui:WaitForChild("CLAN_INFO_MENU")
        if tweenData == nil then
            InfoMenu.Visible = value
        else
            if CI_LastTween ~= nil then
                CI_LastTween:Pause()
            end
            -- if value == true then
            --     InfoMenu.Visible = value
            -- end
            CI_LastTween = TweenService:Create(
                InfoMenu,
                TweenInfo.new(tweenData[1],tweenData[2]),
                {Position = tweenData[3]}
            ):Play()
            wait(tweenData[1])
            -- if value == false then
            --     InfoMenu.Visible = value 
            -- end
        end
    end
 
    UiHandler.InviteNotification = function(value : boolean, tweenData : table)
        local InviteNotif = ClanGui:WaitForChild("CLAN_INVITE_NOTIFICATION")
        if tweenData == nil then
            InviteNotif.Visible = value
        else
            if IN_LastTween ~= nil then
                IN_LastTween:Pause()
            end
            -- if value == true then
            --     InfoMenu.Visible = value
            -- end
            IN_LastTween = TweenService:Create(
                InviteNotif,
                TweenInfo.new(tweenData[1],tweenData[2]),
                {Position = tweenData[3]}
            ):Play()
            wait(tweenData[1])
            -- if value == false then
            --     InfoMenu.Visible = value 
            -- end
        end
    end

    UiHandler.ApplyClanInfoToUI = function(info : table)
        if type(info) ~= "table" then
            return
        end

        local CIM = ClanGui:WaitForChild("CLAN_INFO_MENU")
        CIM = CIM:WaitForChild("Menu")

        local ClanNameBox = CIM:WaitForChild("ClanName")
        local ClanPlayerCount = CIM:WaitForChild("ClanPlayerCount")
        local PlayersFrame = CIM:WaitForChild("PlayersFrame")

        ClanNameBox.Text = "["..info["Name"].."]"
        ClanPlayerCount.Text = "PLAYER COUNT:"..(#info["Followers"] + 1).."/5"
         
        -- Player frame code
        local CO = PlayersFrame:WaitForChild("CLANOWNER")
        local UID = Players:FindFirstChild(info["Leader"].Name).UserId-- if this breaks oh well ill fix it but cant be bothered rn
        CO.PName.Text = info["Leader"].Name.." (Clan Leader)"
        CO.PlayerInfo.Username.Value = info["Leader"].Name
        CO.PlayerInfo.UserId.Value = UID

        local AmILeader = (if LocalPlayer.UserId == UID then true else false)

        if AmILeader == true then
            CIM.InviteBox.Visible = true
        else
            CIM.InviteBox.Visible = false
        end

        for index,Player in ipairs(info["Followers"]) do

            warn("follower")
            local RelativeFrame = PlayersFrame:FindFirstChild("PlayerFrame"..index)
            if not RelativeFrame then
                break
            end

            if RelativeFrame.Name ~= "CLANLEADER" then
                if AmILeader == false then
                    RelativeFrame.Kick.Visible = false
                    RelativeFrame.CoverUp.Visible = true
                else
                    RelativeFrame.Kick.Visible = true
                    RelativeFrame.CoverUp.Visible = false
                end

                RelativeFrame.PName.Text = Player.Name
                RelativeFrame.PlayerInfo.Username.Value = Player.Name
                RelativeFrame.PlayerInfo.UserId.Value = Player.UserId
                RelativeFrame.Visible = true
            end
        end
    end

    UiHandler.ApplyInviteInfoToUI = function(Name)
        local IN = ClanGui:WaitForChild("CLAN_INVITE_NOTIFICATION")
        IN = IN:WaitForChild("Notification")

        IN.ClanName.Text = "Invite to "..Name

        -- Countdown gets applied in network handler
    end
return UiHandler

-- {0.25,Enum.EasingStyle.Linear,Udim2.new(0.111, 0,0.208, 0)}
