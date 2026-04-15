--[[
	Author: Marcus Ferreira
	07/06/2025 - 0.0.1v - Implement
]]


---@class Timer
local Timer = {}
Timer.__index = Timer


---@return Timer
function Timer.new()
    ---@class Timer
    local self        = setmetatable({}, Timer)
    self.time         = 0
    self.states       = {
        NOT_STARTED = 1,
        ACTIVE      = 2,
        FINISHED    = 3
    }
    self.currentState = self.states.NOT_STARTED
    return self
end

---@param dt number
function Timer:update(dt)
    if self:isActive() then
        self.time = self.time - dt
        if self.time <= 0 then
            self:finish()
        end
    end
end

---@param time number
function Timer:start(time)
    self.time         = time
    self.currentState = self.states.ACTIVE
end

function Timer:reset()
    self.time         = 0
    self.currentState = self.states.NOT_STARTED
end

function Timer:finish()
    self.currentState = self.states.FINISHED
end

function Timer:wasNotStarted()
    return self.currentState == self.states.NOT_STARTED
end

function Timer:isActive()
    return self.currentState == self.states.ACTIVE
end

function Timer:isFinished()
    return self.currentState == self.states.FINISHED
end

return Timer
