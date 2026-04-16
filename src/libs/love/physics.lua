--[[
	Author: Marcus Ferreira
	Description: A physics library for LOVE.
]]


---@class physics
physics = {}


---@class RectangleCollider
---@field private body love.Body The physics body of the collider.
---@field private shape love.PolygonShape The shape of the collider.
---@field private fixture love.Fixture The fixture of the collider.
---@field private __index? number The index of the rectangle collider (for iterating).
RectangleCollider = {}
RectangleCollider.__index = RectangleCollider

---Creates a new RectangleCollider object.
---@param world love.World # The physics world to which the collider belongs.
---@param x number # The X coordinate of the collider.
---@param y number # The Y coordinate of the collider.
---@param type love.BodyType # The type of the collider.
---@param width number # The width of the collider.
---@param height number # The height of the collider.
---@return RectangleCollider # A new RectangleCollider object.
function physics.newRectangleCollider(world, x, y, width, height, type)
	local body = love.physics.newBody(world, x, y, type)
	local shape = love.physics.newRectangleShape(width, height)
	local fixture = love.physics.newFixture(body, shape)

	---@type RectangleCollider
	local self = {
		body = body,
		shape = shape,
		fixture = fixture
	}
	setmetatable(self, RectangleCollider)
	return self
end

---Setups the collider.
function RectangleCollider:setupCollider()
	self.body:setFixedRotation(true)
	self.fixture:setFriction(0)
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

---Gets the height of the rectangle collider.
---@return number height
function RectangleCollider:getHeight()
	local _, height = self:getSize()
	return height
end

---Gets the width of the rectangle collider.
---@return number width
function RectangleCollider:getWidth()
	local width, _ = self:getSize()
	return width
end

---@class CircleCollider
---@field private body love.Body The physics body of the collider.
---@field private shape love.CircleShape The shape of the collider.
---@field private fixture love.Fixture The fixture of the collider.
---@field private __index? number The index of the circle collider (for iterating).
CircleCollider = {}
CircleCollider.__index = CircleCollider

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

	---@type CircleCollider
	local self = {
		body = body,
		shape = shape,
		fixture = fixture
	}
	setmetatable(self, CircleCollider)
	return self
end

---Draws the circle collider.
function CircleCollider:draw()
	love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
end

function CircleCollider:setupCollider()
	self.body:setFixedRotation(true)
	self.fixture:setFriction(0)
end
