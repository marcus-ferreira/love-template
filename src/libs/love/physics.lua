--[[
	Author: Marcus Ferreira
	Description: A physics library for LOVE.
]]


--- Library
local physics = {}


--- Classes
---@class Collider
---@field private body love.Body The physics body of the collider.
---@field private fixture love.Fixture The fixture of the collider.
---@field private __index? table The index of the collider (for iterating).
local Collider = {}
Collider.__index = Collider

---@class RectangleCollider : Collider
---@field private body love.Body The physics body of the collider.
---@field private shape love.PolygonShape The shape of the collider.
---@field private fixture love.Fixture The fixture of the collider.
---@field private __index? table The index of the rectangle collider (for iterating).
local RectangleCollider = setmetatable({}, Collider)
RectangleCollider.__index = RectangleCollider

---@class CircleCollider : Collider
---@field private body love.Body The physics body of the collider.
---@field private shape love.CircleShape The shape of the collider.
---@field private fixture love.Fixture The fixture of the collider.
---@field private __index? table The index of the circle collider (for iterating).
local CircleCollider = setmetatable({}, Collider)
CircleCollider.__index = CircleCollider


--- Methods
---Creates a new RectangleCollider object.
---@param world love.World # The physics world to which the collider belongs.
---@param x number # The X coordinate of the collider.
---@param y number # The Y coordinate of the collider.
---@param width number # The width of the collider.
---@param height number # The height of the collider.
---@param type love.BodyType # The type of the collider.
---@return RectangleCollider # A new RectangleCollider object.
function physics.newRectangleCollider(world, x, y, width, height, type)
	local body = love.physics.newBody(world, x, y, type)
	local shape = love.physics.newRectangleShape(width, height)
	local fixture = love.physics.newFixture(body, shape)
	body:setFixedRotation(true)
	fixture:setFriction(0)

	---@type RectangleCollider
	local self = {
		body = body,
		shape = shape,
		fixture = fixture
	}
	setmetatable(self, RectangleCollider)
	return self
end

---Creates a new CircleCollider object.
---@param world love.World # The physics world to which the collider belongs.
---@param x number # The X coordinate of the collider.
---@param y number # The Y coordinate of the collider.
---@param radius number # The radius of the collider.
---@param type love.BodyType # The type of the collider. Default = "static".
---@return CircleCollider # A new CircleCollider object.
function physics.newCircleCollider(world, x, y, radius, type)
	local body = love.physics.newBody(world, x, y, type)
	local shape = love.physics.newCircleShape(radius)
	local fixture = love.physics.newFixture(body, shape)
	body:setFixedRotation(true)
	fixture:setFriction(0)

	---@type CircleCollider
	local self = {
		body = body,
		shape = shape,
		fixture = fixture
	}
	setmetatable(self, CircleCollider)
	return self
end

---Draws the rectangle collider.
function RectangleCollider:draw()
	love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
end

---Gets the size of the rectangle collider.
---@return number width # The collider width.
---@return number height # The collider height.
function RectangleCollider:getSize()
	local x1, y1, x2, _, _, _, _, y4 = self.body:getWorldPoints(self.shape:getPoints())
	local width = x2 - x1
	local height = y4 - y1
	return width, height
end

---Gets the width of the rectangle collider.
---@return number width
function RectangleCollider:getWidth()
	local width, _ = self:getSize()
	return width
end

---Gets the height of the rectangle collider.
---@return number height
function RectangleCollider:getHeight()
	local _, height = self:getSize()
	return height
end

---Draws the circle collider.
function CircleCollider:draw()
	love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
end

return physics
