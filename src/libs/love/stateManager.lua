--[[
	Author: Marcus Ferreira
	Description: A state manager library for LOVE.
]]


--- Library
---@class stateManager
local stateManager = {}


--- Classes
---@class StateManager
---@field private states State[] The states of the state manager.
---@field private currentState State|nil The current state of the state manager.
---@field private __index? table The index of the state manager (for iterating).
---@field private __class? string The class of the state manager.
local StateManager = {}
StateManager.__index = StateManager
StateManager.__class = "StateManager"

---@class State
---@field private name string The name of the state.
---@field private __index? table The index of the state (for iterating).
---@field private __class? string The class of the state.
local State = {}
State.__index = State
State.__class = "State"


--- Methods
---Creates a new StateManager object.
---@return StateManager stateManager The new StateManager object.
function stateManager.newStateManager()
	---@type StateManager
	local self = {
		states = {},
		currentState = nil
	}
	setmetatable(self, StateManager)
	return self
end

---Creates a new State object.
---@param name string The name of the state.
---@param enter? function The function to be called when the state is entered.
---@param update? function The function to be called when the state is updated.
---@param draw? function The function to be called when the state is drawn.
---@param exit? function The function to be called when the state is exited.
---@return State state A new State object.
function stateManager.newState(name, enter, update, draw, exit)
	enter  = enter or function() end
	update = update or function(dt) end
	draw   = draw or function() end
	exit   = exit or function() end


	---@type State
	local self = {
		name = name,
		enter = enter,
		update = update,
		draw = draw,
		exit = exit
	}
	setmetatable(self, State)
	return self
end

---Adds a new state to the state manager.
---@param name string The name of the state to be added.
---@param enter? function The function to be called when the state is entered.
---@param update? function The function to be called when the state is updated.
---@param draw? function The function to be called when the state is drawn.
---@param exit? function The function to be called when the state is exited.
function StateManager:addState(name, enter, update, draw, exit)
	assert(not self.states[name], "State '" .. name .. "' already exists.")
	self.states[name] = stateManager.newState(name, enter, update, draw, exit)
	if not self.currentState then
		self.currentState = self.states[name]
	end
end

---Adds a batch of states to the state manager.
---@param states table<string, table<string, function>> The table of states parameters.
function StateManager:addStates(states)
	for name, functions in pairs(states) do
		local enter  = functions["enter"]
		local update = functions["update"]
		local draw   = functions["draw"]
		local exit   = functions["exit"]
		self:addState(name, enter, update, draw, exit)
	end
end

---Changes the current state of the state manager.
---@param name string The name of the state to change to.
---@param ... any The enter parameters of the state.
function StateManager:changeState(name, ...)
	assert(self.states[name], "State '" .. name .. "' does not exists.")
	if self.currentState.exit then
		self.currentState:exit()
	end
	self.currentState = self.states[name]
	if self.currentState.enter then
		self.currentState:enter(...)
	end
end

---Draws the current state of the state manager.
---@param ... any The draw parameters of the state.
function StateManager:draw(...)
	if self.currentState and self.currentState.draw then
		self.currentState:draw(...)
	end
end

---Gets the current state of the state manager.
---@return State|nil state The current state of the state manager.
function StateManager:getCurrentState()
	return self.currentState
end

---Gets a state given its name.
---@param name string The name of the state.
---@return State state The state.
function StateManager:getState(name)
	assert(self.states[name], "State with name '" .. name "' does not exists.")
	return self.states[name]
end

---Updates the current state of the state manager.
---@param dt number The delta time.
function StateManager:update(dt)
	if self.currentState and self.currentState.update then
		self.currentState:update(dt)
	end
end

---Calls the draw function of the state.
function State:draw(...) end

---Calls the enter function of the state.
---@param ... any The enter parameters of the state.
function State:enter(...) end

---Calls the exit function of the state.
function State:exit() end

---Gets the name of the state.
---@return string name The name of the state.
function State:getName()
	return self.name
end

---Sets a function of a state.
---@param name string The name of the function to be changed (enter, update, draw or exit).
---@param func function The function to be called.
function State:setFunction(name, func)
	assert(name == "enter" or name == "update" or name == "draw" or name == "exit", "Function not available to change.")
	assert(type(func) == "function", "func must be a function (enter, update, draw or exit)")
	self[name] = func
end

---Calls the update function of the state.
---@param dt number The delta time.
function State:update(dt) end

return stateManager
