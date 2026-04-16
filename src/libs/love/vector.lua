--[[
	Author: Marcus Ferreira
	Description: A vector library for LOVE.
]]


--- Library
---@class vector
local vector = {}


--- Classes
---@class Vector2
---@field private x number The X component of the vector.
---@field private y number The Y component of the vector.
---@field private __index? table The index of the vector (for iterating).
local Vector2 = {}
Vector2.__index = Vector2


--- Methods
---Creates a new Vector2 object.
---@param x? number # The X component of the vector.
---@param y? number # The Y component of the vector.
---@return Vector2 # A new Vector2 object.
function vector.newVector2(x, y)
	---@class Vector2
	local self = {
		x = x or 0,
		y = y or 0
	}
	setmetatable(self, Vector2)
	return self
end

---Gets the X component of the vector.
---@return number # The X component of the vector.
function Vector2:getX()
	return self.x
end

---Gets the Y component of the vector.
---@return number # The Y component of the vector.
function Vector2:getY()
	return self.y
end

---Gets the distance between two vectors.
---@param v Vector2 # The vector to calculate the distance to.
---@return number # The distance between the two vectors.
function Vector2:getDistance(v)
	local dx = self.x - v:getX()
	local dy = self.y - v:getY()
	return (dx ^ 2 + dy ^ 2) ^ 0.5
end

---Adds two vectors together.
---@param v Vector2 # The vector to add.
---@return Vector2 # The result of the addition.
function Vector2:__add(v)
	return vector.newVector2(self.x + v:getX(), self.y + v:getY())
end

---Subtracts one vector from another.
---@param v Vector2 # The vector to subtract.
---@return Vector2 # The result of the subtraction.
function Vector2:__sub(v)
	return vector.newVector2(self.x - v:getX(), self.y - v:getY())
end

---Multiplies the vector by a scalar.
---@param scalar number # The scalar to multiply by.
---@return Vector2 # The result of the multiplication.
function Vector2:__mul(scalar)
	return vector.newVector2(self.x * scalar, self.y * scalar)
end

---Divides the vector by a scalar.
---@param scalar number # The scalar to divide by.
---@return Vector2 # The result of the division.
function Vector2:__div(scalar)
	return vector.newVector2(self.x / scalar, self.y / scalar)
end

---Prints the vector as a string.
---@return string # A string representation of the vector.
function Vector2:__tostring()
	return "Vector(" .. self.x .. ", " .. self.y .. ")"
end

---Gets the magnitude of the vector.
---@return number # The magnitude of the vector.
function Vector2:magnitude()
	return (self.x ^ 2 + self.y ^ 2) ^ 0.5
end

---Gets the normalized version of the vector.
---@return Vector2 # The normalized vector.
function Vector2:normalize()
	local mag = self:magnitude()
	if mag > 0 then return self / mag end
	return vector.newVector2(0, 0)
end

---Calculates the dot product of the vector with another vector.
---@param v Vector2 # The vector to calculate the dot product with.
---@return number # The dot product of the two vectors.
function Vector2:dot(v)
	return self.x * v:getX() + self.y * v:getY()
end

--- Calculates the cross product of the vector with another vector.
---@param v Vector2 # The vector to calculate the cross product with.
---@return number # The cross product of the two vectors.
function Vector2:cross(v)
	return self.x * v:getY() - self.y * v:getX()
end

return vector
