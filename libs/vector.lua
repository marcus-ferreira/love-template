--[[
	Author: Marcus Ferreira
	17/06/2025 - 0.1.3v - Initial
]]


---@class vector
local vector = {}

---@class Vector2
local Vector2 = {}
Vector2.__index = Vector2


---Creates a new 2D Vector.
---@param x? number
---@param y? number
---@return Vector2
function vector.newVector2(x, y)
	---@class Vector2
	local self = setmetatable({}, Vector2)
	self.x = x or 0
	self.y = y or 0
	return self
end

function Vector2:__add(v)
	return vector.newVector2(self.x + v.x, self.y + v.y)
end

function Vector2:__sub(v)
	return vector.newVector2(self.x - v.x, self.y - v.y)
end

function Vector2:__mul(scalar)
	return vector.newVector2(self.x * scalar, self.y * scalar)
end

function Vector2:__div(scalar)
	return vector.newVector2(self.x / scalar, self.y / scalar)
end

function Vector2:__tostring()
	return "Vector(" .. self.x .. ", " .. self.y .. ")"
end

function Vector2:magniture()
	return (self.x ^ 2 + self.y ^ 2) ^ 0.5
end

function Vector2:normalize()
	local mag = self:magniture()
	if mag > 0 then return self / mag end
	return vector.newVector2(0, 0)
end

function Vector2:dot(v)
	return self.x * v.x + self.y + v.y
end

return vector
