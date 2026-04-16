--[[
	Author: Marcus Ferreira
	Description: A state machine library for LOVE.
]]


---@class StateMachine
StateMachine = {}
StateMachine.__index = StateMachine

---Creates a new StateMachine object.
---@return StateMachine # A new StateMachine object.
function StateMachine.new()
	---@class StateMachine
	local self = setmetatable({}, StateMachine)
	self.states = {}
	self.current = nil
	return self
end

---Adds a new state to the state machine.
---@param name string # The name of the state.
---@param enter? function # The function to be called when the state is entered.
---@param update? function # The function to be called when the state is updated.
---@param draw? function # The function to be called when the state is drawn.
---@param exit? function # The function to be called when the state is exited.
---@return State # The created state.
function StateMachine:addNewState(name, enter, update, draw, exit)
	---@class State
	local state = {}
	state.name = name
	state.enter = enter or function() end
	state.update = update or function(dt) end
	state.draw = draw or function() end
	state.exit = exit or function() end
	self.states[name] = state
	return state
end

---Changes the current state of the state machine.
---@param name string # The name of the state.
---@param ... any # The enter parameters of the state.
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

---Updates the current state of the state machine.
---@param dt number # The delta time.
function StateMachine:update(dt)
	if self.current and self.current.update then
		self.current:update(dt)
	end
end

---Draws the current state of the state machine.
function StateMachine:draw()
	if self.current and self.current.draw then
		self.current:draw()
	end
end
