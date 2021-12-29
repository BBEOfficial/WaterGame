-- Services
local RepStore = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

-- Objects
local InventoryFolder = RepStore:WaitForChild("InventoryEvents")
local InventorySystem = SSS:WaitForChild("Inventory")
local Events = {
	["updateInventoryTS"] = InventoryFolder:WaitForChild("updateInventoryTS");
	["updateInventoryTC"] = InventoryFolder:WaitForChild("updateInventoryTC");
	["clientCheck"] = InventoryFolder:WaitForChild("clientCheck");
	["serverCheck"] = InventoryFolder:WaitForChild("serverCheck");
}

-- Modules
local PlayerInventorys = require(InventorySystem:WaitForChild("PlayerInventorys"))
local ServerData = require(SSS:WaitForChild("DataSystem"):WaitForChild("ServerData"))

-- Functions

function removeSerial(inventory)
	local new = {}
	for i,v in ipairs(inventory) do
		--v["SerialNumber"] = nil
		new[i] = v
		new[i]["SerialNumber"] = nil
	end
	
	return new
end

function extractSerials(inv)
	local serials = {}
	for _,v in ipairs(inv) do
		if v["SerialNumber"] ~= nil then
			table.insert(serials,v["SerialNumber"])
		end
	end
	
	return serials
end

function reastpi(current,serials)
	local newData = {}
	for i,v in ipairs(serials) do
		local item = current[i]
		item["SerialNumber"] = v
		table.insert(newData,item)
	end
	
	return newData
end

-- Variables


local module = {}
    module.NewPlayerReady = function(player)
        local preSerial = PlayerInventorys.getInventory(player.UserId)
        local serials = extractSerials(preSerial)
        local inventory = removeSerial(preSerial)
        
        local s,e = pcall(function()
            Events.updateInventoryTC:FireClient(player,inventory)
        end)
        PlayerInventorys["Inventorys"][player.UserId] = reastpi(preSerial,serials)

        return s
    end
return module