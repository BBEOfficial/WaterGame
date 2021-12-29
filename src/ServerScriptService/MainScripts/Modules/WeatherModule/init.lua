local SERVER_STORAGE = game:GetService("ServerStorage")
local RUN_SERVICE = game:GetService("RunService")
local TS = game:GetService("TweenService")
local TERRAIN = workspace:WaitForChild("Terrain",math.huge)
local LIGHTING = game:GetService("Lighting")
local WEATHER_SETUPS = SERVER_STORAGE:WaitForChild("WeatherSetups")

local cloud_min = nil
local cloud_max = nil

local ATMOSPHERE = LIGHTING:WaitForChild("Atmosphere",math.huge)
local BLOOM = LIGHTING:WaitForChild("Bloom",math.huge)
local BLUR = LIGHTING:WaitForChild("Blur",math.huge)
local COLORCORRECTION = LIGHTING:WaitForChild("ColorCorrection",math.huge)
local SUNRAYS = LIGHTING:WaitForChild("SunRays",math.huge)
local CLOUDS =  TERRAIN:WaitForChild("Clouds",math.huge)

local Atmosphere_Properties = {
	"Density",
	"Offset",
	"Color",
	"Decay",
	"Glare",
	"Haze"
}
local Bloom_Properties = {
	"Intensity",
	"Size",
	"Threshold"
}
local Blur_Properties = {
	"Size"
}
local CC_Properties = {
	"Brightness",
	"Contrast",
	"Saturation",
	"TintColor"
}
local SunRays_Properties = {
	"Intensity",
	"Spread"
}
local Clouds_Properties = {
	"Cover",
	"Density",
	"Color",
}

--coroutine.wrap(function()
--	while true do
--		if cloud_min ~= nil then
--			local ran = math.random(cloud_min*1000,cloud_max*1000)
--			TS:Create(CLOUDS,TweenInfo.new(math.random(40,59),Enum.EasingStyle.Linear),{Cover = ran/1000}):Play()
--			wait(60)
--		end
--		wait(0.0001)
--	end
--end)()

local module = {}
	function module.LoadWeather(WeatherName,t)
		local WeatherSetup = WEATHER_SETUPS:FindFirstChild(string.lower(WeatherName))
		if not WeatherSetup then
			warn("Missing weather setup '"..WeatherName.."'")
			return
		end
		
		coroutine.wrap(function()
			for _,v in pairs(Atmosphere_Properties) do
				TS:Create(ATMOSPHERE,TweenInfo.new(t,Enum.EasingStyle.Linear),{[v] = WeatherSetup.Atmosphere[v]}):Play()
			end
		end)()
		
		coroutine.wrap(function()
			for _,v in pairs(Bloom_Properties) do
				TS:Create(BLOOM,TweenInfo.new(t,Enum.EasingStyle.Linear),{[v] = WeatherSetup.Bloom[v]}):Play()
			end
		end)()
		
		coroutine.wrap(function()
			for _,v in pairs(Blur_Properties) do
				TS:Create(BLUR,TweenInfo.new(t,Enum.EasingStyle.Linear),{[v] = WeatherSetup.Blur[v]}):Play()
			end
		end)()
		
		coroutine.wrap(function()
			for _,v in pairs(CC_Properties) do
				TS:Create(COLORCORRECTION,TweenInfo.new(t,Enum.EasingStyle.Linear),{[v] = WeatherSetup.ColorCorrection[v]}):Play()
			end
		end)()
		
		coroutine.wrap(function()
			for _,v in pairs(SunRays_Properties) do
				TS:Create(SUNRAYS,TweenInfo.new(t,Enum.EasingStyle.Linear),{[v] = WeatherSetup.SunRays[v]}):Play()
			end
		end)()
		
		coroutine.wrap(function()
			for _,v in pairs(Clouds_Properties) do
				TS:Create(CLOUDS,TweenInfo.new(t,Enum.EasingStyle.Linear),{[v] = WeatherSetup.Clouds[v]}):Play()
			end
		end)()
		
		coroutine.wrap(function()
			for _,v in pairs(WeatherSetup.Lighting:GetChildren()) do
				TS:Create(LIGHTING,TweenInfo.new(t,Enum.EasingStyle.Linear),{[v.Name] = v.Value}):Play()
			end
		end)()
		
		coroutine.wrap(function()
			wait(t)
			warn("Weather switched")
		end)()
		
		local CloudCover = WeatherSetup:WaitForChild("CloudCover")
		cloud_min = CloudCover:WaitForChild("Min").Value
		cloud_max = CloudCover:WaitForChild("Max").Value
	end
return module
