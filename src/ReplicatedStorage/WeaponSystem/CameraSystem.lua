local players = game:GetService("Players")
local lp = players.LocalPlayer

local camera = workspace.CurrentCamera

local offsets = {
	["RESTING_OFFSET"] = Vector3.new(0,0,0);
	["SHIFT_OFFSET"] = Vector3.new(2.5,0,0);
	["AIM_OFFSET"] = Vector3.new(2.5,-.5,-1);
}

local zooms = {
	["RESTING_ZOOM"] = Vector2.new(128,0.5);
	["SHIFT_ZOOM"] = Vector2.new(10,5);
	["AIM_ZOOM"] = Vector2.new(7,7);
}
 
local conn 

function changeZoom(vec)
	lp.CameraMaxZoomDistance = vec.X
	lp.CameraMinZoomDistance = vec.Y
end

function shiftLock(active,s,preset) 
	local rotation = s["rotation"]
	local hum = s["character"]:WaitForChild("Humanoid")
	local mouse = lp:GetMouse()
	
	
	local offset = (if active == true then offsets[preset.."_OFFSET"] else nil)
	local zoom = (if active == true then zooms[preset.."_ZOOM"] else nil)

	
	if active then
		hum.CameraOffset = offset -- I assume this is about the right camera offset.
		changeZoom(zoom)
		
		rotation.MaxTorque = Vector3.new(0, math.huge, 0) --Max the power on the Y axis
		conn = game:GetService("RunService").RenderStepped:Connect(function()
			rotation.CFrame = mouse.Origin
			game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.LockCenter
			game:GetService("UserInputService").MouseIconEnabled = false
		end) --Set the mouse to center every frame.
	else
		hum.CameraOffset = offsets["RESTING_OFFSET"] --Move the camera back to normal.
		changeZoom(zooms["RESTING_ZOOM"])
		
		rotation.MaxTorque = Vector3.new(0, 0, 0) --Clear the torque on the HumanoidRootPart
		if conn then conn:Disconnect() end -- Allow mouse to move freely.
		game:GetService("UserInputService").MouseIconEnabled = true
	end
end

local module = {}
module.__index = module

	function module.new()
		local character = lp.Character or lp.CharacterAdded:Wait()
		
		local rotation = Instance.new("BodyGyro") --Create a new body gyro.
		rotation.P = 1000^4 --Increase the power
		rotation.Parent = character.Humanoid.RootPart --Parent it to the HumanoidRootPart
		
		local t = {["rotation"]  = rotation, ["character"] = character}
		setmetatable(t,module)

		return t
	end
	
	function module:UpdateCharacter()
		local character = lp.Character or lp.CharacterAdded:Wait()

		local rotation = Instance.new("BodyGyro") --Create a new body gyro.
		rotation.P = 1000000 --Increase the power
		rotation.Parent = character.Humanoid.RootPart --Parent it to the HumanoidRootPart
		
		self["rotation"] = rotation
		self["character"] = character
	end
	
	function module:ShiftLock(active,preset)
		shiftLock(active,self,preset)
	end
return module
