local waveHeight = workspace.Terrain.WaterWaveSize * 2;
local waveExaduration = workspace.Terrain:WaitForChild("WaveExaduration");
local waveWidth = 85
local waterLevel = 55.5

local expectedWaveSpeed = 25

if not _G.GetWaterWaveCycle then
	workspace.Terrain.WaterWaveSpeed = 0
	--We have to make sure the water's cycle is 0. There is no way to know this,
	--but if the WaterWaveSpeed is nonzero, there's a good chance the cycle is
	--nonzero.
	assert(workspace.Terrain.WaterWaveSpeed==0,
		"WaterWaveCycle cannot be defined after setting WaterWaveSpeed to"
			.."anything nonzero.");
	--This will not catch cases where the user changes the water wave speed from
	--a nonzero value to 0 then calls this code chunk, but I can't think of a way
	--to catch that case.
	--We just have to hope users use this correctly.

	local cycleAtLastSet = 0; --The cycle at the time of the last wave speed set.
	local tickAtLastSet = 0; --The tick() at the last WaterWaveSpeed set.
	local speedAtLastSet = 0; --The last WaterWaveSpeed which was set.

	--@return A float between 0 and 2pi indicating the current cycle.
	--@describe The cycle will be 0 when a place is freshly loaded and the
	--    WaterWaveSpeed is 0.
	function _G.GetWaterWaveCycle()
		return math.pi * 2 * ((cycleAtLastSet + (tick() - tickAtLastSet)
			* workspace.Terrain.WaterWaveSpeed / 85) % 1);
	end

	--Listen for changes to WaterWaveSpeed and update the state variables.
	workspace.Terrain.Changed:connect(function(prop)
		if prop == "WaterWaveSpeed" then
			cycleAtLastSet = (cycleAtLastSet + 
				(tick() - tickAtLastSet) * speedAtLastSet / 85) % 1;
			print("Current Cycle State: ", cycleAtLastSet);
			tickAtLastSet = tick();
			speedAtLastSet = workspace.Terrain.WaterWaveSpeed;
		end
	end)
end

workspace.Terrain.WaterWaveSpeed = expectedWaveSpeed

local module = {
	["WaterLevel"] = waterLevel
}
function module.getWaveHeight(x,z)
	local cycle = _G.GetWaterWaveCycle()
	waveHeight = (workspace.Terrain.WaterWaveSize * 2) * waveExaduration.Value;
	return waveHeight * math.sin(2*math.pi*x/waveWidth + cycle + math.pi/2)* math.sin(2*math.pi*z/waveWidth)
end
return module
