local cameraMod = require(game.ReplicatedStorage.WeaponSystem.CameraSystem)
local crosshair = require(game.ReplicatedStorage.WeaponSystem.Crosshair)
wait(5)
print("bsgjuvdsg")
local s = cameraMod.new(workspace.CurrentCamera)
s:ShiftLock(true,"AIM")

local crosshairStartingPos = {
	["Top"] = UDim2.new(0, 50,0, 13),
	["Bottom"] = UDim2.new(0, 50,0, 87),
	["Left"] = UDim2.new(0, 13,0, 50),
	["Right"] = UDim2.new(0, 88,0, 50),
}
local c = crosshair.new(Color3.fromRGB(255, 255, 255),crosshairStartingPos)

c:ChangeCrosshairVisibility(0.5)

wait(5)

c:ChangeCrosshairColor(Color3.fromRGB(76, 154, 255))

wait(5)

c:Destroy()
s:ShiftLock(false)