--[[
	Author: Marcus Ferreira
	Description: A state library for LOVE.
]]


--- Library
---@class state
local state = {}


--- Classes
---@class State
---@field private name string The name of the state.
---@field private __index? table The index of the state (for iterating).
local State = {}
State.__index = State


--- Methods
---Creates a new State object.
---@param name string The name of the state.
---@param enter? function The function to be called when the state is entered.
---@param update? function The function to be called when the state is updated.
---@param draw? function The function to be called when the state is drawn.
---@param exit? function The function to be called when the state is exited.
---@return State state A new State object.
function state.newState(name, enter, update, draw, exit)
	---@type State
	local self = {
		name = name,
		enter = enter or function() end,
		update = update or function(dt) end,
		draw = draw or function() end,
		exit = exit or function() end
	}
	setmetatable(self, State)
	return self
end

---Calls the draw function of the state.
function State:draw()
	self:draw()
end

---Calls the enter function of the state.
---@param ... any The enter parameters of the state.
function State:enter(...)
	self:enter(...)
end

---Calls the exit function of the state.
function State:exit()
	self:exit()
end

---Gets the state name.
---@return string name The name of the state.
function State:getName()
	return self.name
end

---Calls the update function of the state.
---@param dt number The delta time.
function State:update(dt)
	self:update(dt)
end

return state
