local Lighting = game:GetService("Lighting")
local Terrain = workspace:WaitForChild("Terrain")
local Atmosphere = Lighting.Atmosphere
local Clouds = Terrain.Clouds
local Bloom = Lighting.Bloom
local Blur = Lighting.Blur
local CC = Lighting.ColorCorrection
local SR = Lighting.SunRays

local Ambient = Lighting.Ambient
local Brightness = Lighting.Brightness
local ExposureCompensation = Lighting.ExposureCompensation
local OutdoorAmbient = Lighting.OutdoorAmbient

local SetupFolder = Instance.new("Folder")
local LightingFolder = Instance.new("Folder")
local CloudFolder = Instance.new("Folder")

local am = Instance.new("Color3Value")
local br = Instance.new("NumberValue")
local ec = Instance.new("NumberValue")
local oa = Instance.new("Color3Value")
am.Name = "Ambient"
br.Name = "Brightness"
ec.Name = "ExposureCompensation"
oa.Name = "OutdoorAmbient"

local min,max = Instance.new("NumberValue"),Instance.new("NumberValue")
min.Name = "Min"
max.Name = "Max"

SetupFolder.Name = "New Weather Setup"
LightingFolder.Name = "Lighting"
CloudFolder.Name = "CloudCover"

SetupFolder.Parent = Lighting
LightingFolder.Parent = SetupFolder
CloudFolder.Parent = SetupFolder

am.Value = Ambient
br.Value = Brightness
ec.Value = ExposureCompensation
oa.Value = OutdoorAmbient

am.Parent = LightingFolder
br.Parent = LightingFolder
ec.Parent = LightingFolder
oa.Parent = LightingFolder

min.Parent = CloudFolder
max.Parent = CloudFolder

Atmosphere:Clone().Parent = SetupFolder
Clouds:Clone().Parent = SetupFolder
Bloom:Clone().Parent = SetupFolder
Blur:Clone().Parent = SetupFolder
CC:Clone().Parent = SetupFolder
SR:Clone().Parent = SetupFolder

warn("New Weather setup made, location: Lighting")