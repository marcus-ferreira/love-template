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

---@class CircleCollider : Collider
---@field private x number The X position of the circle.
---@field private y number The Y position of the circle.
---@field private radius number The radius of the circle.
---@field private __index? table The index of the circle (for iterating).
local CircleCollider = setmetatable({}, Collider)
CircleCollider.__index = CircleCollider

---@class RectangleCollider : Collider
---@field private x number The X position of the rectangle.
---@field private y number The Y position of the rectangle.
---@field private width number The width of the rectangle.
---@field private height number The height of the rectangle.
---@field private __index? table The index of the rectangle (for iterating).
local RectangleCollider = setmetatable({}, Collider)
RectangleCollider.__index = RectangleCollider


--- Methods
--- Creates a new Circle collider.
---@param x number The X position of the circle.
---@param y number The Y position of the circle.
---@param radius number The radius of the circle.
---@return CircleCollider A new Circle collider.
function collider.newCircleCollider(x, y, radius)
	---@type CircleCollider
	local self = {
		x = x,
		y = y,
		radius = radius
	}
	setmetatable(self, CircleCollider)
	return self
end

---Creates a new Rectangle collider.
---@param x number The X position of the rectangle.
---@param y number The Y position of the rectangle.
---@param width number The width of the rectangle.
---@param height number The height of the rectangle.
---@return RectangleCollider rectangleCollider A new Rectangle collider.
function collider.newRectangleCollider(x, y, width, height)
	---@type RectangleCollider
	local self = {
		x = x,
		y = y,
		width = width,
		height = height
	}
	setmetatable(self, RectangleCollider)
	return self
end

---Gets the position of the collider.
---@return number x The X position of the collider.
---@return number y The Y position of the collider.
function Collider:getPosition()
	return self.x, self.y
end

---Sets the position of the collider.
---@param x number The X position to move the collider to.
---@param y number The Y position to move the collider to.
function Collider:setPosition(x, y)
	self.x = x
	self.y = y
end

---Draws the circle.
function CircleCollider:draw()
	love.graphics.circle("line", self.x, self.y, self.radius)
end

---Gets the size of the circle.
---@return number radius The radius of the circle.
function CircleCollider:getSize()
	return self.radius
end

---Checks if the circle is colliding with another collider.
---@param other RectangleCollider | CircleCollider The collider to check collision with.
---@param x? number The X relative position of the collision.
---@param y? number The Y relative position of the collision.
---@return boolean isColliding True if the circle is colliding with the collider, false otherwise.
function CircleCollider:isColliding(other, x, y)
	local otherClass = getmetatable(other)
	assert(otherClass == RectangleCollider or otherClass == CircleCollider,
		"Other collider must be a RectangleCollider or CircleCollider.")

	local _x = x or 0
	local _y = y or 0
	local otherX, otherY = other:getPosition()

	if otherClass == RectangleCollider then
		local colliderWidth, colliderHeight = other:getSize()
		local dx = self.x + _x - math.max(otherX, math.min(self.x + _x, otherX + colliderWidth))
		local dy = self.y + _y - math.max(otherY, math.min(self.y + _y, otherY + colliderHeight))
		return math.sqrt(dx ^ 2 + dy ^ 2) <= self.radius
	elseif otherClass == CircleCollider then
		local colliderRadius = other:getSize()
		return ((otherX - self.x - _x) ^ 2 + (otherY - self.y - _y) ^ 2) ^ 0.5 <= self.radius + colliderRadius
	end
	return false
end

---Sets the size of the circle.
---@param radius number The radius to set for the circle.
function CircleCollider:setSize(radius)
	self.radius = radius
end

---Draws the rectangle.
function RectangleCollider:draw()
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

---Gets the size of the rectangle.
---@return number width The width of the rectangle.
---@return number height The height of the rectangle.
function RectangleCollider:getSize()
	return self.width, self.height
end

---Checks if the rectangle is colliding with another collider.
---@param other RectangleCollider | CircleCollider The collider to check collision with.
---@param x? number The X relative position of the collision.
---@param y? number The Y relative position of the collision.
---@return boolean isColliding True if the rectangle is colliding with the collider, false otherwise.
function RectangleCollider:isColliding(other, x, y)
	local otherClass = getmetatable(other)
	assert(otherClass == RectangleCollider or otherClass == CircleCollider,
		"Other collider must be a RectangleCollider or CircleCollider.")

	local _x = x or 0
	local _y = y or 0
	local otherX, otherY = other:getPosition()

	if otherClass == RectangleCollider then
		local colliderWidth, colliderHeight = other:getSize()
		return self.x + _x <= otherX + colliderWidth and
			self.y + _y <= otherY + colliderHeight and
			self.x + self.width + _x >= otherX and
			self.y + self.height + _y >= otherY
	elseif otherClass == CircleCollider then
		local colliderRadius = other:getSize()
		local dx = otherX - math.max(self.x + _x, math.min(otherX, self.x + self.width + _x))
		local dy = otherY - math.max(self.y + _y, math.min(otherY, self.y + self.height + _y))
		return math.sqrt(dx ^ 2 + dy ^ 2) <= colliderRadius
	end
	return false
end

---Sets the size of the rectangle.
---@param width number The width to set for the rectangle.
---@param height number	The height to set for the rectangle.
function RectangleCollider:setSize(width, height)
	self.width = width
	self.height = height
end

return collider
