local repStore = game:GetService("ReplicatedStorage")
local shared = repStore:WaitForChild("Shared")

return require(shared:WaitForChild("Items"))