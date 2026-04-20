--[[
    Author: Marcus Ferreira
    Description: A entity library for LOVE.
]]


--- Imports
local animationManager = require("src.libs.love.animationManager")
local collision        = require("src.libs.love.collision")
local stateManager     = require("src.libs.love.stateManager")
local vector           = require("src.libs.love.vector")


--- Library
local entity = {}


--- Classes
---@class Entity
---@field private position Vector2 The vector2 of the position of the entity.
---@field private width number The width of the entity.
---@field private height number The height of the entity.
---@field private velocity Vector2 The vector2 of the linear velocity of the entity.
---@field private stateManager StateManager The state manager of the entity.
---@field private animationManager AnimationManager The animation manager of the entity.
---@field private collider RectangleCollider|CircleCollider The collider of the entity.
---@field private __index? table The index of the Entity (for iterating).
local Entity = {}
Entity.__index = Entity


--- Methods
---Creates a new entity object.
---@param x number The X coordinate of the entity.
---@param y number The Y coordinate of the entity.
---@param width number The width of the entity.
---@param height number The height of the entity.
---@return Entity entity A new entity object.
function entity.newEntity(x, y, width, height)
    ---@type Entity
    local self = {
        position = vector.newVector2(x, y),
        width = width,
        height = height,
        velocity = vector.newVector2(),
        stateManager = stateManager.newStateManager(),
        animationManager = animationManager.newAnimationManager(),
        collider = collision.newRectangleCollider(x, y, width, height)
    }
    setmetatable(self, Entity)
    return self
end

---Adds a new animation to the entity.
---@param name string The name of the animation.
---@param image love.Image The image to be used.
---@param grid Grid The grid of quads created by newGrid.
---@param frames number[] A table of the numbers of the quads in order.
---@param originX? number The X origin for drawing. Default = 0.
---@param originY? number The Y origin for drawing. Default = 0.
---@param interval? number The interval between frame quads, in seconds. Default = 1.
---@param loop? boolean True if the animation should be looped or false if contrary. Default = false.
function Entity:addAnimation(name, image, grid, frames, originX, originY, interval, loop)
    self.animationManager:addAnimation(name, image, grid, frames, originX, originY, interval, loop)
end

---Adds a new state to the entity.
---@param name string The name of the state.
---@param enter? function The function to be called when the state is entered.
---@param update? function The function to be called when the state is updated.
---@param draw? function The function to be called when the state is drawn.
---@param exit? function The function to be called when the state is exited.
function Entity:addState(name, enter, update, draw, exit)
    self.stateManager:addState(name, enter, update, draw, exit)
end

---Changes the current animation of the entity.
---@param name string The name of the animation of the entity to be changed.
function Entity:changeAnimation(name)
    self.animationManager:changeAnimation(name)
end

---Changes the current state of the entity.
---@param name string The state of the entity to be changed.
---@param ... any # The enter parameters of the state.
function Entity:changeState(name, ...)
    self.stateManager:changeState(name, ...)
end

---Draws the entity.
---@param rotation? number The rotation value of the animation.
---@param sx? number The scaleX of the animation.
---@param sy? number The scaleY of the animation.
function Entity:draw(rotation, sx, sy)
    self.animationManager:draw(self.position:getX(), self.position:getY(), rotation, sx, sy)
    self.stateManager:draw()
end

---Gets the animation manager of the entity.
---@return AnimationManager animationManager The animation manager.
function Entity:getAnimationManager()
    return self.animationManager
end

---Gets the collider of the entity.
---@return CircleCollider|RectangleCollider collider The collider of the entity.
function Entity:getCollider()
    return self.collider
end

---Gets the position of the entity.
---@return Vector2 position The vector2 of the position of the entity.
function Entity:getPosition()
    return self.position
end

---Gets the state manager of the entity.
---@return StateManager stateManager The state manager of the entity.
function Entity:getStateManager()
    return self.stateManager
end

---Gets the velocity of the entity.
---@return Vector2 velocity The vector2 of the velocity of the entity.
function Entity:getVelocity()
    return self.velocity
end

---Sets a new value to the position of the entity.
---@param vector2 Vector2 The vector2 of the new position of the entity.
function Entity:setPosition(vector2)
    self.position:setCoordinates(vector2:getX(), vector2:getY())
end

---Sets a new value to the velocity of the entity.
---@param vector2 Vector2 The vector2 of the new velocity of the entity.
function Entity:setVelocity(vector2)
    self.velocity:setCoordinates(vector2:getX(), vector2:getY())
    self.collider:setVelocity(vector2)
end

---Updates the entity.
---@param dt number The delta time.
function Entity:update(dt)
    -- Updates the position
    local playerDirection = (self.position + self.velocity) - self.position
    local newPlayerPosition = self.position + (playerDirection:normalize() * 60 * dt)
    self:setPosition()

    -- Updates the collider position
    local colliderPosition = self.collider:getPosition()
    local colliderVelocity = self.collider:getVelocity()
    local colliderDirection = (colliderPosition + colliderVelocity) - colliderPosition
    self.collider:setPosition(colliderPosition + (colliderDirection:normalize() * 60 * dt))

    -- Updates the state manager
    self.stateManager:update(dt)

    -- Updates the current animation
    self.animationManager:update(dt)
end

return entity
