--[[
	Author: Marcus Ferreira
	18/10/2024 - 0.2.0v - Initial
]]


---@class state
state = {}

---@class StateMachine
StateMachine = {}
StateMachine.__index = StateMachine

---@class State
State = {}
State.__index = State


---Creates a new State Machine
---@return StateMachine
function state.newStateMachine()
	---@class StateMachine
	local self = setmetatable({}, StateMachine)
	self.states = {}
	self.current = nil
	return self
end

---Creates a new State
---@param enter? function
---@param update? function
---@param draw? function
---@param exit? function
---@return State
function state.newState(enter, update, draw, exit)
	---@class State
	local self = setmetatable({}, State)
	self.enter = enter or function() end
	self.update = update or function(dt) end
	self.draw = draw or function() end
	self.exit = exit or function() end
	return self
end

---Adds a state to the State Machine
---@param name string
---@param state State
function StateMachine:addState(name, state)
	self.states[name] = state
end

---Changes the state to another
---@param name string # The name of the state
---@param ... any # The enter parameters of the state
function StateMachine:changeState(name, ...)
	if self.states[name] then
		if self.current and self.current.exit then
			self.current:exit()
		end
		self.current = self.states[name]
		if self.current.enter then
			self.current:enter(...)
		end
	end
end

---Updates the state
---@param dt number # Delta time
function StateMachine:update(dt)
	if self.current and self.current.update then
		self.current:update(dt)
	end
end

---Draws the state
function StateMachine:draw()
	if self.current and self.current.draw then
		self.current.draw()
	end
end
