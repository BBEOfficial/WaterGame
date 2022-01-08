-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Private Variables --
local camSys = nil
local hasWeaponSelected = false

-- Tables --
local currentSelection = {}
local modules = {}
local events = {}

-- Functions --
function eventScraper(loc)
    for _,v in pairs(loc:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            events[v.Name] = v
        end
    end
end

function isItemWeapon(t)
	if t == "1" then
		return true 
	else
		return false
	end
end
  
local module = {}

	module.Init = function(m)
		modules = m
		eventScraper(ReplicatedStorage)
		warn("init")
		camSys = modules.CameraSystem.new()
		warn(camSys)
	end

	module.NewSelection = function(itemType,itemUid)
		repeat wait() until camSys

		print("Itemtype: "..itemType)
		print("ItemUid: "..itemUid)
		if itemType == "0" and itemUid == "0" then
			warn("Empty hand")
			hasWeaponSelected = false
			print("CS",camSys)
			camSys:ShiftLock(false)
		end
		hasWeaponSelected = isItemWeapon(itemType)
		currentSelection = table.pack(itemType,itemUid)

		module.ApplyWeaponZoom(false)
	end

	module.ApplyWeaponZoom = function(aimingDownSights)
		if hasWeaponSelected == true then
			if aimingDownSights == false then
				camSys:ShiftLock(true,"SHIFT")
			else
				camSys:ShiftLock(true,"AIM")
			end
		end
	end

return module