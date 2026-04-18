--[[
	Author: Marcus Ferreira
	Description: A state machine library for LOVE.
]]


--- Library
---@class stateMachine
local stateMachine = {}


--- Classes
---@class StateMachine
---@field private states State<string, State> The states of the state machine.
---@field private currentState State The current state of the state machine.
---@field private __index? table The index of the state machine (for iterating).
local StateMachine = {}
StateMachine.__index = StateMachine

---@class State
---@field private name string The name of the state.
---@field private __index? table The index of the state (for iterating).
local State = {}
State.__index = State


--- Methods
---Creates a new StateMachine object.
---@return StateMachine # A new StateMachine object.
function stateMachine.newStateMachine()
	---@type StateMachine
	local self = {
		states = {},
		currentState = stateMachine.newState("default")
	}
	setmetatable(self, StateMachine)
	return self
end

---Adds a state to the state machine.
---@param state State # The state to be added.
function StateMachine:addState(state)
	assert(not self.states[state:getName()], "State '" .. state:getName() .. "' already exists.")
	self.states[state:getName()] = state
end

---Changes the current state of the state machine.
---@param state State # The state to change to.
---@param ... any # The enter parameters of the state.
function StateMachine:changeState(state, ...)
	assert(self.states[state:getName()], "State '" .. state:getName() .. "' does not exist.")
	if self.currentState.exit then
		self.currentState:exit()
	end
	self.currentState = state
	if self.currentState.enter then
		self.currentState:enter(...)
	end
end

function StateMachine:getCurrentState()
	return self.currentState:getName()
end

---Updates the current state of the state machine.
---@param dt number # The delta time.
function StateMachine:update(dt)
	if self.currentState.update then
		self.currentState:update(dt)
	end
end

---Draws the current state of the state machine.
function StateMachine:draw()
	if self.currentState.draw then
		self.currentState:draw()
	end
end

---Creates a new State object.
---@param name string # The name of the state.
---@param enter? function # The function to be called when the state is entered.
---@param update? function # The function to be called when the state is updated.
---@param draw? function # The function to be called when the state is drawn.
---@param exit? function # The function to be called when the state is exited.
---@return State # A new State object.
function stateMachine.newState(name, enter, update, draw, exit)
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

---Gets the state name.
---@return string # The name of the state.
function State:getName()
	return self.name
end

---Calls the enter function of the state.
---@param ... any # The enter parameters of the state.
function State:enter(...)
	self:enter(...)
end

---Calls the update function of the state.
---@param dt number # The delta time.
function State:update(dt)
	self:update(dt)
end

---Calls the draw function of the state.
function State:draw()
	self:draw()
end

---Calls the exit function of the state.
function State:exit()
	self:exit()
end

return stateMachine
