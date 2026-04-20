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
---@field private __index? table The index of the world (for iterating).
local World = {}
World.__index = World

---@class PhysicsWorld : World
---@field private world love.World The physics world.
---@field private colliders PhysicsCircleCollider[]|PhysicsRectangleCollider[] The physics colliders of the world.
---@field private __index? table The index of the physics world (for iterating).
local PhysicsWorld = setmetatable({}, World)
PhysicsWorld.__index = PhysicsWorld

---@class SimpleWorld : World
---@field private world table The simple world.
---@field private colliders SimpleCircleCollider[]|SimpleRectangleCollider[] The colliders of the world.
---@field private __index? table The index of the simple world (for iterating).
local SimpleWorld = setmetatable({}, World)
SimpleWorld.__index = SimpleWorld

---@class PhysicsCollider
---@field private body love.Body The physics body of the collider.
---@field private shape love.CircleShape|love.PolygonShape The shape of the collider.
---@field private fixture love.Fixture The fixture of the collider.
---@field private __index? table The index of the collider (for iterating).
local PhysicsCollider = {}
PhysicsCollider.__index = PhysicsCollider

---@class PhysicsCircleCollider : PhysicsCollider
---@field private body love.Body The physics body of the collider.
---@field private shape love.CircleShape The shape of the collider.
---@field private fixture love.Fixture The fixture of the collider.
---@field private __index? table The index of the circle collider (for iterating).
local PhysicsCircleCollider = setmetatable({}, PhysicsCollider)
PhysicsCircleCollider.__index = PhysicsCircleCollider

---@class PhysicsRectangleCollider : PhysicsCollider
---@field private body love.Body The physics body of the collider.
---@field private shape love.PolygonShape The shape of the collider.
---@field private fixture love.Fixture The fixture of the collider.
---@field private __index? table The index of the rectangle collider (for iterating).
local PhysicsRectangleCollider = setmetatable({}, PhysicsCollider)
PhysicsRectangleCollider.__index = PhysicsRectangleCollider

---@class SimpleCollider
---@field private position Vector2 The vector2 of the position of the collider.
---@field private velocity Vector2 The vector2 of the velocity of the collider.
---@field private __index? table The index of the collider (for iterating).
local SimpleCollider = {}
SimpleCollider.__index = SimpleCollider

---@class SimpleCircleCollider : SimpleCollider
---@field private position Vector2 The vector2 of the position of the circle collider.
---@field private velocity Vector2 The vector2 of the velocity of the circle collider.
---@field private radius number The radius of the circle.
---@field private __index? table The index of the circle (for iterating).
local SimpleCircleCollider = setmetatable({}, SimpleCollider)
SimpleCircleCollider.__index = SimpleCircleCollider

---@class SimpleRectangleCollider : SimpleCollider
---@field private position Vector2 The vector2 of the position (x, y) of the rectangle collider.
---@field private velocity Vector2 The vector2 of the velocity (vx, vy) of the rectangle collider.
---@field private size Vector2 The vector2 of the size (width, height) of the rectangle collider.
---@field private __index? table The index of the rectangle (for iterating).
local SimpleRectangleCollider = setmetatable({}, SimpleCollider)
SimpleRectangleCollider.__index = SimpleRectangleCollider


--- Methods
---Creates a physics world.
---@param xg? number The x component of gravity.
---@param yg? number The y component of gravity.
---@param sleep? boolean Whether the bodies in this world are allowed to sleep.
---@return PhysicsWorld physicsWorld A new PhysicsWorld object.
function physics.newPhysicsWorld(xg, yg, sleep)
    ---@type PhysicsWorld
    local self = {
        world = love.physics.newWorld(xg, yg, sleep),
        colliders = {}
    }
    setmetatable(self, PhysicsWorld)
    return self
end

---Creates a simple world (without physics library).
---@return SimpleWorld simpleWorld A new SimpleWorld object.
function physics.newSimpleWorld()
    ---@type SimpleWorld
    local self = {
        world = {},
        colliders = {}
    }
    setmetatable(self, SimpleWorld)
    return self
end

---Creates a new PhysicsCircleCollider object.
---@param world love.World The physics world to which the collider belongs.
---@param x number The X coordinate of the collider.
---@param y number The Y coordinate of the collider.
---@param radius number The radius of the collider.
---@param type love.BodyType The type of the collider.
---@return PhysicsCircleCollider physicsCircleCollider A new PhysicsCircleCollider object.
function physics.newPhysicsCircleCollider(world, x, y, radius, type)
    local body = love.physics.newBody(world, x, y, type)
    local shape = love.physics.newCircleShape(radius)
    local fixture = love.physics.newFixture(body, shape)
    body:setFixedRotation(true)
    fixture:setFriction(0)

    ---@type PhysicsCircleCollider
    local self = {
        body = body,
        shape = shape,
        fixture = fixture
    }
    setmetatable(self, PhysicsCircleCollider)
    return self
end

---Creates a new PhysicsRectangleCollider object.
---@param world love.World The physics world to which the collider belongs.
---@param x number The X coordinate of the collider.
---@param y number The Y coordinate of the collider.
---@param width number The width of the collider.
---@param height number The height of the collider.
---@param type love.BodyType The type of the body of the collider.
---@return PhysicsRectangleCollider physicsRectangleCollider A new PhysicsRectangleCollider object.
function physics.newPhysicsRectangleCollider(world, x, y, width, height, type)
    local body = love.physics.newBody(world, x, y, type)
    local shape = love.physics.newRectangleShape(width, height)
    local fixture = love.physics.newFixture(body, shape)
    body:setFixedRotation(true)
    fixture:setFriction(0)

    ---@type PhysicsRectangleCollider
    local self = {
        body = body,
        shape = shape,
        fixture = fixture
    }
    setmetatable(self, PhysicsRectangleCollider)
    return self
end

--- Creates a new SimpleCircleCollider object.
---@param position Vector2 The position vector of the circle.
---@param radius number The radius of the circle.
---@return SimpleCircleCollider simpleCircleCollider A new SimpleCircleCollider object.
function physics.newSimpleCircleCollider(position, radius)
    ---@type SimpleCircleCollider
    local self = {
        position = position,
        radius = radius,
        velocity = vector.newVector2()
    }
    setmetatable(self, SimpleCircleCollider)
    return self
end

---Creates a new SimpleRectangleCollider object.
---@param position Vector2 The position vector of the rectangle.
---@param size Vector2 The size vector of the rectangle.
---@return SimpleRectangleCollider simpleRectangleCollider A new SimpleRectangleCollider object.
function physics.newSimpleRectangleCollider(position, size)
    ---@type SimpleRectangleCollider
    local self = {
        position = position,
        size = size,
        velocity = vector.newVector2()
    }
    setmetatable(self, SimpleRectangleCollider)
    return self
end

---Adds a new PhysicsCircleCollider object in the world.
---@param x number The X position of the collider.
---@param y number The Y position of the collider.
---@param radius number The radius of the collider.
---@param type love.BodyType The type of the body of the collider.
function PhysicsWorld:addNewPhysicsCircleCollider(x, y, radius, type)
    local collider = physics.newPhysicsCircleCollider(self.world, x, y, radius, type)
    table.insert(self.colliders, collider)
end

---Adds a new PhysicsRectangleCollider object in the world.
---@param x number The X coordinate of the collider.
---@param y number The Y coordinate of the collider.
---@param width number The width of the collider.
---@param height number The height of the collider.
---@param type love.BodyType The type of the body of the collider.
function PhysicsWorld:addNewPhysicsRectangleCollider(x, y, width, height, type)
    local collider = physics.newPhysicsRectangleCollider(self.world, x, y, width, height, type)
    table.insert(self.colliders, collider)
end

---Gets the collider given its index.
---@param index number The index of the collider.
---@return PhysicsCollider physicsCollider The PhysicsCollider object.
function PhysicsWorld:getCollider(index)
    return self.colliders[index]
end

---Gets the colliders of the world.
---@return PhysicsCollider[] physicsColliders The table of PhysicsColliders of the world.
function PhysicsWorld:getColliders()
    return self.colliders
end

---Gets the world.
---@return love.World world The PhysicsWorld.
function PhysicsWorld:getWorld()
    return self.world
end

---Removes a collider of the world.
---@param index number The index of the collider.
function PhysicsWorld:removeCollider(index)
    table.remove(self.colliders, index)
end

---Update the state of the PhysicsWorld.
---@param dt number The time (in seconds) to advance the physics simulation.
---@param velocityiterations? number The maximum number of steps used to determine the new velocities when resolving a collision.
---@param positioniterations? number The maximum number of steps used to determine the new positions when resolving a collision.
function PhysicsWorld:update(dt, velocityiterations, positioniterations)
    self.world:update(dt, velocityiterations, positioniterations)
end

---Adds a new SimpleCircleCollider in the world.
---@param position Vector2 The position vector of the SimpleCircleCollider.
---@param radius number The radius of the SimpleCircleCollider.
function SimpleWorld:addNewSimpleCircleCollider(position, radius)
    local collider = physics.newSimpleCircleCollider(position, radius)
    table.insert(self.colliders, collider)
end

---Adds a new SimpleRectangleCollider in the world.
---@param position Vector2 The position vector (x, y) of the SimpleRectangleCollider.
---@param size Vector2 The size vector (width, height) of the SimpleRectangleCollider.
function SimpleWorld:addNewSimpleRectangleCollider(position, size)
    local collider = physics.newSimpleRectangleCollider(position, size)
    table.insert(self.colliders, collider)
end

function SimpleWorld:drawColliders()
    for i, collider in ipairs(self.colliders) do
        collider:draw()
    end
end

---Gets the collider given its index.
---@param index number The index of the collider.
---@return SimpleCollider|SimpleCircleCollider|SimpleRectangleCollider simpleCollider The SimpleCollider object.
function SimpleWorld:getCollider(index)
    return self.colliders[index]
end

---Gets the colliders of the world.
---@return SimpleCollider[] simpleColliders The table of SimpleColliders of the world.
function SimpleWorld:getColliders()
    return self.colliders
end

---Gets the world.
---@return SimpleWorld simpleWorld The SimpleWorld.
function SimpleWorld:getWorld()
    return self.world
end

---Removes a collider of the world given its index.
---@param index number The index of the collider.
function SimpleWorld:removeCollider(index)
    table.remove(self.colliders, index)
end

---Updates the SimpleWorld.
---@param dt number The delta time.
function SimpleWorld:update(dt)
    for _, collider in ipairs(self.colliders) do
        collider:update(dt)
    end
end

---Gets the body of the PhysicsCollider.
---@return love.Body body The body of the PhysicsCollider.
function PhysicsCollider:getBody()
    return self.body
end

---Gets the fixture of the PhysicsCollider.
---@return love.Fixture fixture The fixture of the PhysicsCollider.
function PhysicsCollider:getFixture()
    return self.fixture
end

---Gets the shape of the PhysicsCollider.
---@return love.Shape shape The shape of the PhysicsCollider.
function PhysicsCollider:getShape()
    return self.shape
end

---Draws the PhysicsCircleCollider.
function PhysicsCircleCollider:draw()
    love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
end

---Draws the PhysicsRectangleCollider.
function PhysicsRectangleCollider:draw()
    love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
end

---Gets the height of the PhysicsRectangleCollider.
---@return number height The height of the PhysicsRectangleCollider.
function PhysicsRectangleCollider:getHeight()
    local _, height = self:getSize()
    return height
end

---Gets the size of the PhysicsRectangleCollider.
---@return number width The width of the collider.
---@return number height The height of the collider.
function PhysicsRectangleCollider:getSize()
    local x1, y1, x2, _, _, _, _, y4 = self.body:getWorldPoints(self.shape:getPoints())
    local width = x2 - x1
    local height = y4 - y1
    return width, height
end

---Gets the width of the PhysicsRectangleCollider.
---@return number width The width of the PhysicsRectangleCollider.
function PhysicsRectangleCollider:getWidth()
    local width, _ = self:getSize()
    return width
end

---Abstract function.
function SimpleCollider:draw() end

---Abstract function.
function SimpleCollider:getCenter() end

---Gets the position of the SimpleCollider.
---@return Vector2 position The vector2 of the position of the collider.
function SimpleCollider:getPosition()
    return self.position
end

---Gets the velocity of the SimpleCollider.
---@return Vector2 velocity The vector2 of the velocity of the collider.
function SimpleCollider:getVelocity()
    return self.velocity
end

---Sets the position of the SimpleCollider.
---@param vector2 Vector2 The vector2 of the new position of the collider.
function SimpleCollider:setPosition(vector2)
    self.position = vector2
end

---Abstract function.
function SimpleCollider:getRadius() end

---Abstract function.
function SimpleCollider:getSize() end

---Abstract function.
---@param other SimpleCollider The collider to check collision with.
---@param offsetPosition? Vector2 The offeset position vector of the collision.
function SimpleCollider:isColliding(other, offsetPosition) end

---Sets the velocity of the SimpleCollider.
---@param vector2 Vector2 The vector2 of the new velocity of the collider.
function SimpleCollider:setVelocity(vector2)
    self.velocity = vector2
end

---Updates the SimpleCollider.
---@param dt number The delta time.
function SimpleCollider:update(dt)
    self.position = self.position + self.velocity * dt
end

---Draws the circle.
function SimpleCircleCollider:draw()
    love.graphics.circle("line", self.position:getX(), self.position:getY(), self.radius)
end

---Gets the size of the circle.
---@return number radius The radius of the circle.
function SimpleCircleCollider:getRadius()
    return self.radius
end

---Checks if the SimpleCircleCollider is colliding with another SimpleCollider.
---@param other SimpleCircleCollider|SimpleRectangleCollider The collider to check collision with.
---@param offsetPosition? Vector2 The offeset position vector of the collision.
---@return boolean isColliding True if the circle is colliding with the collider, false otherwise.
function SimpleCircleCollider:isColliding(other, offsetPosition)
    local otherClass = getmetatable(other)
    assert(otherClass == SimpleCircleCollider or otherClass == SimpleRectangleCollider,
        "Other collider must be a SimpleCollider.")
    local _offsetPosition = offsetPosition or vector.newVector2()

    if otherClass == SimpleCircleCollider then
        local diff = other:getPosition() - (self.position + _offsetPosition)
        local radiiSum = self.radius + other:getRadius()
        return diff:lenSq() <= radiiSum * radiiSum
    elseif otherClass == SimpleRectangleCollider then
        local otherHalfSize = other:getSize() / 2
        local diff = (self.position + _offsetPosition) - other:getCenter()
        local closest = vector.newVector2(
            math.max(-otherHalfSize:getX(), math.min(diff:getX(), otherHalfSize:getX())),
            math.max(-otherHalfSize:getY(), math.min(diff:getY(), otherHalfSize:getY()))
        )
        local distanceVec = diff - closest
        return distanceVec:lenSq() <= self.radius * self.radius
    end


    return false
end

---Sets the size of the circle.
---@param radius number The radius to set for the circle.
function SimpleCircleCollider:setRadius(radius)
    self.radius = radius
end

---Draws the rectangle.
function SimpleRectangleCollider:draw()
    love.graphics.rectangle("line", self.position:getX(), self.position:getY(), self.size:getX(), self.size:getY())
end

---Gets the center of the SimpleRectangleCollider.
---@return Vector2 center The center of the SimpleRectangleCollider.
function SimpleRectangleCollider:getCenter()
    return self.position + (self.size / 2)
end

---Gets the size of the rectangle.
---@return Vector2 size The size (width, height) of the rectangle.
function SimpleRectangleCollider:getSize()
    return self.size
end

---Checks if the rectangle is colliding with another collider.
---@param other SimpleCircleCollider|SimpleRectangleCollider The collider to check collision with.
---@param offsetPosition? Vector2 The offeset position vector of the collision.
---@return boolean isColliding True if the rectangle is colliding with the collider, false otherwise.
function SimpleRectangleCollider:isColliding(other, offsetPosition)
    local otherClass = getmetatable(other)
    -- assert(otherClass == SimpleRectangleCollider or otherClass == SimpleRectangleCollider,
    -- "Other collider must be a SimpleCollider.")
    local _offsetPosition = offsetPosition or vector.newVector2()

    if otherClass == SimpleCircleCollider then
        local halfSize = self:getSize() / 2
        local diff = other:getPosition() - (self:getCenter() + _offsetPosition)
        local closest = vector.newVector2(
            math.max(-halfSize:getX(), math.min(diff:getX(), halfSize:getX())),
            math.max(-halfSize:getY(), math.min(diff:getY(), halfSize:getY()))
        )
        local distanceVec = diff - closest
        return distanceVec:lenSq() <= other:getRadius() * other:getRadius()
    elseif otherClass == SimpleRectangleCollider then
        local diff = ((self:getCenter() + _offsetPosition) - other:getCenter()):abs()
        local halfSizes = (self.size + other:getSize()) / 2
        return diff:getX() <= halfSizes:getX() and diff:getY() <= halfSizes:getY()
    end
    return false
end

---Sets the size of the rectangle.
---@param width number The width to set for the rectangle.
---@param height number	The height to set for the rectangle.
function SimpleRectangleCollider:setSize(width, height)
    self.width = width
    self.height = height
end

return physics
