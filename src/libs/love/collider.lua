--[[
	Author: Marcus Ferreira
	Description: A collision library for LOVE.
]]


--- Library
---@class collider
local collider = {}


--- Classes
---@class Rectangle
---@field private x number The X position of the rectangle.
---@field private y number The Y position of the rectangle.
---@field private width number The width of the rectangle.
---@field private height number The height of the rectangle.
---@field private __index? table The index of the rectangle (for iterating).
local RectangleCollider = {}
RectangleCollider.__index = RectangleCollider

---@class Circle
---@field private x number The X position of the circle.
---@field private y number The Y position of the circle.
---@field private radius number The radius of the circle.
---@field private __index? table The index of the circle (for iterating).
local CircleCollider = {}
CircleCollider.__index = CircleCollider


--- Methods
---Creates a new Rectangle object.
---@param x number # The X position of the rectangle.
---@param y number # The Y position of the rectangle.
---@param width number # The width of the rectangle.
---@param height number # The height of the rectangle.
---@return Rectangle # A new Rectangle object.
function collider.newRectangleCollider(x, y, width, height)
	---@type Rectangle
	local self = {
		x = x,
		y = y,
		width = width,
		height = height
	}
	setmetatable(self, RectangleCollider)
	return self
end

---Gets the position of the rectangle.
---@return number # The X position of the rectangle.
---@return number # The Y position of the rectangle.
function RectangleCollider:getPosition()
	return self.x, self.y
end

---Gets the size of the rectangle.
---@return number width # The width of the rectangle.
---@return number height # The height of the rectangle.
function RectangleCollider:getSize()
	return self.width, self.height
end

---Checks if the rectangle is colliding with another object.
---@param object Rectangle | Circle # The object to check collision with.
---@param x? number # The X position of the rectangle.
---@param y? number # The Y position of the rectangle.
---@return boolean # True if the rectangle is colliding with the object, false otherwise.
function RectangleCollider:isColliding(object, x, y)
	local class = getmetatable(object)
	assert(class == RectangleCollider or class == CircleCollider, "Object must be a RectangleCollider or CircleCollider.")
	local _x = x or 0
	local _y = y or 0
	local objectX, objectY = object:getPosition()

	if class == RectangleCollider then
		local objectWidth, objectHeight = object:getSize()
		return self.x + _x <= objectX + objectWidth and
			self.y + _y <= objectY + objectHeight and
			self.x + self.width + _x >= objectX and
			self.y + self.height + _y >= objectY
	elseif class == CircleCollider then
		local objectRadius = object:getSize()
		local dx = objectX - math.max(self.x + _x, math.min(objectX, self.x + self.width + _x))
		local dy = objectY - math.max(self.y + _y, math.min(objectY, self.y + self.height + _y))
		return math.sqrt(dx ^ 2 + dy ^ 2) <= objectRadius
	end
	return false
end

---Draws the rectangle.
function RectangleCollider:draw()
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

--- Creates a new Circle object.
---@param x number # The X position of the circle.
---@param y number # The Y position of the circle.
---@param radius number # The radius of the circle.
---@return Circle # A new Circle object.
function collider.newCircleCollider(x, y, radius)
	---@type Circle
	local self = {
		x = x,
		y = y,
		radius = radius
	}
	setmetatable(self, CircleCollider)
	return self
end

---Gets the position of the circle.
---@return number # The X position of the circle.
---@return number # The Y position of the circle.
function CircleCollider:getPosition()
	return self.x, self.y
end

---Gets the size of the circle.
---@return number # The radius of the circle.
function CircleCollider:getSize()
	return self.radius
end

---Checks if the circle is colliding with another object.
---@param object Rectangle | Circle # The object to check collision with.
---@param x? number # The X position of the circle.
---@param y? number # The Y position of the circle.
---@return boolean # True if the circle is colliding with the object, false otherwise.
function CircleCollider:isColliding(object, x, y)
	local class = getmetatable(object)
	assert(class == RectangleCollider or class == CircleCollider, "Object must be a RectangleCollider or CircleCollider.")
	local _x = x or 0
	local _y = y or 0
	local objectX, objectY = object:getPosition()

	if class == RectangleCollider then
		local objectWidth, objectHeight = object:getSize()
		local dx = self.x + _x - math.max(objectX, math.min(self.x + _x, objectX + objectWidth))
		local dy = self.y + _y - math.max(objectY, math.min(self.y + _y, objectY + objectHeight))
		return math.sqrt(dx ^ 2 + dy ^ 2) <= self.radius
	elseif class == CircleCollider then
		local objectRadius = object:getSize()
		return ((objectX - self.x - _x) ^ 2 + (objectY - self.y - _y) ^ 2) ^ 0.5 <= self.radius + objectRadius
	end
	return false
end

---Draws the circle.
function CircleCollider:draw()
	love.graphics.circle("line", self.x, self.y, self.radius)
end

return collider
