--[[
    Author: Marcus Ferreira
    Description: A entity library for LOVE.
]]


--- Imports
require("src.libs.lua.table")


--- Library
---@class input
local input = {}
input.actions = {}
input.keys = {}
input.joysticks = {}
input.buttons = {}


--- Methods
---Adds a joystick.
---@param joystick love.Joystick The joystick to be added.
function input.addJoystick(joystick)
    table.insert(input.joysticks, joystick)
    input.buttons[joystick] = {}
end

---Gets the keys of an action.
---@param action string The name of the action.
---@return table|nil keys The keys of the action.
function input.getActionKeys(action)
    local actionKeys = {
        ["keyboard"] = {},
        ["gamepad"] = {}
    }
    for type, keys in pairs(input.actions[action]) do
        for _, key in ipairs(keys) do
            table.insert(actionKeys[type], key)
        end
    end
    return actionKeys
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
            if type == "keyboard" and love.keyboard.isDown(key) then
                return true
            elseif type == "gamepad" and (joystick and joystick:isGamepadDown(key)) then
                return true
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
            if type == "keyboard" and input.keys[key] then
                return true
            elseif type == "gamepad" and (joystick and input.buttons[joystick][key]) then
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
    input.buttons[joystick][button] = true
end

---Callback function to set a gamepad button to false.
---@param joystick love.Joystick The joystick to set the button.
---@param button love.GamepadButton The button to set false.
function input.gamepadreleased(joystick, button)
    input.buttons[joystick][button] = false
end

---Callback function to set a key to true.
---@param key love.KeyConstant The key to set true.
function input.keypressed(key)
    input.keys[key] = true
end

---Callback function to set a key to false.
---@param key love.KeyConstant The key to set false.
function input.keyreleased(key)
    input.keys[key] = false
end

---Removes a joystick.
---@param joystick love.Joystick The joystick to be removed.
function input.removeJoystick(joystick)
    input.joysticks[joystick] = nil
    input.buttons[joystick] = nil
end

---Sets all the keys to false.
function input.resetPressedKeys()
    input.keys = {}
    for joystick, _ in pairs(input.buttons) do
        input.buttons[joystick] = {}
    end
end

---Assigns a key to an action.
---@param action string The name of the action to receive a key.
---@param type "keyboard"|"gamepad" The type of the key.
---@param key love.KeyConstant The key to assign.
function input.setActionKey(action, type, key)
    if not input.actions[action] then
        input.actions[action] = {
            ["keyboard"] = {},
            ["gamepad"] = {}
        }
    end
    assert(not table.contains(input.actions[action][type], key),
        "Key '" .. key .. "' already assigned to action '" .. action .. "'.")
    table.insert(input.actions[action][type], key)
end

---Assigns a table of keys to any number of actions.
---@param actions table<string, table<string, table<love.KeyConstant|love.GamepadButton>>> A table of actions, composed by a table of keys.
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
