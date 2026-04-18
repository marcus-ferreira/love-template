--[[
    Author: Marcus Ferreira
    Description: A entity library for LOVE.
]]


--- Imports
local animation    = require("src.libs.love.animation")
local collision    = require("src.libs.love.collision")
-- local physics   = require("src.libs.love.physics")
local stateMachine = require("src.libs.love.stateMachine")


--- Library
local entity = {}


--- Classes
---@class Entity
---@field private x number The X coordinate of the entity.
---@field private y number The Y coordinate of the entity.
---@field private width number The width of the entity.
---@field private height number The height of the entity.
---@field private vx number The X component of the linear velocity of the entity.
---@field private vy number The Y component of the linear velocity of the entity.
---@field private states State[] The states of the entity.
---@field private currentState State | nil The current state of the entity.
---@field private animations Animation[] The animations of the entity.
---@field private currentAnimation Animation | nil The current animation of the entity.
---@field private collider RectangleCollider | CircleCollider The collider of the entity.
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
        x = x,
        y = y,
        width = width,
        height = height,
        vx = 0,
        vy = 0,
        states = {},
        currentState = nil,
        animations = {},
        currentAnimation = nil,
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
---@param interval? number The time in seconds between frames. Default = 1.
---@param loop? boolean Whether the animation should loop. Default = false.
function Entity:addAnimation(name, image, grid, frames, originX, originY, interval, loop)
    assert(not self.animations[name], "Animation with name '" .. name .. "' already exists.")
    self.animations[name] = animation.newAnimation(image, grid, frames, originX, originY, interval, loop)

    if not self.currentAnimation then
        self.currentAnimation = self.animations[name]
    end
end

---Adds a circular collider to the entity.
---@param x number The X coordinate of the collider.
---@param y number The Y coordinate of the collider.
---@param radius number The radius of the collider.
function Entity:addCircleCollider(x, y, radius)
    self.collider = collision.newCircleCollider(x, y, radius)
end

---Adds a rectangle collider to the entity.
---@param x number The X coordinate of the collider.
---@param y number The Y coordinate of the collider.
---@param width number The width of the collider.
---@param height number The height of the collider.
function Entity:addRectangleCollider(x, y, width, height)
    self.collider = collision.newRectangleCollider(x, y, width, height)
end

---Adds a new state to the entity.
---@param name string The name of the state.
---@param enter? function The function to be called when the state is entered.
---@param update? function The function to be called when the state is updated.
---@param draw? function The function to be called when the state is drawn.
---@param exit? function The function to be called when the state is exited.
function Entity:addState(name, enter, update, draw, exit)
    assert(not self.states[name], "State with name '" .. name .. "' already exists.")
    self.states[name] = stateMachine.newState(name, enter, update, draw, exit)
    if not self.currentState then
        self.currentState = self.states[name]
    end
end

---Changes the current animation of the entity.
---@param _animation string The animation of the entity to be changed.
function Entity:changeAnimation(_animation)
    assert(self.animations[_animation], "Animation with name '" .. _animation .. "' does not exist.")
    self.currentAnimation = self.animations[_animation]
    self.currentAnimation:play()
end

---Changes the current state of the entity.
---@param _state string The state of the entity to be changed.
function Entity:changeState(_state)
    assert(self.states[_state], "State with name '" .. _state .. "' does not exist.")
    self.currentState = self.states[_state]
    self:changeAnimation(_state)
end

---Draws the entity.
function Entity:draw()
    assert(self.currentAnimation, "Entity has no current animation.")
    self.currentAnimation:draw(self.x, self.y)
end

---Draws the colliders of the entity.
function Entity:drawCollider()
    assert(self.collider, "Entity has no collider.")
    self.collider:draw()
end

---Gets the current animation of the entity.
---@return Animation currentAnimation The current animation of the entity.
function Entity:getCurrentAnimation()
    return self.currentAnimation
end

---Gets the position of the entity.
---@return number x The X coordinate of the entity.
---@return number y The Y coordinate of the entity.
function Entity:getPosition()
    return self.x, self.y
end

---Moves the entity toward a point given a vx and vy velocity.
---@param vx number The X linear velocity.
---@param vy number The Y linear velocity.
function Entity:moveTowards(vx, vy)
    self.vx = vx
    self.vy = vy
end

---Sets the collider and collision mask of the current animation.
---@param width number The new width of the collider and collision mask of the current animation.
---@param height number The new height of the collider and collision mask of the current animation.
function Entity:setColliderSize(width, height)
    self.collider:setSize(width, height)
    self.currentAnimation:getCollisionMask():setSize(width, height)
end

---Updates the entity.
---@param dt number The delta time.
function Entity:update(dt)
    -- Updates the position
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    -- Updates the collider position based on the collision mask of the current animation
    if self.collider then
        if self.currentAnimation then
            local maskX, maskY = self.currentAnimation:getCollisionMaskPosition(self.x, self.y)
            local maskWidth, maskHeight = self.currentAnimation:getCollisionMaskSize()
            self.collider:setPosition(maskX + (maskWidth / 2), maskY + (maskHeight / 2))
        else
            local colliderX, colliderY = self.collider:getPosition()
            self.collider:setPosition(colliderX + self.vx * dt, colliderY + self.vy * dt)
        end
    end

    -- Updates the current animation
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

return entity
