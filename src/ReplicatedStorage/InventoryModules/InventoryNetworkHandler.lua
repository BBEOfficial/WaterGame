-- services
local players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local REPLICATED_STORAGE = game:GetService("ReplicatedStorage")
local TWEEN_SERVICE = game:GetService("TweenService")
local HTTP_SERVICE = game:GetService("HttpService")

-- objects 
local self = script
local Inventory = self.Parent
local localPlayer = players.LocalPlayer
local INVENTORY_EVENT_FOLDER = REPLICATED_STORAGE:WaitForChild("InventoryEvents")
local EVENTS = {
	["updateInventoryTS"] = INVENTORY_EVENT_FOLDER:WaitForChild("updateInventoryTS"),
	["updateInventoryTC"] = INVENTORY_EVENT_FOLDER:WaitForChild("updateInventoryTC"),
	["serverCheck"] = INVENTORY_EVENT_FOLDER:WaitForChild("serverCheck"),
	["clientCheck"] = INVENTORY_EVENT_FOLDER:WaitForChild("clientCheck"),
}

-- modules
local INVENTORY_MODULE = require(Inventory:WaitForChild("PlayerInventory"))

local module = {}
	function module.setupServerConnection()
		EVENTS.serverCheck.OnClientEvent:Connect(function(key)
			EVENTS.serverCheck:FireServer({key,INVENTORY_MODULE})
		end)
	end
	
	function module.setupClientUpdate()
		EVENTS.updateInventoryTC.OnClientEvent:Connect(function(data)
			local INVENTORY_MAIN_MODULE = require(Inventory:WaitForChild("InventoryMainHandler"))
			for i,v in pairs(data) do
				INVENTORY_MODULE["Inventory"][i] = v
			end
			INVENTORY_MAIN_MODULE.UpdateIcons()
		end)
	end
	
	function module.requestPlayerInventory()
		local key = HTTP_SERVICE:GenerateGUID(false)
		local ans = EVENTS.updateInventory:InvokeServer(key)
		repeat wait() until ans 

		if ans["key"] == key then
			INVENTORY_MODULE["Inventory"] = ans["newInv"]
		end
	end
return module
