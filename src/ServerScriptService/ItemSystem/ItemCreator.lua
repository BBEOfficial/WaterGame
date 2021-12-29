local SSS = game:GetService("ServerScriptService")
local ItemSystem = SSS:WaitForChild("ItemSystem")
local Items = require(ItemSystem:WaitForChild("Items"))
local SNG = require(ItemSystem:WaitForChild("SNG"))

local module = {}
 function module.CreateItemInfo(itemType : string,uid : string,creator : string)
	itemType = tostring(itemType)
	uid = tostring(uid)	
		
	local itemName = Items.Items.ItemTypes[itemType][uid]
	warn("Creating: "..itemName.Name)
	local serial = SNG.generate(itemType,os.time(),creator,uid)
	
	local itemTable = {
		["Name"] = itemName["Name"],
		["ItemType"] = itemType,
		["SerialNumber"] = serial,
		["Uid"] = itemName["Uid"],
		["Icon"] = itemName["Icon"],
		["Slot"] = itemName["Slot"]
	}
	
	return itemTable
 end
 function module.GetItemInfo(itemType: string,uid : string)
	itemType = tostring(itemType)
	uid = tostring(uid)

	local itemInfo = Items.Items.ItemTypes[itemType][uid]
	
	return itemInfo
 end
return module


