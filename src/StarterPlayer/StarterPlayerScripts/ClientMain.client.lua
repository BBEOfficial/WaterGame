-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")

local modules = {}
local events = {}

function moduleScraper(loc)
    for _,v in pairs(loc:GetDescendants()) do
        if v:IsA("ModuleScript") and v ~= script then
            modules[v.Name] = require(v)
        end
    end
end

function eventScraper(loc)
    for _,v in pairs(loc:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            events[v.Name] = v
        end
    end
end

moduleScraper(ReplicatedStorage)
eventScraper(ReplicatedStorage)

modules.InventoryMainHandler.Init()
modules.InventoryMainHandler.ToggleInv(false)

function ToggleRadialInventory(X,InputState)
    if InputState == Enum.UserInputState.Begin then
        modules.InventoryMainHandler.ToggleInv(true)
    elseif InputState == Enum.UserInputState.End then
        modules.InventoryMainHandler.ToggleInv(false)
    end
end

-- Clan Stuff
modules.ClanNetworkHandler.Init(modules)
 
-- Have these things at the very bottom of the code
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
ContextActionService:BindActionAtPriority("ToggleMenu", ToggleRadialInventory, false,math.huge, Enum.KeyCode.Tab)