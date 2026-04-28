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
---@field private __index? table The index of the world (for iterating).
---@field private __class? string The class of the world.
local World = {}
World.__index = World
World.__class = "World"

---@class Collider
---@field protected body love.Body The body of the Collider.
---@field protected fixtures table<string, love.Fixture> The fixtures of the Collider.
---@field private __index? table The index of the Collider (for iterating).
---@field private __class? string The class of the Collider.
local Collider = {}
Collider.__index = Collider
Collider.__class = "Collider"


--- Methods
---Creates a world.
---@param xg? number The x component of gravity.
---@param yg? number The y component of gravity.
---@param sleep? boolean Whether the bodies in this world are allowed to sleep.
---@return World world A new World object.
function physics.newWorld(xg, yg, sleep)
    ---@type World
    local self = {
        world = love.physics.newWorld(xg, yg, sleep)
    }
    setmetatable(self, World)
    self:getWorld():setCallbacks(self.beginContact, self.endContact, self.preSolve, self.postSolve)
    return self
end

---Creates a new Collider object.
---@param world love.World The world to which the Collider belongs.
---@param x number The X coordinate of the Collider.
---@param y number The Y coordinate of the Collider.
---@param bodyType love.BodyType The type of the body of the Collider.
---@return Collider collider A new Collider object.
function physics.newCollider(world, x, y, bodyType)
    local body = love.physics.newBody(world, x, y, bodyType)
    body:setFixedRotation(true)
    ---@type Collider
    local self = {
        body = body,
        fixtures = {}
    }
    setmetatable(self, Collider)
    return self
end

---@param fixtureA love.Fixture
---@param fixtureB love.Fixture
---@param contact love.Contact
function World:beginContact(fixtureA, fixtureB, contact)
    local userdataA = fixtureA:getUserData()
    local userdataB = fixtureB:getUserData()
    print(userdataA .. " colided with " .. userdataB)
end

function World:endContact(fixtureA, fixtureB, contact)
    local userdataA = fixtureA:getUserData()
    local userdataB = fixtureB:getUserData()
    print(userdataA .. " finished colided with " .. userdataB)
end

function World:preSolve(fixtureA, fixtureB, contact) end

function World:postSolve(fixtureA, fixtureB, contact, normalImpulse, tangentImpulse) end

---Gets the world.
---@return love.World world The World.
function World:getWorld()
    return self.world
end

---Update the state of the World.
---@param dt number The time (in seconds) to advance the physics simulation.
---@param velocityiterations? number The maximum number of steps used to determine the new velocities when resolving a collision.
---@param positioniterations? number The maximum number of steps used to determine the new positions when resolving a collision.
function World:update(dt, velocityiterations, positioniterations)
    self.world:update(dt, velocityiterations, positioniterations)
end

---comment
---@param name string
---@param body love.Body
---@param shapeType love.ShapeType
---@param isSensor boolean
---@param offsetX number
---@param offsetY number
---@param ... any
---@return love.Fixture
function physics.newFixture(name, body, shapeType, isSensor, offsetX, offsetY, ...)
    local shape
    if shapeType == "circle" then
        local radius = ...
        shape = love.physics.newCircleShape(offsetX, offsetY, radius)
    elseif shapeType == "polygon" then
        local width, height = ...
        shape = love.physics.newRectangleShape(offsetX, offsetY, width, height)
    end

    local fixture = love.physics.newFixture(body, shape)
    fixture:setFriction(0)
    fixture:setUserData(name)
    fixture:setSensor(isSensor or false)

    return fixture
end

---comment
---@param name string
---@param shapeType love.ShapeType
---@param isSensor boolean
---@param offsetX number
---@param offsetY number
---@param ... any
function Collider:addFixture(name, shapeType, isSensor, offsetX, offsetY, ...)
    assert(not self.fixtures[name], "Fixture with tag '" .. name .. "' already exists.")
    self.fixtures[name] = physics.newFixture(name, self.body, shapeType, isSensor, offsetX, offsetY, ...)
end

---Draws the Collider.
function Collider:draw()
    local x, y = self.body:getPosition()
    love.graphics.setColor(colors.GREEN)
    love.graphics.circle("fill", x, y, 2)
    love.graphics.setColor(colors.DEFAULT)

    for _, fixture in pairs(self.fixtures) do
        local shape = fixture:getShape()
        if shape:getType() == "circle" then
            ---@cast shape love.CircleShape
            local cx, cy = self.body:getWorldPoint(shape:getPoint())
            love.graphics.circle("line", cx, cy, shape:getRadius())
        elseif shape:getType() == "polygon" then
            ---@cast shape love.PolygonShape
            love.graphics.polygon("line", self.body:getWorldPoints(shape:getPoints()))
        end
    end
end

---Gets the body of the Collider.
---@return love.Body body The body of the Collider.
function Collider:getBody()
    return self.body
end

---Gets the ficture given its tag (userdata).
---@param fixtureTag string The fixture tag (userdata).
---@return love.Fixture fixture The fixture of the Collider.
function Collider:getFixture(fixtureTag)
    assert(self.fixtures[fixtureTag], "Fixture with tag '" .. fixtureTag .. "' does not exists.")
    return self.fixtures[fixtureTag]
end

---Gets the fixtures of the Collider.
---@return love.Fixture[] fixtures The fixtures of the Collider.
function Collider:getFixtures()
    return self.fixtures
end

---Gets the height of the shape of the fixture.
---@param fixtureTag string The tag (userdata) of the fixture.
---@return number? height The height of the shape of the fixture.
function Collider:getHeight(fixtureTag)
    local _, height = self:getSize(fixtureTag)
    assert(self.fixtures[fixtureTag]:getShape():getType() == "polygon", "Fixture must have a PolygonShape.")
    return height
end

---Gets the size of the Collider.
---@param fixtureTag string The tag (userdata) of the fixture.
---@return number|nil width_or_radius The width/radius of the shape of the fixture.
---@return number? height The height of the shape of the fixture.
function Collider:getSize(fixtureTag)
    assert(self.fixtures[fixtureTag], "Fixture with tag '" .. fixtureTag .. "' does not exists.")

    ---@type love.Fixture
    local fixture = self.fixtures[fixtureTag]
    local shape = fixture:getShape()
    if shape:getType() == "circle" then
        ---@cast shape love.CircleShape
        return shape:getRadius()
    elseif shape:getType() == "polygon" then
        ---@cast shape love.PolygonShape
        local x1, y1, x2, _, _, _, _, y4 = self.body:getWorldPoints(shape:getPoints())
        local width = x2 - x1
        local height = y4 - y1
        return width, height
    end
end

---Gets the height of the shape of the fixture.
---@param fixtureTag string The tag (userdata) of the fixture.
---@return number? width The width of the shape of the fixture.
function Collider:getWidth(fixtureTag)
    local width, _ = self:getSize(fixtureTag)
    assert(self.fixtures[fixtureTag]:getShape():getType() == "polygon", "Fixture must have a PolygonShape.")
    return width
end

return physics
