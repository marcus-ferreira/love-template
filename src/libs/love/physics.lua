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
---@class (exact) World
---@field private world love.World The world.
---@field private colliders CircleCollider[]|RectangleCollider[] The colliders of the world.
---@field private __index? table The index of the world (for iterating).
local World = {}
World.__index = World

---@class (exact) Collider
---@field private body love.Body The body of the Collider.
---@field private shape love.CircleShape|love.PolygonShape The shape of the Collider.
---@field private fixture love.Fixture The fixture of the Collider.
---@field private __index? table The index of the Collider (for iterating).
local Collider = {}
Collider.__index = Collider

---@class (exact) CircleCollider : Collider
---@field private body love.Body The body of the CircleCollider.
---@field private shape love.CircleShape The shape of the CircleCollider.
---@field private fixture love.Fixture The fixture of the CircleCollider.
---@field private __index? table The index of the CircleCollider (for iterating).
local CircleCollider = setmetatable({}, Collider)
CircleCollider.__index = CircleCollider

---@class (exact) RectangleCollider : Collider
---@field private body love.Body The physics body of the RectangleCollider.
---@field private shape love.PolygonShape The shape of the RectangleCollider.
---@field private fixture love.Fixture The fixture of the RectangleCollider.
---@field private __index? table The index of the RectangleCollider (for iterating).
local RectangleCollider = setmetatable({}, Collider)
RectangleCollider.__index = RectangleCollider


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
---@return CircleCollider[]|RectangleCollider[] colliders The table of colliders of the world.
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

---Gets the shape of the Collider.
---@return love.Shape shape The shape of the Collider.
function Collider:getShape()
    return self.shape
end

---Draws the CircleCollider.
function CircleCollider:draw()
    love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
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

-- --- Classes
-- ---@class SimpleCollider
-- ---@field private position Vector2 The vector2 of the position of the collider.
-- ---@field private velocity Vector2 The vector2 of the velocity of the collider.
-- ---@field private __index? table The index of the collider (for iterating).
-- local SimpleCollider = {}
-- SimpleCollider.__index = SimpleCollider

-- ---@class SimpleCircleCollider : SimpleCollider
-- ---@field private position Vector2 The vector2 of the position of the circle collider.
-- ---@field private velocity Vector2 The vector2 of the velocity of the circle collider.
-- ---@field private radius number The radius of the circle.
-- ---@field private __index? table The index of the circle (for iterating).
-- local SimpleCircleCollider = setmetatable({}, SimpleCollider)
-- SimpleCircleCollider.__index = SimpleCircleCollider

-- ---@class SimpleRectangleCollider : SimpleCollider
-- ---@field private position Vector2 The vector2 of the position (x, y) of the rectangle collider.
-- ---@field private velocity Vector2 The vector2 of the velocity (vx, vy) of the rectangle collider.
-- ---@field private size Vector2 The vector2 of the size (width, height) of the rectangle collider.
-- ---@field private __index? table The index of the rectangle (for iterating).
-- local SimpleRectangleCollider = setmetatable({}, SimpleCollider)
-- SimpleRectangleCollider.__index = SimpleRectangleCollider

-- --- Methods
-- ---Creates a simple world (without physics library).
-- ---@return SimpleWorld simpleWorld A new SimpleWorld object.
-- function physics.newSimpleWorld()
--     ---@type SimpleWorld
--     local self = {
--         world = {},
--         colliders = {}
--     }
--     setmetatable(self, SimpleWorld)
--     return self
-- end

-- --- Creates a new SimpleCircleCollider object.
-- ---@param position Vector2 The position vector of the circle.
-- ---@param radius number The radius of the circle.
-- ---@return SimpleCircleCollider simpleCircleCollider A new SimpleCircleCollider object.
-- function physics.newSimpleCircleCollider(position, radius)
--     ---@type SimpleCircleCollider
--     local self = {
--         position = position,
--         radius = radius,
--         velocity = vector.newVector2()
--     }
--     setmetatable(self, SimpleCircleCollider)
--     return self
-- end

-- ---Creates a new SimpleRectangleCollider object.
-- ---@param position Vector2 The position vector of the rectangle.
-- ---@param size Vector2 The size vector of the rectangle.
-- ---@return SimpleRectangleCollider simpleRectangleCollider A new SimpleRectangleCollider object.
-- function physics.newSimpleRectangleCollider(position, size)
--     ---@type SimpleRectangleCollider
--     local self = {
--         position = position,
--         size = size,
--         velocity = vector.newVector2()
--     }
--     setmetatable(self, SimpleRectangleCollider)
--     return self
-- end

-- ---Adds a new SimpleCircleCollider in the world.
-- ---@param position Vector2 The position vector of the SimpleCircleCollider.
-- ---@param radius number The radius of the SimpleCircleCollider.
-- function SimpleWorld:addNewSimpleCircleCollider(position, radius)
--     local collider = physics.newSimpleCircleCollider(position, radius)
--     table.insert(self.colliders, collider)
-- end

-- ---Adds a new SimpleRectangleCollider in the world.
-- ---@param position Vector2 The position vector (x, y) of the SimpleRectangleCollider.
-- ---@param size Vector2 The size vector (width, height) of the SimpleRectangleCollider.
-- function SimpleWorld:addNewSimpleRectangleCollider(position, size)
--     local collider = physics.newSimpleRectangleCollider(position, size)
--     table.insert(self.colliders, collider)
-- end

-- function SimpleWorld:drawColliders()
--     for i, collider in ipairs(self.colliders) do
--         collider:draw()
--     end
-- end

-- ---Gets the collider given its index.
-- ---@param index number The index of the collider.
-- ---@return SimpleCollider|SimpleCircleCollider|SimpleRectangleCollider simpleCollider The SimpleCollider object.
-- function SimpleWorld:getCollider(index)
--     return self.colliders[index]
-- end

-- ---Gets the colliders of the world.
-- ---@return SimpleCollider[] simpleColliders The table of SimpleColliders of the world.
-- function SimpleWorld:getColliders()
--     return self.colliders
-- end

-- ---Gets the world.
-- ---@return SimpleWorld simpleWorld The SimpleWorld.
-- function SimpleWorld:getWorld()
--     return self.world
-- end

-- ---Removes a collider of the world given its index.
-- ---@param index number The index of the collider.
-- function SimpleWorld:removeCollider(index)
--     table.remove(self.colliders, index)
-- end

-- ---Updates the SimpleWorld.
-- ---@param dt number The delta time.
-- function SimpleWorld:update(dt)
--     for _, collider in ipairs(self.colliders) do
--         collider:update(dt)
--     end
-- end

-- ---Gets the position of the SimpleCollider.
-- ---@return Vector2 position The vector2 of the position of the collider.
-- function SimpleCollider:getPosition()
--     return self.position
-- end

-- ---Gets the velocity of the SimpleCollider.
-- ---@return Vector2 velocity The vector2 of the velocity of the collider.
-- function SimpleCollider:getVelocity()
--     return self.velocity
-- end

-- ---Sets the position of the SimpleCollider.
-- ---@param vector2 Vector2 The vector2 of the new position of the collider.
-- function SimpleCollider:setPosition(vector2)
--     self.position = vector2
-- end

-- ---Sets the velocity of the SimpleCollider.
-- ---@param vector2 Vector2 The vector2 of the new velocity of the collider.
-- function SimpleCollider:setVelocity(vector2)
--     self.velocity = vector2
-- end

-- ---Updates the SimpleCollider.
-- ---@param dt number The delta time.
-- function SimpleCollider:update(dt)
--     self.position = self.position + self.velocity * dt
-- end

-- ---Draws the circle.
-- function SimpleCircleCollider:draw()
--     love.graphics.circle("line", self.position:getX(), self.position:getY(), self.radius)
-- end

-- ---Gets the size of the circle.
-- ---@return number radius The radius of the circle.
-- function SimpleCircleCollider:getRadius()
--     return self.radius
-- end

-- ---Checks if the SimpleCircleCollider is colliding with another SimpleCollider.
-- ---@param other SimpleCircleCollider|SimpleRectangleCollider The collider to check collision with.
-- ---@param offsetPosition? Vector2 The offeset position vector of the collision.
-- ---@return boolean isColliding True if the circle is colliding with the collider, false otherwise.
-- function SimpleCircleCollider:isColliding(other, offsetPosition)
--     local otherClass = getmetatable(other)
--     assert(otherClass == SimpleCircleCollider or otherClass == SimpleRectangleCollider,
--         "Other collider must be a SimpleCollider.")
--     local _offsetPosition = offsetPosition or vector.newVector2()

--     if otherClass == SimpleCircleCollider then
--         local diff = other:getPosition() - (self.position + _offsetPosition)
--         local radiiSum = self.radius + other:getRadius()
--         return diff:lenSq() <= radiiSum * radiiSum
--     elseif otherClass == SimpleRectangleCollider then
--         local otherHalfSize = other:getSize() / 2
--         local diff = (self.position + _offsetPosition) - other:getCenter()
--         local closest = vector.newVector2(
--             math.max(-otherHalfSize:getX(), math.min(diff:getX(), otherHalfSize:getX())),
--             math.max(-otherHalfSize:getY(), math.min(diff:getY(), otherHalfSize:getY()))
--         )
--         local distanceVec = diff - closest
--         return distanceVec:lenSq() <= self.radius * self.radius
--     end


--     return false
-- end

-- ---Sets the size of the circle.
-- ---@param radius number The radius to set for the circle.
-- function SimpleCircleCollider:setRadius(radius)
--     self.radius = radius
-- end

-- ---Draws the rectangle.
-- function SimpleRectangleCollider:draw()
--     love.graphics.rectangle("line", self.position:getX(), self.position:getY(), self.size:getX(), self.size:getY())
-- end

-- ---Gets the center of the SimpleRectangleCollider.
-- ---@return Vector2 center The center of the SimpleRectangleCollider.
-- function SimpleRectangleCollider:getCenter()
--     return self.position + (self.size / 2)
-- end

-- ---Gets the size of the rectangle.
-- ---@return Vector2 size The size (width, height) of the rectangle.
-- function SimpleRectangleCollider:getSize()
--     return self.size
-- end

-- ---Checks if the rectangle is colliding with another collider.
-- ---@param other SimpleCircleCollider|SimpleRectangleCollider The collider to check collision with.
-- ---@param offsetPosition? Vector2 The offeset position vector of the collision.
-- ---@return boolean isColliding True if the rectangle is colliding with the collider, false otherwise.
-- function SimpleRectangleCollider:isColliding(other, offsetPosition)
--     local otherClass = getmetatable(other)
--     -- assert(otherClass == SimpleRectangleCollider or otherClass == SimpleRectangleCollider,
--     -- "Other collider must be a SimpleCollider.")
--     local _offsetPosition = offsetPosition or vector.newVector2()

--     if otherClass == SimpleCircleCollider then
--         local halfSize = self:getSize() / 2
--         local diff = other:getPosition() - (self:getCenter() + _offsetPosition)
--         local closest = vector.newVector2(
--             math.max(-halfSize:getX(), math.min(diff:getX(), halfSize:getX())),
--             math.max(-halfSize:getY(), math.min(diff:getY(), halfSize:getY()))
--         )
--         local distanceVec = diff - closest
--         return distanceVec:lenSq() <= other:getRadius() * other:getRadius()
--     elseif otherClass == SimpleRectangleCollider then
--         local diff = ((self:getCenter() + _offsetPosition) - other:getCenter()):abs()
--         local halfSizes = (self.size + other:getSize()) / 2
--         return diff:getX() <= halfSizes:getX() and diff:getY() <= halfSizes:getY()
--     end
--     return false
-- end

-- ---Sets the size of the rectangle.
-- ---@param width number The width to set for the rectangle.
-- ---@param height number	The height to set for the rectangle.
-- function SimpleRectangleCollider:setSize(width, height)
--     self.width = width
--     self.height = height
-- end
