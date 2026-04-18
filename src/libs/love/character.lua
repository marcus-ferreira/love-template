--[[
    Author: Marcus Ferreira
    Description: A character library for LOVE.
]]


--- Imports
local animation = require("src.libs.love.animation")
local physics = require("src.libs.love.physics")
local state = require("src.libs.love.state")


--- Library
local character = {}


--- Classes
---@class Character
---@field private x number The X coordinate of the character.
---@field private y number The Y coordinate of the character.
---@field private vx number The X component of the linear velocity of the character.
---@field private vy number The Y component of the linear velocity of the character.
---@field private states State[] The states of the character.
---@field private currentState State | nil The current state of the character.
---@field private animations Animation[] The animations of the character.
---@field private currentAnimation Animation | nil The current animation of the character.
---@field private collider RectangleCollider | CircleCollider | nil The collider of the character.
---@field private __index? table The index of the character (for iterating).
local Character = {}
Character.__index = Character


--- Methods
---Creates a new Character object.
---@param x number The X coordinate of the character.
---@param y number The Y coordinate of the character.
---@return Character character A new Character object.
function character.newCharacter(x, y)
    ---@type Character
    local self = {
        x = x,
        y = y,
        vx = 0,
        vy = 0,
        states = {},
        currentState = nil,
        animations = {},
        currentAnimation = nil,
        collider = nil
    }
    setmetatable(self, Character)
    return self
end

---Adds a new animation to the character.
---@param name string The name of the animation.
---@param image love.Image The image to be used.
---@param grid Grid The grid of quads created by newGrid.
---@param frames number[] A table of the numbers of the quads in order.
---@param originX? number The X origin for drawing. Default = 0.
---@param originY? number The Y origin for drawing. Default = 0.
---@param interval? number The time in seconds between frames. Default = 1.
---@param loop? boolean Whether the animation should loop. Default = false.
function Character:addAnimation(name, image, grid, frames, originX, originY, interval, loop)
    assert(not self.animations[name], "Animation with name '" .. name .. "' already exists.")
    self.animations[name] = animation.newAnimation(image, grid, frames, originX, originY, interval, loop)

    if not self.currentAnimation then
        self.currentAnimation = self.animations[name]
    end
end

---Adds a circular collider to the character.
---@param x number The X coordinate of the collider.
---@param y number The Y coordinate of the collider.
---@param radius number The radius of the collider.
---@param type? love.BodyType The type of the collider. Default = "dynamic".
function Character:addCircleCollider(world, x, y, radius, type)
    local _type = type or "dynamic"
    self.collider = physics.newCircleCollider(world, x, y, radius, _type)
end

---Adds a rectangle collider to the character.
---@param x number The X coordinate of the collider.
---@param y number The Y coordinate of the collider.
---@param width number The width of the collider.
---@param height number The height of the collider.
---@param type? love.BodyType The type of the collider. Default = "dynamic".
function Character:addRectangleCollider(world, x, y, width, height, type)
    local _type = type or "dynamic"
    self.collider = physics.newRectangleCollider(world, x, y, width, height, _type)
end

---Adds a new state to the character.
---@param name string The name of the state.
---@param enter? function The function to be called when the state is entered.
---@param update? function The function to be called when the state is updated.
---@param draw? function The function to be called when the state is drawn.
---@param exit? function The function to be called when the state is exited.
function Character:addState(name, enter, update, draw, exit)
    assert(not self.states[name], "State with name '" .. name .. "' already exists.")
    self.states[name] = state.newState(name, enter, update, draw, exit)
    if not self.currentState then
        self.currentState = self.states[name]
    end
end

---Changes the current animation of the character.
---@param anim string The animation of the character to be changed.
function Character:changeAnimation(anim)
    assert(self.animations[anim], "Animation with name '" .. anim .. "' does not exist.")
    self.currentAnimation = self.animations[anim]
    self.currentAnimation:play()
end

---Changes the current state of the character.
---@param _state string The state of the character to be changed.
function Character:changeState(_state)
    assert(self.states[_state], "State with name '" .. _state .. "' does not exist.")
    self.currentState = self.states[_state]
    self:changeAnimation(_state)
end

---Draws the character.
function Character:draw()
    assert(self.currentAnimation, "Character has no current animation.")
    self.currentAnimation:draw(self.x, self.y)
end

---Draws the colliders of the character.
function Character:drawCollider()
    assert(self.collider, "Character has no collider.")
    self.collider:draw()
end

---Gets the current animation of the character.
---@return Animation currentAnimation The current animation of the character.
function Character:getCurrentAnimation()
    return self.currentAnimation
end

---Gets the linear velocity of the collider.
---@return number x The X component of the linear velocity vector.
---@return number y The Y component of the linear velocity vector.
function Character:getLinearVelocity()
    return self.collider:getLinearVelocity()
end

---Gets the position of the character.
---@return number x The X coordinate of the character.
---@return number y The Y coordinate of the character.
function Character:getPosition()
    return self.x, self.y
end

---Moves the character toward a point given a vx and vy velocity.
---@param vx number The X linear velocity.
---@param vy number The Y linear velocity.
function Character:moveTowards(vx, vy)
    self.vx = vx
    self.vy = vy
    self.collider:setLinearVelocity(vx, vy)
end

---Updates the character.
---@param dt number The delta time.
function Character:update(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    -- Updates the current animation
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

return character
