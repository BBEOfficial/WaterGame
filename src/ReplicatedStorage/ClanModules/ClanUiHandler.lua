local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ClanGui = PlayerGui:WaitForChild("Clan")

local modules = {}
local events = {}

local LastTween = nil

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
            if LastTween ~= nil then
                LastTween:Pause()
            end
            if value == true then
                CreationMenu.Visible = value
            end
            LastTween = TweenService:Create(
                CreationMenu,
                TweenInfo.new(tweenData[1],tweenData[2]),
                {Position = tweenData[3]}
            ):Play()
            wait(tweenData[1])
            if value == false then
                CreationMenu.Visible = value 
            end
        end
    end
return UiHandler

-- {0.25,Enum.EasingStyle.Linear,Udim2.new(0.111, 0,0.208, 0)}