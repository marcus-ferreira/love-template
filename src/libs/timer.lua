--[[
	Author: Marcus Ferreira
    Description: A timer library for LOVE.
]]


---@class Timer
Timer = {}
Timer.__index = Timer

---Creates a new Timer object.
---@return Timer # A new Timer object.
function Timer.new()
    ---@class Timer
    local self = setmetatable({}, Timer)
    self.time = 0
    self.states = {
        NOT_STARTED = 1,
        ACTIVE = 2,
        FINISHED = 3
    }
    self.currentState = self.states.NOT_STARTED
    return self
end

---Updates the timer.
---@param dt number # The delta time.
function Timer:update(dt)
    if self:isActive() then
        self.time = self.time - dt
        if self.time <= 0 then
            self:finish()
        end
    end
end

---Starts the timer with a specific time.
---@param time number # The time of the timer in seconds.
function Timer:start(time)
    self.time = time
    self.currentState = self.states.ACTIVE
end


---Resets the timer.
function Timer:reset()
    self.time = 0
    self.currentState = self.states.NOT_STARTED
end

---Finishes the timer.
function Timer:finish()
    self.currentState = self.states.FINISHED
end

---Checks if the timer was not started.
---@return boolean # True if the timer was not started, false otherwise.
function Timer:wasNotStarted()
    return self.currentState == self.states.NOT_STARTED
end

---Checks if the timer is active.
---@return boolean # True if the timer is active, false otherwise.
function Timer:isActive()
    return self.currentState == self.states.ACTIVE
end

---Checks if the timer is finished.
---@return boolean # True if the timer is finished, false otherwise.
function Timer:isFinished()
    return self.currentState == self.states.FINISHED
end
