local waveHandler = require(script.WaveHandler)
local forcePoints = script.Parent:FindFirstChild("ForcePoints")
local runservice = game:GetService("RunService")

local velocityCo = 25000 -- change this depending on the weight of the boat

if not forcePoints then
	warn("Missing force points")
end
if #forcePoints:GetChildren() == 0 then
	warn("Needs atleast 1 force point")
end

function isInWater(pos)
	local min = pos - Vector3.new(.5,.5,.5)
	local max = pos + Vector3.new(.5,.5,.5)	
	local region = Region3.new(min,max):ExpandToGrid(4)

	local material = workspace.Terrain:ReadVoxels(region,4)[1][1][1] 

	if material == Enum.Material.Water then
		return true
	else
		return false
	end
end

function updateForces()
	for _,fp in pairs(forcePoints:GetChildren()) do
		if isInWater(fp.Position) == true then
			local fpX = fp.Position.X
			local fpZ = fp.Position.Z

			local h = waveHandler.getWaveHeight(fpX,fpZ)
			local waveHeight = (waveHandler.WaterLevel+h)*workspace.Terrain.WaterLiftSpeed.Value

			local v = 0

			if fp.Position.Y >= waveHeight then
				v = h*velocityCo
			else
				v = -h*velocityCo
			end

			local velocity = Vector3.new(0,v,0)
			fp.BT.Force = velocity
		else
			fp.BT.Force = Vector3.new()
		end
	end
end

runservice.Stepped:Connect(function()
	updateForces()
end)