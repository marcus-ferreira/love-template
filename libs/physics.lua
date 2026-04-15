--[[
	Author: Marcus Ferreira
	12/01/2026 - 0.3v   - Changes physics to love
	18/10/2024 - 0.2.0v - Initial
]]


---@class RectangleCollider
RectangleCollider = {}
RectangleCollider.__index = RectangleCollider

---@class CircleCollider
CircleCollider = {}
CircleCollider.__index = CircleCollider


---@param world love.World
---@param x number
---@param y number
---@param type love.BodyType
---@param width number
---@param height number
---@return RectangleCollider
function love.physics.newRectangleCollider(world, x, y, width, height, type)
	---@class RectangleCollider
	local self   = setmetatable({}, RectangleCollider)
	self.body    = love.physics.newBody(world, x, y, type)
	self.shape   = love.physics.newRectangleShape(width, height)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.body:setFixedRotation(true)
	self.fixture:setFriction(0)
	return self
end

---@param world love.World
---@param x number
---@param y number
---@param radius number
---@param type? love.BodyType
---@return CircleCollider
function love.physics.newCircleCollider(world, x, y, radius, type)
	---@class CircleCollider
	local self   = setmetatable({}, CircleCollider)
	self.body    = love.physics.newBody(world, x, y, type or "static")
	self.shape   = love.physics.newCircleShape(radius)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.body:setFixedRotation(true)
	self.fixture:setFriction(0)
	return self
end

function RectangleCollider:draw()
	love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
end

---@return number width # The collider width.
---@return number height # The collider height.
function RectangleCollider:getSize()
	local x1, y1, x2, _, _, _, _, y4 = self.body:getWorldPoints(self.shape:getPoints())
	local width                      = x2 - x1
	local height                     = y4 - y1
	return width, height
end

---@return number width
function RectangleCollider:getWidth()
	local width, _ = self:getSize()
	return width
end

---@return number height
function RectangleCollider:getHeight()
	local _, height = self:getSize()
	return height
end

function CircleCollider:draw()
	love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
end
