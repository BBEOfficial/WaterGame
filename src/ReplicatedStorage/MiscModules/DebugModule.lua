-- Debug module
-- Written by Jakey
-- 30/12/21

local STARTER_GUI = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local events = {}

function eventScraper(loc)
    for _,v in pairs(loc:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            events[v.Name] = v
        end
    end
end
eventScraper(ReplicatedStorage)

local debug = {}
    debug.SetupDebugConnection = function()
        events.SendDebug.OnClientEvent:Connect(function(info)
            STARTER_GUI:SetCore("SendNotification", {
                Title = info[1],
                Text = info[2],
                --Icon = "rbxthumb://type=Asset&id="..info[3].."&w=150&h=150",
                Duration = 3,
            }
            )
        end)
    end
return debug