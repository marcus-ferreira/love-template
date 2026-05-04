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


---@alias EntityBehaviors
---| "platformer" Adds a platformer behavior, with movement and jump, for example.
---| "grid" Adds a grid movement behavior.
---| "8Directions" Adds a 8 direction movement behavior.


--- Classes
---@class Entity
---@field private stateManager StateManager The state manager of the Entity.
---@field private animationManager AnimationManager The animation manager of the Entity.
---@field private collider Collider The collider of the Entity.
---@field private behaviors EntityBehaviors[] The table of behaviors of the Entity.
---@field private variables table<string, any> The table of variables of the Entity.
---@field private __index? table The index of the Entity (for iterating).
---@field private __class? string The class of the Entity.
local Entity = {}
Entity.__index = Entity
Entity.__class = "Entity"


--- Methods
---Creates a new Entity object.
---@param world World The world for the collider of the Entity.
---@param x number The X coordinate of the Entity.
---@param y number The Y coordinate of the Entity.
---@param bodyType love.BodyType The type of the body of the collider of the Entity.
---@param config? table The table of the fixtures, animations and states of the Entity.
---@return Entity entity A new Entity object.
function entity.newEntity(world, x, y, bodyType, config)
    config = config or {}


    ---@type Entity
    local self = {
        stateManager = stateManager.newStateManager(config.states),
        animationManager = animationManager.newAnimationManager(config.animations),
        collider = physics.newCollider(world, x, y, bodyType, config.fixtures),
        behaviors = {},
        variables = {}
    }
    setmetatable(self, Entity)
    return self
end

---Shorthand function to create a new platformer Entity.
---@param world World The world for the collider of the Entity.
---@param x number The X coordinate of the Entity.
---@param y number The Y coordinate of the Entity.
---@param speed? number The value of the speed variable of the Entity.
---@param jumpForce? number The value of the jumpForce variable of the Entity.
---@param config? table The table of the fixtures, animations and states of the Entity.
---@return Entity entity A new Entity object.
function entity.newPlatformerEntity(world, x, y, speed, jumpForce, config)
    speed     = speed or 100
    jumpForce = jumpForce or 300


    local self = entity.newEntity(world, x, y, "dynamic", config)
    self:addBehavior("platformer")
    self:setVariables({
        ["speed"] = speed,
        ["jumpForce"] = jumpForce
    })
    return self
end

---Shorthand function to create a new static Entity.
---@param world World The world for the collider of the Entity.
---@param name string The name of the fixture of the Entity.
---@param x number The X coordinate of the Entity.
---@param y number The Y coordinate of the Entity.
---@param width number The width of the Entity.
---@param height number The height of the Entity.
---@return Entity entity A new Entity object.
function entity.newStaticEntity(world, name, x, y, width, height)
    local self = entity.newEntity(world, x, y, "static")
    self:getCollider():addFixture(name, "polygon", false, 0, 0, width, height)
    return self
end

---Adds a behavior to the Entity.
---@param name EntityBehaviors The name of the behavior to add.
function Entity:addBehavior(name)
    assert(not table.contains(self.behaviors, name), "Entity already has behavior with name '" .. name .. "'.")
    table.insert(self.behaviors, name)
end

---Draws the Entity.
function Entity:draw()
    local x, y = self.collider:getBody():getPosition()
    self.stateManager:draw()
    self.animationManager:draw(x, y)
end

---Shorthand to draw everything from the Entity (animation, collider and originPoint of the current animation).
function Entity:drawAll()
    local x, y = self.collider:getBody():getPosition()
    local currentAnimation = self:getAnimationManager():getCurrentAnimation()
    self:draw()
    self:getCollider():draw()
    if currentAnimation then
        self:getAnimationManager():getCurrentAnimation():drawOriginPoint(x, y)
    end
end

---Gets the animation manager of the Entity.
---@return AnimationManager animationManager The animation manager.
function Entity:getAnimationManager()
    return self.animationManager
end

---Gets the behaviors of the Entity.
---@return EntityBehaviors[] behaviors The behaviors of the Entity.
function Entity:getBehavior()
    return self.behaviors
end

---Gets the collider of the Entity.
---@return Collider collider The collider of the Entity.
function Entity:getCollider()
    return self.collider
end

---Gets the state manager of the Entity.
---@return StateManager stateManager The state manager of the Entity.
function Entity:getStateManager()
    return self.stateManager
end

---Gets the value of a variable of the Entity.
---@param name string The name of the variable of the Entity.
---@return any value The value of the variable of the Entity.
function Entity:getVariable(name)
    assert(self.variables[name], "Variable with name '" .. name .. "' does not exists.")
    return self.variables[name]
end

---Gets the variables of the Entity.
---@return table<string, any> variables The list of variables of the Entity.
function Entity:getVariables()
    return self.variables
end

---Checks if the Entity is by a wall.
---@return boolean isByWall True if the Entity is by a wall, false otherwise.
function Entity:isByWall()
    return self.collider:isTouching("wall")
end

---Checks if the Entity is on the floor.
---@return boolean isOnFloor True if the Entity is on the floor, false otherwise.
function Entity:isOnFloor()
    return self.collider:isTouching("ground")
end

---Jumps a platformer Entity.
function Entity:jump()
    if table.contains(self.behaviors, "platformer") then
        assert(self.variables["jumpForce"], "jumpForce variable not set.")
        local jumpForce = self.variables["jumpForce"]
        local vx, _ = self.collider:getBody():getLinearVelocity()
        self.collider:getBody():setLinearVelocity(vx, -jumpForce)
    end
end

---Moves a Entity according to a behavior.
---@param vx number The x velocity of the Entity.
---@param vy number The y velocity of the Entity.
function Entity:move(vx, vy)
    if table.contains(self.behaviors, "8Directions") then
        assert(self.variables["speed"], "speed variable not set.")
        local speed = self.variables["speed"]
        local moveVector = vector.newVector2(vx, vy) * speed
        self.collider:getBody():setLinearVelocity(moveVector:getX(), moveVector:getY())
    elseif table.contains(self.behaviors, "platformer") then
        assert(self.variables["speed"], "speed variable not set.")
        local _, currentVY = self.collider:getBody():getLinearVelocity()
        local targetVX = vx * self.variables["speed"]
        self.collider:getBody():setLinearVelocity(targetVX, currentVY)

        if vx < 0 then
            self.animationManager:flipAnimationsHorizontally(true)
        elseif vx > 0 then
            self.animationManager:flipAnimationsHorizontally(false)
        end
    end
end

---Removes a behavior from the Entity.
---@param name EntityBehaviors The name of the behavior to remove.
function Entity:removeBehavior(name)
    for i, behavior in ipairs(self.behaviors) do
        if behavior == name then
            table.remove(self.behaviors, i)
        end
    end
end

---Sets a new value to a variable.
---@param name string The name of the variable.
---@param value any The new value of the variable.
function Entity:setVariable(name, value)
    assert(name, "Variable name not informed.")
    self.variables[name] = value
end

---Sets a value to a table of variables.
---@param variables table<string, any> The table of variables to set.
function Entity:setVariables(variables)
    variables = variables or {}
    for variable, value in pairs(variables) do
        self:setVariable(variable, value)
    end
end

---Updates the Entity.
---@param dt number The delta time.
function Entity:update(dt)
    self.stateManager:update(dt)
    self.animationManager:update(dt)
end

return entity
