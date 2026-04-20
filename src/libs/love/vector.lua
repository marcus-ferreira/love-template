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
---@param x? number The X component of the vector.
---@param y? number The Y component of the vector.
---@return Vector2 vector2 A new Vector2 object.
function vector.newVector2(x, y)
	---@class Vector2
	local self = {
		x = x or 0,
		y = y or 0
	}
	setmetatable(self, Vector2)
	return self
end

---Adds two vectors together.
---@param v Vector2 The vector to add.
---@return Vector2 vector2 The vector result of the addition.
function Vector2:__add(v)
	return vector.newVector2(self.x + v:getX(), self.y + v:getY())
end

---Subtracts one vector from another.
---@param v Vector2 The vector or scalar to subtract.
---@return Vector2 vector2 The vector result of the subtraction.
function Vector2:__sub(v)
	return vector.newVector2(self.x - v:getX(), self.y - v:getY())
end

---Multiplies the vector by a scalar.
---@param scalar number The scalar to multiply by.
---@return Vector2 vector2 The vector result of the multiplication.
function Vector2:__mul(scalar)
	return vector.newVector2(self.x * scalar, self.y * scalar)
end

---Divides the vector by a scalar.
---@param scalar number The scalar to divide by.
---@return Vector2 vector2 The vector result of the division.
function Vector2:__div(scalar)
	return vector.newVector2(self.x / scalar, self.y / scalar)
end

---Returns the vector as a string.
---@return string string A string representation of the vector.
function Vector2:__tostring()
	return "Vector(" .. self.x .. ", " .. self.y .. ")"
end

---Gets the absolute value of the vector.
---@return Vector2 abs The absolute value vector.
function Vector2:abs()
	return vector.newVector2(math.abs(self.x), math.abs(self.y))
end

--- Calculates the cross product of the vector with another vector.
---@param v Vector2 The vector to calculate the cross product with.
---@return number cross The cross product of the two vectors.
function Vector2:cross(v)
	return self.x * v:getY() - self.y * v:getX()
end

---Calculates the dot product of the vector with another vector.
---@param v Vector2 The vector to calculate the dot product with.
---@return number dot The dot product of the two vectors.
function Vector2:dot(v)
	return self.x * v:getX() + self.y * v:getY()
end

---Gets the coordinates of the vector.
---@return number x The X coordinate of the vector.
---@return number y The Y coordinate of the vector.
function Vector2:getCoordinates()
	return self.x, self.y
end

---Gets the distance between two vectors.
---@param v Vector2 The vector to calculate the distance to.
---@return number distance The distance between the two vectors.
function Vector2:getDistance(v)
	local dx = self.x - v:getX()
	local dy = self.y - v:getY()
	return math.sqrt((dx * dx) + (dy * dy))
end

---Gets the X component of the vector.
---@return number x The X component of the vector.
function Vector2:getX()
	return self.x
end

---Gets the Y component of the vector.
---@return number y The Y component of the vector.
function Vector2:getY()
	return self.y
end

---Gets the square of the lenght of the vector.
---@return number lenSq The square of the lenght of the vector.
function Vector2:lenSq()
	return (self.x * self.x) + (self.y * self.y)
end

---Gets the magnitude of the vector.
---@return number magnitude The magnitude of the vector.
function Vector2:magnitude()
	local selfSq = self:lenSq()
	return math.sqrt(selfSq.x + selfSq.y)
end

---Gets the normalized version of the vector.
---@return Vector2 nomalizedVector The normalized vector.
function Vector2:normalize()
	local mag = self:magnitude()
	if mag > 0 then
		return self / mag
	end
	return vector.newVector2(0, 0)
end

---Sets the coordinates of the vector.
---@param x number The new value of the X coordinate.
---@param y number The new value of the Y coordinate.
function Vector2:setCoordinates(x, y)
	self.x = x
	self.y = y
end

---Sets a new value to the X coordinate.
---@param value number The new X coordinate value.
function Vector2:setX(value)
	self.x = value
end

---Sets a new value to the Y coordinate.
---@param value number The new Y coordinate value.
function Vector2:setY(value)
	self.y = value
end

return vector
