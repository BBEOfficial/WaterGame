-- Services
local SSS = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

-- Objects
local ItemSystem = SSS:WaitForChild("ItemSystem")
local Inventory = SSS:WaitForChild("Inventory")

-- Modules
local DataStore = require(SSS:WaitForChild("DataSystem"):WaitForChild("DataStore"))
local ItemCreator = require(ItemSystem:WaitForChild("ItemCreator"))
local PlayerInventorys = require(Inventory:WaitForChild("PlayerInventorys"))
local ServerData_Module = require(SSS:WaitForChild("DataSystem"):WaitForChild("ServerData"))
local Inventory_Module = require(Inventory:WaitForChild("InventoryMain"))

-- Variables
local Key = "%s-data1"

-- Events

function OnPlayerLeft(plr)
	-- DataStore.POST(plr.UserId.."-data",{"BLANK"},plr.UserId)
	local serverData = ServerData_Module.GetData(plr.UserId) -- grabs the players data from the server data module
	
	-- Checks for corrupted data
	if serverData[1] == "err" then
		warn("player "..plr.UserId.." had error data, not saving")
		return "NS"
	elseif serverData == nil then
		warn("player "..plr.UserId.." had error data, not saving")
		return "NS"
	end
	
	local DataKey = string.format(Key,plr.UserId) -- formats the data key
	DataStore.POST(DataKey,serverData,plr.UserId) -- saves data
	
	PlayerInventorys.removeInventory(plr.UserId) -- removes the player inventory from the server storage
	
	warn("Data saved for player "..plr.UserId)
end

function OnNewPlayer(plr)
	local DataKey = string.format(Key,plr.UserId)
	local data = DataStore.GET(DataKey,plr.UserId)

	if data[1] == "BLANK" then
		warn("Blank data")
		-- generate items for the player
		local newdata = {
			["Inventory"] = {

			},
		}
		
		-- creates info for empty hand and flintlock
		local EmptyHand = ItemCreator.CreateItemInfo(0,0,"Server-"..plr.UserId)
		local Flintlock = ItemCreator.CreateItemInfo(1,0,"Server-"..plr.UserId)
		table.insert(newdata.Inventory,EmptyHand)
		table.insert(newdata.Inventory,Flintlock)

		ServerData_Module.SetData(plr.UserId,newdata) -- sets the player data in the server data module
		PlayerInventorys.addInventory(plr.UserId,newdata.Inventory) -- adds the players inventory to the player inventory module
	elseif data[1] == "err" then
		-- kicks the player
		warn("Player has corrupted data.")
		plr:Kick("We apologise but there was an error with gathering your data :(.\n We're sorry please rejoin,\n If this issue persists please contact us in our discord server with a screenshot of this error. \n"..(plr.UserId+50)*2 .."\n"..plr.UserId)
		return "cr"
	else
		warn("Player has existing data")
		PlayerInventorys.addInventory(plr.UserId,data["Inventory"]) -- adds the players inventory to the player inventory module
	end
	
	-- sends ok signal to inventory handler to tell them to update the client
	Inventory_Module.NewPlayerReady(plr)
end

local module = {}
    module.NewPlayer = function(plr)
        OnNewPlayer(plr)
    end

    module.PlayerLeft = function(plr)
        OnPlayerLeft(plr)
    end
return module