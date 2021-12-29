local module = {
	["Inventorys"] = {
		
	}
}
 
function module.addInventory(uid,inv)
	module.Inventorys[uid] = inv
end
function module.removeInventory(uid)
	module.Inventorys[uid] = nil
end
function module.getInventory(uid)
	return module.Inventorys[uid]
end
return module
