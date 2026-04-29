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
local input = {}
---@type table<string, table<string, string[]>>
input.actions = {}
---@type table<string, boolean>
input.pressedKeys = {}
---@type table<love.Joystick, table<string, boolean>>
input.pressedButtons = {}




--- Methods
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

---Checks if any key of an action is down.
---@param action string The action to check.
---@return boolean isDown True if any key of the action is down, false if otherwise.
function input.isActionDown(action)
    local joysticks = love.joystick.getJoysticks()
    ---@type love.Joystick
    local joystick = joysticks[1]
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
                    if sign == "-" and joystick:getGamepadAxis(axis) < 0 then
                        return true
                    elseif sign == "+" and joystick:getGamepadAxis(axis) > 0 then
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
    local joysticks = love.joystick.getJoysticks()
    ---@type love.Joystick
    local joystick = joysticks[1]
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

return input
