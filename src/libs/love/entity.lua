--[[
    Author: Marcus Ferreira
    Description: A entity library for LOVE.
]]


--- Imports
local animationManager = require("src.libs.love.animationManager")
local physics          = require("src.libs.love.physics")
local stateManager     = require("src.libs.love.stateManager")
local vector           = require("src.libs.love.vector")


--- Library
local entity = {}


--- Classes
---@class Entity
---@field private stateManager StateManager The state manager of the entity.
---@field private animationManager AnimationManager The animation manager of the entity.
---@field private collider RectangleCollider|CircleCollider The collider of the entity.
---@field private variables table<string, any> The table of variables of the entity.
---@field private __index? table The index of the Entity (for iterating).
local Entity = {}
Entity.__index = Entity


--- Methods
---Creates a new entity object.
---@param world World The world for the collider of the entity.
---@param x number The X coordinate of the entity.
---@param y number The Y coordinate of the entity.
---@param width number The width of the entity.
---@param height number The height of the entity.
---@param type love.BodyType The type of the collider of the entity.
---@return Entity entity A new entity object.
function entity.newEntity(world, x, y, width, height, type)
    ---@type Entity
    local self = {
        stateManager = stateManager.newStateManager(),
        animationManager = animationManager.newAnimationManager(),
        collider = physics.newRectangleCollider(world:getWorld(), x, y, width, height, type),
        variables = {}
    }
    setmetatable(self, Entity)
    return self
end

---Draws the entity.
function Entity:draw()
    local x, y = self.collider:getBody():getPosition()
    self.stateManager:draw()
    self.animationManager:draw(x, y)
end

---Shorthand to draw everything from the entity (animation, collider and originPoint of the current animation).
function Entity:drawAll()
    local x, y = self.collider:getBody():getPosition()
    local currentAnimation = self:getAnimationManager():getCurrentAnimation()
    self:draw()
    self:getCollider():draw()
    if currentAnimation then
        self:getAnimationManager():getCurrentAnimation():drawOriginPoint(x, y)
    end
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

---Gets the state manager of the entity.
---@return StateManager stateManager The state manager of the entity.
function Entity:getStateManager()
    return self.stateManager
end

---Gets the value of a variable of the entity.
---@param name string The name of the variable of the entity.
---@return any value The value of the variable of the entity.
function Entity:getVariable(name)
    assert(self.variables[name], "Variable with name '" .. name .. "' does not exists.")
    return self.variables[name]
end

---Gets the variables of the entity.
---@return table<string, any> variables The list of variables of the entity.
function Entity:getVariables()
    return self.variables
end

---Moves the entity given a speed.
---@param vx number The horizontal velocity to move the entity.
---@param vy number The vertical velocity to move the entity.
---@param force number The force to move the entity.
function Entity:move(vx, vy, force)
    if vx == 0 and vy == 0 then return end
    local direction = vector.newVector2(vx, vy):normalize()
    local forceVector = direction * force
    self.collider:getBody():applyForce(forceVector:getX(), forceVector:getY())
end

---Sets a new value to a variable.
---@param name string The name of the variable.
---@param value any The new value of the variable.
function Entity:setVariable(name, value)
    self.variables[name] = value
end

---Sets a value to a table of variables.
---@param variables table<string, any>
function Entity:setVariables(variables)
    for variable, value in pairs(variables) do
        self:setVariable(variable, value)
    end
end

---Updates the entity.
---@param dt number The delta time.
function Entity:update(dt)
    self.stateManager:update(dt)
    self.animationManager:update(dt)
end

return entity
