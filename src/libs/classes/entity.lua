--[[
    Author: Marcus Ferreira
    Description: A entity library for LOVE.
]]


--- Imports
local animation    = require("src.libs.love.animation")
local collision    = require("src.libs.love.collision")
local stateManager = require("src.libs.love.stateManager")


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
---@field private stateManager StateManager The state manager of the entity.
---@field private animations Animation[] The animations of the entity.
---@field private currentAnimation Animation|nil The current animation of the entity.
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
        x = x,
        y = y,
        width = width,
        height = height,
        vx = 0,
        vy = 0,
        stateManager = stateManager.newStateManager(),
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
---@param interval? number The time in seconds between frames. Default = 1.
---@param loop? boolean Whether the animation should loop. Default = false.
function Entity:addAnimation(name, image, grid, frames, interval, loop)
    assert(not self.animations[name], "Animation with name '" .. name .. "' already exists.")
    self.animations[name] = animation.newAnimation(image, grid, frames, nil, nil, interval, loop)

    if not self.currentAnimation then
        self.currentAnimation = self.animations[name]
    end
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
---@param _animation string The animation of the entity to be changed.
function Entity:changeAnimation(_animation)
    assert(self.animations[_animation], "Animation with name '" .. _animation .. "' does not exist.")
    self.currentAnimation = self.animations[_animation]
    self.currentAnimation:play()
end

---Changes the current state of the entity.
---@param name string The state of the entity to be changed.
---@param ... any # The enter parameters of the state.
function Entity:changeState(name, ...)
    self.stateManager:changeState(name, ...)
end

---Draws the entity.
function Entity:draw()
    assert(self.currentAnimation, "Entity has no current animation.")
    self.currentAnimation:draw(self.x, self.y)

    -- Draw the current state
    self.stateManager:draw()
end

---Draws the colliders of the entity.
function Entity:drawCollider()
    assert(self.collider, "Entity has no collider.")
    self.collider:draw()
end

---Gets an animation given its name.
---@param _animation string The animation name to be returned.
---@return Animation animation The animation to be returned.
function Entity:getAnimation(_animation)
    assert(self.animations[_animation], "Animation with name " .. _animation .. " does not exist.")
    return self.animations[_animation]
end

---Gets the collider of the entity.
---@return CircleCollider|RectangleCollider collider The collider of the entity.
function Entity:getCollider()
    return self.collider
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

---Gets the state manager of the entity.
---@return StateManager stateManager The state manager of the entity.
function Entity:getStateManager()
    return self.stateManager
end

---Moves the entity toward a point given a vx and vy velocity.
---@param vx number The X linear velocity.
---@param vy number The Y linear velocity.
function Entity:moveTowards(vx, vy)
    self.vx = vx
    self.vy = vy
end

---Updates the entity.
---@param dt number The delta time.
function Entity:update(dt)
    -- Updates the position
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    -- Updates the collider position
    local colliderX, colliderY = self.collider:getPosition()
    self.collider:setPosition(colliderX + self.vx * dt, colliderY + self.vy * dt)

    -- Updates the state manager
    self.stateManager:update(dt)

    -- Updates the current animation
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

return entity
