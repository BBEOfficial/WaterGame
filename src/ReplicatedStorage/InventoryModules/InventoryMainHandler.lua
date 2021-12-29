-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Objects
local InventoryModules = ReplicatedStorage:WaitForChild("InventoryModules")
local self = script

-- Modules
local UiHandler = require(InventoryModules:WaitForChild("InventoryUiHandler"))
local NetworkHandler = require(InventoryModules:WaitForChild("InventoryNetworkHandler"))

-- Variables

-- Functions
function thread(func,t)
	if t ~= nil then
		task.spawn(function()
			func(table.unpack(t))
		end)
	else
		task.spawn(function()
			func()
		end)
	end
end

local module = {}
	function module.Init()
		thread(UiHandler.InitialiseUI)
		thread(NetworkHandler.setupServerConnection)
		thread(NetworkHandler.setupClientUpdate)
	end
	
	function module.ToggleInv(v)
		thread(UiHandler.toggleInventory,{v})
	end
	
	function module.UpdateIcons()
		thread(UiHandler.UpdateIcons)
	end
return module
