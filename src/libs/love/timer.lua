--[[
	Author: Marcus Ferreira
    Description: A timer library for LOVE.
]]


--- Library
---@class timer
local timer = {}


--- Enums
---@enum timerState
local timerState = {
    NOT_STARTED = 1,
    ACTIVE = 2,
    FINISHED = 3
}


--- Classes
---@class Timer
---@field private time number The time of the timer in seconds.
---@field private currentState number The current state of the timer.
---@field private __index? table The index of the timer (for iterating).
local Timer = {}
Timer.__index = Timer


--- Methods
---Creates a new Timer object.
---@return Timer # A new Timer object.
function timer.newTimer()
    ---@type Timer
    local self = {
        time = 0,
        currentState = timerState.NOT_STARTED
    }
    setmetatable(self, Timer)
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

---Gets the time of the timer.
---@return number # The time of the timer in seconds.
function Timer:getTime()
    return self.time
end

---Starts the timer with a specific time.
---@param time number # The time of the timer in seconds.
function Timer:start(time)
    self.time = time
    self.currentState = timerState.ACTIVE
end

---Resets the timer.
function Timer:reset()
    self.time = 0
    self.currentState = timerState.NOT_STARTED
end

---Finishes the timer.
function Timer:finish()
    self.time = 0
    self.currentState = timerState.FINISHED
end

---Checks if the timer was not started.
---@return boolean # True if the timer was not started, false otherwise.
function Timer:wasNotStarted()
    return self.currentState == timerState.NOT_STARTED
end

---Checks if the timer is active.
---@return boolean # True if the timer is active, false otherwise.
function Timer:isActive()
    return self.currentState == timerState.ACTIVE
end

---Checks if the timer is finished.
---@return boolean # True if the timer is finished, false otherwise.
function Timer:isFinished()
    return self.currentState == timerState.FINISHED
end

return timer
