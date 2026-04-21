--[[
	Author: Marcus Ferreira
	Description: A physics library for LOVE.
]]


--- Imports
local vector = require("src.libs.love.vector")


--- Library
---@class physics
local physics = {}


--- Classes
---@class World
---@field private world love.World The world.
---@field private colliders (CircleCollider|RectangleCollider)[] The colliders of the world.
---@field private __index? table The index of the world (for iterating).
local World = {}
World.__index = World
World.__class = "World"

---@class Collider
---@field protected body love.Body The body of the Collider.
---@field protected shape love.CircleShape|love.PolygonShape The shape of the Collider.
---@field protected fixture love.Fixture The fixture of the Collider.
---@field private __index? table The index of the Collider (for iterating).
local Collider = {}
Collider.__index = Collider
Collider.__class = "Collider"

---@class CircleCollider : Collider
---@field protected body love.Body The body of the CircleCollider.
---@field protected shape love.CircleShape The shape of the CircleCollider.
---@field protected fixture love.Fixture The fixture of the CircleCollider.
---@field private __index? table The index of the CircleCollider (for iterating).
local CircleCollider = setmetatable({}, Collider)
CircleCollider.__index = CircleCollider
CircleCollider.__class = "CircleCollider"

---@class RectangleCollider : Collider
---@field protected body love.Body The physics body of the RectangleCollider.
---@field protected shape love.PolygonShape The shape of the RectangleCollider.
---@field protected fixture love.Fixture The fixture of the RectangleCollider.
---@field private __index? table The index of the RectangleCollider (for iterating).
local RectangleCollider = setmetatable({}, Collider)
RectangleCollider.__index = RectangleCollider
RectangleCollider.__class = "RectangleCollider"


--- Methods
---Creates a world.
---@param xg? number The x component of gravity.
---@param yg? number The y component of gravity.
---@param sleep? boolean Whether the bodies in this world are allowed to sleep.
---@return World world A new World object.
function physics.newWorld(xg, yg, sleep)
    ---@type World
    local self = {
        world = love.physics.newWorld(xg, yg, sleep),
        colliders = {}
    }
    setmetatable(self, World)
    return self
end

---Creates a new CircleCollider object.
---@param world love.World The world to which the CircleCollider belongs.
---@param x number The X coordinate of the CircleCollider.
---@param y number The Y coordinate of the CircleCollider.
---@param radius number The radius of the CircleCollider.
---@param type love.BodyType The type of the CircleCollider.
---@return CircleCollider circleCollider A new CircleCollider object.
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
        fixture = fixture,
    }
    setmetatable(self, CircleCollider)
    return self
end

---Creates a new RectangleCollider object.
---@param world love.World The world to which the RectangleCollider belongs.
---@param x number The X coordinate of the RectangleCollider.
---@param y number The Y coordinate of the RectangleCollider.
---@param width number The width of the RectangleCollider.
---@param height number The height of the RectangleCollider.
---@param type love.BodyType The type of the body of the RectangleCollider.
---@return RectangleCollider rectangleCollider A new RectangleCollider object.
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

---Adds a new CircleCollider object in the world.
---@param x number The X position of the CircleCollider.
---@param y number The Y position of the CircleCollider.
---@param radius number The radius of the CircleCollider.
---@param type love.BodyType The type of the body of the CircleCollider.
function World:addNewCircleCollider(x, y, radius, type)
    table.insert(self.colliders, physics.newCircleCollider(self.world, x, y, radius, type))
end

---Adds a new RectangleCollider object in the world.
---@param x number The X coordinate of the RectangleCollider.
---@param y number The Y coordinate of the RectangleCollider.
---@param width number The width of the RectangleCollider.
---@param height number The height of the RectangleCollider.
---@param type love.BodyType The type of the body of the RectangleCollider.
function World:addNewRectangleCollider(x, y, width, height, type)
    table.insert(self.colliders, physics.newRectangleCollider(self.world, x, y, width, height, type))
end

---Draws the colliders of the world.
function World:drawColliders()
    for _, collider in ipairs(self.colliders) do
        collider:draw()
    end
end

---Gets the collider given its index.
---@param index number The index of the collider.
---@return CircleCollider|RectangleCollider collider The Collider object.
function World:getCollider(index)
    return self.colliders[index]
end

---Gets the colliders of the world.
---@return (CircleCollider|RectangleCollider)[] colliders The table of colliders of the world.
function World:getColliders()
    return self.colliders
end

---Gets the world.
---@return love.World world The World.
function World:getWorld()
    return self.world
end

---Removes a collider of the world.
---@param index number The index of the collider.
function World:removeCollider(index)
    table.remove(self.colliders, index)
end

---Update the state of the World.
---@param dt number The time (in seconds) to advance the physics simulation.
---@param velocityiterations? number The maximum number of steps used to determine the new velocities when resolving a collision.
---@param positioniterations? number The maximum number of steps used to determine the new positions when resolving a collision.
function World:update(dt, velocityiterations, positioniterations)
    self.world:update(dt, velocityiterations, positioniterations)
end

---Gets the body of the Collider.
---@return love.Body body The body of the Collider.
function Collider:getBody()
    return self.body
end

---Gets the fixture of the Collider.
---@return love.Fixture fixture The fixture of the Collider.
function Collider:getFixture()
    return self.fixture
end

---Draws the CircleCollider.
function CircleCollider:draw()
    love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
end

---Gets the shape of the CircleCollider.
---@return love.CircleShape circleShape The shape of the CircleCollider.
function CircleCollider:getShape()
    return self.shape
end

---Draws the RectangleCollider.
function RectangleCollider:draw()
    love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
end

---Gets the height of the RectangleCollider.
---@return number height The height of the RectangleCollider.
function RectangleCollider:getHeight()
    local _, height = self:getSize()
    return height
end

---Gets the shape of the RectangleCollider.
---@return love.PolygonShape polygonShape The shape of the RectangleCollider.
function RectangleCollider:getShape()
    return self.shape
end

---Gets the size of the RectangleCollider.
---@return number width The width of the RectangleCollider.
---@return number height The height of the RectangleCollider.
function RectangleCollider:getSize()
    local x1, y1, x2, _, _, _, _, y4 = self.body:getWorldPoints(self.shape:getPoints())
    local width = x2 - x1
    local height = y4 - y1
    return width, height
end

---Gets the width of the RectangleCollider.
---@return number width The width of the RectangleCollider.
function RectangleCollider:getWidth()
    local width, _ = self:getSize()
    return width
end

return physics
