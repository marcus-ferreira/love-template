--[[
	Author: Marcus Ferreira
	Description: A collision library for LOVE.
]]


--- Imports
local vector = require("src.libs.love.vector")


--- Library
---@class collider
local collider = {}


--- Classes
---@class Collider
---@field private position Vector2 The vector2 of the position of the collider.
---@field private velocity Vector2 The vector2 of the velocity of the collider.
---@field private __index? table The index of the collider (for iterating).
local Collider = {}
Collider.__index = Collider

---@class CircleCollider : Collider
---@field private position Vector2 The vector2 of the position of the circle collider.
---@field private velocity Vector2 The vector2 of the velocity of the circle collider.
---@field private radius number The radius of the circle.
---@field private __index? table The index of the circle (for iterating).
local CircleCollider = setmetatable({}, Collider)
CircleCollider.__index = CircleCollider

---@class RectangleCollider : Collider
---@field private position Vector2 The vector2 of the position of the rectangle collider.
---@field private velocity Vector2 The vector2 of the velocity of the rectangle collider.
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
		position = vector.newVector2(x, y),
		velocity = vector.newVector2(),
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
		position = vector.newVector2(x, y),
		velocity = vector.newVector2(),
		width = width,
		height = height
	}
	setmetatable(self, RectangleCollider)
	return self
end

---Gets the position of the collider.
---@return Vector2 position The vector2 of the position of the collider.
function Collider:getPosition()
	return self.position
end

---Gets the velocity of the collider.
---@return Vector2 velocity The vector2 of the velocity of the collider.
function Collider:getVelocity()
	return self.velocity
end

---Sets the position of the collider.
---@param vector2 Vector2 The vector2 of the new position of the collider.
function Collider:setPosition(vector2)
	self.position = vector2
end

---Sets the velocity of the collider.
---@param vector2 Vector2 The vector2 of the new velocity of the collider.
function Collider:setVelocity(vector2)
	self.velocity = vector2
end

---Draws the circle.
function CircleCollider:draw()
	love.graphics.circle("line", self.position:getX(), self.position:getY(), self.radius)
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
	local otherPosition = other:getPosition()

	if otherClass == RectangleCollider then
		local colliderWidth, colliderHeight = other:getSize()
		local dx = self.position:getX() + _x -
			math.max(otherPosition:getX(), math.min(self.position:getX() + _x, otherPosition:getX() + colliderWidth))
		local dy = self.position:getY() + _y -
			math.max(otherPosition:getY(), math.min(self.position:getY() + _y, otherPosition:getY() + colliderHeight))
		return math.sqrt(dx ^ 2 + dy ^ 2) <= self.radius
	elseif otherClass == CircleCollider then
		local colliderRadius = other:getSize()
		return ((otherPosition:getX() - self.position:getX() - _x) ^ 2 + (otherPosition:getY() - self.position:getY() - _y) ^ 2) ^
			0.5 <= self.radius + colliderRadius
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
	love.graphics.rectangle("line", self.position:getX(), self.position:getY(), self.width, self.height)
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
	local otherPosition = other:getPosition()

	if otherClass == RectangleCollider then
		local colliderWidth, colliderHeight = other:getSize()
		return self.position:getX() + _x <= otherPosition:getX() + colliderWidth and
			self.position:getY() + _y <= otherPosition:getY() + colliderHeight and
			self.position:getX() + self.width + _x >= otherPosition:getX() and
			self.position:getY() + self.height + _y >= otherPosition:getY()
	elseif otherClass == CircleCollider then
		local colliderRadius = other:getSize()
		local dx = otherPosition:getX() -
			math.max(self.position:getX() + _x, math.min(otherPosition:getX(), self.position:getX() + self.width + _x))
		local dy = otherPosition:getY() -
			math.max(self.position:getY() + _y, math.min(otherPosition:getY(), self.position:getY() + self.height + _y))
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
