--[[
	Author: Marcus Ferreira
	Description: A collision library for LOVE.
]]


--- Library
---@class collider
local collider = {}


--- Classes
---@class Collider
---@field private x number The X position of the collider.
---@field private y number The Y position of the collider.
---@field private __index? table The index of the collider (for iterating).
local Collider = {}
Collider.__index = Collider

---@class Circle : Collider
---@field private x number The X position of the circle.
---@field private y number The Y position of the circle.
---@field private radius number The radius of the circle.
---@field private __index? table The index of the circle (for iterating).
local Circle = setmetatable({}, Collider)
Circle.__index = Circle

---@class Rectangle : Collider
---@field private x number The X position of the rectangle.
---@field private y number The Y position of the rectangle.
---@field private width number The width of the rectangle.
---@field private height number The height of the rectangle.
---@field private __index? table The index of the rectangle (for iterating).
local Rectangle = setmetatable({}, Collider)
Rectangle.__index = Rectangle


--- Methods
--- Creates a new Circle collider.
---@param x number # The X position of the circle.
---@param y number # The Y position of the circle.
---@param radius number # The radius of the circle.
---@return Circle # A new Circle collider.
function collider.newCircleCollider(x, y, radius)
	---@type Circle
	local self = {
		x = x,
		y = y,
		radius = radius
	}
	setmetatable(self, Circle)
	return self
end

---Creates a new Rectangle collider.
---@param x number # The X position of the rectangle.
---@param y number # The Y position of the rectangle.
---@param width number # The width of the rectangle.
---@param height number # The height of the rectangle.
---@return Rectangle # A new Rectangle collider.
function collider.newRectangleCollider(x, y, width, height)
	---@type Rectangle
	local self = {
		x = x,
		y = y,
		width = width,
		height = height
	}
	setmetatable(self, Rectangle)
	return self
end

---Gets the position of the collider.
---@return number x # The X position of the collider.
---@return number y # The Y position of the collider.
function Collider:getPosition()
	return self.x, self.y
end

---Sets the position of the collider.
---@param x number # The X position to move the collider to.
---@param y number # The Y position to move the collider to.
function Collider:setPosition(x, y)
	self.x = x
	self.y = y
end

---Draws the circle.
function Circle:draw()
	love.graphics.circle("line", self.x, self.y, self.radius)
end

---Gets the size of the circle.
---@return number # The radius of the circle.
function Circle:getSize()
	return self.radius
end

---Checks if the circle is colliding with another object.
---@param object Rectangle | Circle # The object to check collision with.
---@param x? number # The X position of the collision.
---@param y? number # The Y position of the collision.
---@return boolean # True if the circle is colliding with the object, false otherwise.
function Circle:isColliding(object, x, y)
	local class = getmetatable(object)
	assert(class == Rectangle or class == Circle, "Object must be a Rectangle or Circle.")

	local _x = x or 0
	local _y = y or 0
	local objectX, objectY = object:getPosition()

	if class == Rectangle then
		local objectWidth, objectHeight = object:getSize()
		local dx = self.x + _x - math.max(objectX, math.min(self.x + _x, objectX + objectWidth))
		local dy = self.y + _y - math.max(objectY, math.min(self.y + _y, objectY + objectHeight))
		return math.sqrt(dx ^ 2 + dy ^ 2) <= self.radius
	elseif class == Circle then
		local objectRadius = object:getSize()
		return ((objectX - self.x - _x) ^ 2 + (objectY - self.y - _y) ^ 2) ^ 0.5 <= self.radius + objectRadius
	end
	return false
end

---Sets the size of the circle.
---@param radius number # The radius to set for the circle.
function Circle:setSize(radius)
	self.radius = radius
end

---Draws the rectangle.
function Rectangle:draw()
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

---Gets the size of the rectangle.
---@return number width # The width of the rectangle.
---@return number height # The height of the rectangle.
function Rectangle:getSize()
	return self.width, self.height
end

---Checks if the rectangle is colliding with another object.
---@param object Rectangle | Circle # The object to check collision with.
---@param x? number # The X position of the collision.
---@param y? number # The Y position of the collision.
---@return boolean # True if the rectangle is colliding with the object, false otherwise.
function Rectangle:isColliding(object, x, y)
	local class = getmetatable(object)
	assert(class == Rectangle or class == Circle, "Object must be a Rectangle or Circle.")

	local _x = x or 0
	local _y = y or 0
	local objectX, objectY = object:getPosition()

	if class == Rectangle then
		local objectWidth, objectHeight = object:getSize()
		return self.x + _x <= objectX + objectWidth and
			self.y + _y <= objectY + objectHeight and
			self.x + self.width + _x >= objectX and
			self.y + self.height + _y >= objectY
	elseif class == Circle then
		local objectRadius = object:getSize()
		local dx = objectX - math.max(self.x + _x, math.min(objectX, self.x + self.width + _x))
		local dy = objectY - math.max(self.y + _y, math.min(objectY, self.y + self.height + _y))
		return math.sqrt(dx ^ 2 + dy ^ 2) <= objectRadius
	end
	return false
end

---Sets the size of the rectangle.
---@param width number # The width to set for the rectangle.
---@param height number	# The height to set for the rectangle.
function Rectangle:setSize(width, height)
	self.width = width
	self.height = height
end

return collider
