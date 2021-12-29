local http = game:GetService("HttpService")

function isNumber(t)
	if tonumber(t) then
		return true
	else
		return false
	end
end

local module = {}
	function module.generate(itemType : number,itemCreated : number,whoCreatedItem : string,uid : number)
		local guid = http:GenerateGUID(false)
		local Tick = tick()
		
		local numbers = {}
		local letters = {}
		
		local realLength = 0
		local dashCount = 0
		
		for i = 1,#guid do
			local t = string.sub(guid,i,i)
			
			if isNumber(t) then
				local r = math.random(1,#t)
				table.insert(numbers,tonumber(t)*string.sub(Tick,r,r))
				
			elseif t ~= "-" then
				table.insert(letters,t)
				
			else
				dashCount += 1
			end
		end
		local finalGuid = ""
		
		for i = 1,#guid do
			local t = string.sub(guid,i,i)
			if isNumber(t) then
				local n = math.random(1,#numbers)
				finalGuid = finalGuid..numbers[n]
				realLength += 1
			elseif t ~= "-" then
				local l = math.random(1,#letters)
				finalGuid = finalGuid..letters[l]
				realLength += 1
			end
		end
		
		local spacing = realLength / dashCount
		local splits = {}
		local last = 1
		
		for i = 1,realLength do
			if i == (last+spacing)-1 then
				table.insert(splits,string.sub(finalGuid,last,i))
				last = i
			end
		end
		finalGuid = ""
		for i,v in pairs(splits) do
			if i ~= #splits then
				finalGuid = finalGuid..v.."-"
			else
				finalGuid = finalGuid..v
			end
		end
		
		local serial = finalGuid
		serial = serial.."//|IT: "..itemType.."|TC: "..itemCreated.."|WC: "..whoCreatedItem.."|UID: "..uid
		
		return serial
	end
return module
