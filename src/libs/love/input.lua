--[[
    Author: Marcus Ferreira
    Description: A entity library for LOVE.
]]


--- Imports
require("src.libs.lua.table")


---@alias SignaledGamepadAxis
---| "leftx-"
---| "leftx+"
---| "lefty-"
---| "lefty+"
---| "rightx-"
---| "rightx+"
---| "righty-"
---| "righty+"
---| "triggerleft-"
---| "triggerleft+"
---| "triggerright-"
---| "triggerright+"


--- Library
---@class input
local input = {
    ---@type table<string, table<string, string[]>>
    actions         = {},
    ---@type table<string, boolean>
    pressedKeys     = {},
    ---@type table<love.Joystick, table<string, boolean>>
    pressedButtons  = {},
    gamepadDeadzone = 0.15
}


--- Methods
--- Callbacks
---@param key love.KeyConstant
function love.keypressed(key)
    input.keypressed(key)
end

---@param key love.KeyConstant
function love.keyreleased(key)
    input.keyreleased(key)
end

---@param joystick love.Joystick
---@param button love.GamepadButton
function love.gamepadpressed(joystick, button)
    input.gamepadpressed(joystick, button)
end

---@param joystick love.Joystick
function love.joystickadded(joystick)
    input.addJoystick(joystick)
end

---@param joystick love.Joystick
function love.joystickremoved(joystick)
    input.removeJoystick(joystick)
end

---Adds a joystick.
---@param joystick love.Joystick The joystick to be added.
function input.addJoystick(joystick)
    input.pressedButtons[joystick] = {}
end

---Gets the keys of an action.
---@param action string The name of the action.
---@return table keys The keys of the action.
function input.getActionKeys(action)
    return input.actions[action]
end

---Gets the axis value of a movement action.
---@param negativeAction string The action related to a negative movement ("up" and "left", for example).
---@param positiveAction string The action related to a positive movement ("down" and "right", for example).
---@param gamepadAxis? love.GamepadAxis The axis of the gamepad.
---@return number axisValue The value of the axis (1 or 0 for keyboard and -1 to 1 for gamepad).
function input.getAxis(negativeAction, positiveAction, gamepadAxis)
    local value = 0

    local neg = input.isActionDown(negativeAction) and 1 or 0
    local pos = input.isActionDown(positiveAction) and 1 or 0
    value = pos - neg

    ---@type love.Joystick
    local joystick = love.joystick.getJoysticks()[1]
    if joystick and gamepadAxis then
        local axisValue = joystick:getGamepadAxis(gamepadAxis)
        if math.abs(axisValue) > input.gamepadDeadzone then
            value = axisValue
        end
    end

    return value
end

---Checks if any key of an action is down.
---@param action string The action to check.
---@return boolean isDown True if any key of the action is down, false if otherwise.
function input.isActionDown(action)
    ---@type love.Joystick
    local joystick = love.joystick.getJoysticks()[1]
    for type, keys in pairs(input.actions[action]) do
        for _, key in ipairs(keys) do
            if type == "keys" and love.keyboard.isDown(key) then
                return true
            elseif joystick then
                if type == "buttons" and joystick:isGamepadDown(key) then
                    return true
                elseif type == "axes" then
                    local axis = key:sub(1, -2)
                    local sign = key:sub(-1)
                    if sign == "-" and joystick:getGamepadAxis(axis) < -input.gamepadDeadzone then
                        return true
                    elseif sign == "+" and joystick:getGamepadAxis(axis) > input.gamepadDeadzone then
                        return true
                    end
                end
            end
        end
    end
    return false
end

---Checks if any key of an action is pressed.
---@param action string The action to check.
---@return boolean isActionPressed True if any key of a given action is pressed, false if otherwise.
function input.isActionPressed(action)
    ---@type love.Joystick
    local joystick = love.joystick.getJoysticks()[1]
    for type, keys in pairs(input.actions[action]) do
        for _, key in ipairs(keys) do
            if type == "keys" and input.pressedKeys[key] then
                return true
            elseif type == "buttons" and (joystick and input.pressedButtons[joystick][key]) then
                return true
            end
        end
    end
    return false
end

---Callback function to set a gamepad button to true.
---@param joystick love.Joystick The joystick to set the button.
---@param button love.GamepadButton The button to set true.
function input.gamepadpressed(joystick, button)
    input.pressedButtons[joystick][button] = true
end

---Callback function to set a gamepad button to false.
---@param joystick love.Joystick The joystick to set the button.
---@param button love.GamepadButton The button to set false.
function input.gamepadreleased(joystick, button)
    input.pressedButtons[joystick][button] = false
end

---Callback function to set a key to true.
---@param key love.KeyConstant The key to set true.
function input.keypressed(key)
    input.pressedKeys[key] = true
end

---Callback function to set a key to false.
---@param key love.KeyConstant The key to set false.
function input.keyreleased(key)
    input.pressedKeys[key] = false
end

---Removes a joystick.
---@param joystick love.Joystick The joystick to be removed.
function input.removeJoystick(joystick)
    input.pressedButtons[joystick] = nil
end

---Sets all the keys to false.
function input.resetPressedKeys()
    input.pressedKeys = {}
    for joystick, _ in pairs(input.pressedButtons) do
        input.pressedButtons[joystick] = {}
    end
end

---Assigns a key to an action.
---@param action string The name of the action to receive a key.
---@param type "keys"|"buttons"|"axes" The type of the key.
---@param key love.KeyConstant|love.GamepadButton|SignaledGamepadAxis The key to assign.
function input.setActionKey(action, type, key)
    if not input.actions[action] then
        input.actions[action] = { keys = {}, buttons = {}, axes = {} }
    end
    assert(not table.contains(input.actions[action][type], key),
        "Key '" .. key .. "' already assigned to action '" .. action .. "'.")
    table.insert(input.actions[action][type], key)
end

---Assigns a table of keys to any number of actions.
---@param actions table<string, table<string, (love.KeyConstant|love.GamepadButton|SignaledGamepadAxis)[]>> A table of actions, composed by a table of keys.
function input.setActionsKeys(actions)
    for action, types in pairs(actions) do
        for type, keys in pairs(types) do
            for _, key in ipairs(keys) do
                input.setActionKey(action, type, key)
            end
        end
    end
end

---Sets a new gamepad deadzone value.
---@param value number The new value of the gamepad deadzone.
function input.setDeadzone(value)
    assert(value >= 0 or value <= 1, "Invalid deadzone value.")
    input.gamepadDeadzone = value
end

return input
