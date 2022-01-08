-- services
local players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local REPLICATED_STORAGE = game:GetService("ReplicatedStorage")
local TWEEN_SERVICE = game:GetService("TweenService")
local HTTP_SERVICE = game:GetService("HttpService")

local modules = {}

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

function seperateImportantItems(inventory)
	-- ["Name"] = itemName["Name"],
	-- ["ItemType"] = itemType,
	-- ["SerialNumber"] = serial,
	-- ["Uid"] = itemName["Uid"],
	-- ["Icon"] = itemName["Icon"],
	-- ["Slot"] = itemName["Slot"]

	local ImportantItems = {
		{"0","0"},
		{"1","0"},
		{"2","0"},
		{"2","1"},
	}

	local importants = {}
	for _,item in ipairs(inventory) do
		local isImportant = false
		for _,id in ipairs(ImportantItems) do
			if id[1] == item.ItemType and id[2] == item.Uid then
				isImportant = true
			end
		end
 
		if isImportant == true then
			print("item",item)
			table.insert(importants,{item.ItemType,item.Uid})
		end
	end

	return importants
end
 
local module = {}
	function module.Init(m)
		modules = m
	end

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
			-- for _,x in ipairs(seperateImportantItems(INVENTORY_MODULE["Inventory"])) do
			-- 	modules.WeaponModule.AddQuickScroll(table.unpack(x))
			-- end
		end)
	end
	
	function module.requestPlayerInventory()
		local key = HTTP_SERVICE:GenerateGUID(false)
		local ans = EVENTS.updateInventoryTS:InvokeServer(key)
		repeat wait() until ans 

		if ans["key"] == key then
			INVENTORY_MODULE["Inventory"] = ans["newInv"]
			-- for _,x in ipairs(seperateImportantItems(INVENTORY_MODULE["Inventory"])) do
			-- 	modules.WeaponModule.AddQuickScroll(table.unpack(x))
			-- end
		end
	end
return module
