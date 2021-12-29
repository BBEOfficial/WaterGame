--vars
local self = script
local src = self.Parent

local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui"):WaitForChild("Inventory")

local Area = playerGui.Area
local Center = Area.Center
local PointLine = Center.PointLine
local Buttons = Area.Buttons
local Inventory = self.Parent

local UIS = game:GetService("UserInputService")
local REPLICATED_STORAGE = game:GetService("ReplicatedStorage")
local TWEEN_SERVICE = game:GetService("TweenService")
local HTTP_SERVICE = game:GetService("HttpService")
local SPRING_MODULE = require(src.Spring)

local open = false
local lastRotTween = false
local Spring = nil
local currentlySelectedSlot = nil
local lastTween = nil

-- events

local INVENTORY_EVENT_FOLDER = REPLICATED_STORAGE:WaitForChild("InventoryEvents")
local EVENTS = {
	["updateInventoryTS"] = INVENTORY_EVENT_FOLDER:WaitForChild("updateInventoryTS"),
	["updateInventoryTC"] = INVENTORY_EVENT_FOLDER:WaitForChild("updateInventoryTC"),
	["serverCheck"] = INVENTORY_EVENT_FOLDER:WaitForChild("serverCheck"),
	["clientCheck"] = INVENTORY_EVENT_FOLDER:WaitForChild("clientCheck"),
}

-- modules
local INVENTORY_MODULE = require(Inventory:WaitForChild("PlayerInventory"))

-- functions

-- base functions 
do
	baseFunctions = {}
	function baseFunctions.GetAngle(v1,v2)
		local a = v2 + Vector2.new(3, 3) -- Don't worry about the addition, it's to solve the anchor point problem
		local b = v1 - Vector2.new(0, 36) -- GetMouseLocation ignores gui inset
		local rot = math.deg(math.atan2(a.y - b.Y, a.X - b.X)) -- Getting the rotation
		return rot
	end

	function baseFunctions.UpdatePointLine()
		local mp = UIS:GetMouseLocation()
		local angle = baseFunctions.GetAngle(mp,Center.AbsolutePosition)
		
		if angle < 0 then
		--[[
			Rotation from atan2 ranges from -180 to 180. This
			just makes sure that rotation ranges from 0 - 360
			to make things less complicated
		]] 
			angle += 360
		end
		if math.abs(Spring.Value - angle) >= 180 then -- When the spinner goes from 360 past 0
			if Spring.Value > 180 and angle < 180 then -- When the spinner goes past 360 degrees
				Spring.Value = 0 - (360 - Spring.Value)
			else -- When the spinner goes below 0 degrees
				Spring.Value = 360 + Spring.Value
			end
		end
		
		Spring.Target = angle
		PointLine.Rotation = Spring.Value
	end
end

-- main functions
do
	mainFunctions = {}
	
	function mainFunctions.collidesWith(gui1, gui2) ---A little different wording but it serves the same purpose
		local gui1_topLeft = gui1.AbsolutePosition
		local gui1_bottomRight = gui1_topLeft + gui1.AbsoluteSize

		local gui2_topLeft = gui2.AbsolutePosition
		local gui2_bottomRight = gui2_topLeft + gui2.AbsoluteSize

		return ((gui1_topLeft.x < gui2_bottomRight.x and gui1_bottomRight.x > gui2_topLeft.x) and (gui1_topLeft.y < gui2_bottomRight.y and gui1_bottomRight.y > gui2_topLeft.y))
	end
end



local module = {
	["UidSlots"] = {
		["1"] = {0,0},
		["2"] = {0,0},
		["3"] = {0,0},
		["4"] = {0,0},
		["5"] = {0,0},
		["6"] = {0,0},
		["7"] = {0,0},
		["8"] = {0,0},
	}
}

function module.InitialiseUI()
	Spring = SPRING_MODULE.new(0)
	Spring.Speed = 20
end

function module.UpdateIcons(v)
	local CurrentPlayerInventory = INVENTORY_MODULE.Inventory
	-- if v == true then
		for _,v in ipairs(CurrentPlayerInventory) do
			-- grabs the icon for each object
			local icon = v["Icon"]
			local slot = v["Slot"]
			
			if Buttons:FindFirstChild("Slot"..slot) then
				local imageLab = Buttons:FindFirstChild("Slot"..slot):WaitForChild("ItemImage")
				imageLab.Image = "http://www.roblox.com/asset/?id="..icon
			end
		end
	-- end	
end

function module.runUpdates()
	repeat
		baseFunctions.UpdatePointLine()
		for _,v in pairs(Area.Buttons:GetChildren()) do
			if mainFunctions.collidesWith(PointLine.Tip,v) then
				currentlySelectedSlot = v.Name -- updates the currently selected variable
				TWEEN_SERVICE:Create(v,TweenInfo.new(0.15,Enum.EasingStyle.Linear),{Size = UDim2.new(0.172, 20,0.172, 20)}):Play() -- tweens the selected slot to be bigger to make the effect look nicer
				break
			else
				TWEEN_SERVICE:Create(v,TweenInfo.new(0.15,Enum.EasingStyle.Linear),{Size = UDim2.new(0.172, 0,0.172, 0)}):Play() -- tweens the un selected slots to be the normal size
			end
			currentlySelectedSlot = nil
		end
		wait()
	until open == false
end

function module.toggleInventory(v)
	if v == false then
		if lastTween ~= nil then
			lastTween:Pause()
		end
		-- closes the inventory and also checks to see which item the player selected
		UIS.MouseIconEnabled = true
		open = false
		lastTween = TWEEN_SERVICE:Create(Area,TweenInfo.new(0.25,Enum.EasingStyle.Linear),{Size = UDim2.new(0,0,0,0),Position = UDim2.new(0.5,0,2,0)}):Play() -- tweens the inventory closed
		currentlySelectedSlot = currentlySelectedSlot or "Slot1" -- slot1 = empty hand
		
		warn("selection: "..currentlySelectedSlot)
	elseif v == true then
		if lastTween ~= nil then
			lastTween:Pause()
		end
		-- opens the inventory
		UIS.MouseIconEnabled = false
		open = true
		-- updates the point line 
		task.spawn(function()
			module.runUpdates()
		end)
		lastTween = TWEEN_SERVICE:Create(Area,TweenInfo.new(0.25,Enum.EasingStyle.Linear),{Size = UDim2.new(0.252, 0,0.499, 0),Position = UDim2.new(0.5,0,0.5,0)}):Play() -- tweens the inventory open
	end
end

return module
