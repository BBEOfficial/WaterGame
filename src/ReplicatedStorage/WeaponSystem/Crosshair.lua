local players = game:GetService("Players")
local lp = players.LocalPlayer

local CHG = lp.PlayerGui:WaitForChild("WeaponGui")
local CHF = CHG:WaitForChild("CrosshairFrame")

function changeCrosshairColor(info,color)
	for i,v in pairs(info) do
		if i ~= "MainFrame" then
			v.BackgroundColor3 = color
		end
	end
end

function changeCrosshairPositions(info,positions)
	for i,v in pairs(positions) do
		local s,e = pcall(function()
			info[i].Position = v
		end)
		
		if s == false then
			warn("Issue with crosshair positioning "..e.." ||",positions)
		end
	end
end

local module = {}
module.__index = module

	function module.new(crosshairColor,startingPositions)
		
		--[[ default crosshair positions
			{
				["Top"] = UDim2.new(0, 50,0, 13),
				["Bottom"] = UDim2.new(0, 50,0, 88),
				["Left"] = UDim2.new(0, 13,0, 50),
				["Right"] = UDim2.new(0, 88,0, 50),
			}
		]]
		
		assert(typeof(crosshairColor) == "Color3" , "Cross hair color has to be a color3 value")
		assert(typeof(startingPositions) == "table", "Starting positions has to be formated in a table")
		
		local frame = CHF
		frame.Parent = CHG
		
		local mt = {
			crossHairInfo = {
				["Top"] = frame.Top,
				["Bottom"] = frame.Btm,
				["Left"] = frame.Left,
				["Right"] = frame.Right,
				["MainFrame"] = frame
			},
		}
		
		frame.Visible = false 
		
		changeCrosshairColor(mt.crossHairInfo,crosshairColor)
		changeCrosshairPositions(mt.crossHairInfo,startingPositions)
		
		setmetatable(mt,module)
		
		return mt
	end
	
	function module:ChangeCrosshairVisibility(transparency : number)
		assert(typeof(transparency) == "number", "Transparency has to be a number")

		if transparency > 0 then
			self.crossHairInfo.MainFrame.Visible = true
			
			for i,v in pairs(self.crossHairInfo) do
				if i ~= "MainFrame" then
					v.BackgroundTransparency = transparency
				end
			end
		elseif transparency == 0 then
			self.crossHairInfo.MainFrame.Visible = false
		end
			
	end
	
	function module:ChangeCrosshairColor(color : BrickColor)
		assert(typeof(color) == "Color3" , "Cross hair color has to be a color3 value")
		
		changeCrosshairColor(self.crossHairInfo,color)
	end
	
	function module:Destroy()
		self.crossHairInfo.MainFrame:Destroy()
	end
return module
