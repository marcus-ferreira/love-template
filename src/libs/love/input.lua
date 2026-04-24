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


--- Methods
---Gets the keys of an action.
---@param name string The name of the action.
---@return table|nil keys The keys of the action.
function input.getActionKeys(name)
    return input.actions[name]
end

---Checks if any key of an action is down.
---@param action string The action to check.
---@return boolean isDown True if any key of the action is down, false if otherwise.
function input.isActionDown(action)
    for _, key in ipairs(input.actions[action]) do
        if love.keyboard.isDown(key) then
            return true
        end
    end
    return false
end

---Checks if any key of an action is pressed.
---@param action string The action to check.
---@return boolean isActionPressed True if any key of a given action is pressed, false if otherwise.
function input.isActionPressed(action)
    for _, key in ipairs(input.actions[action]) do
        if input.keys[key] then
            return true
        end
    end
    return false
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

---Sets all the keys to false.
function input.resetPressedKeys()
    input.keys = {}
end

---Assigns a key to an action.
---@param name string The name of the action to receive a key.
---@param key love.KeyConstant The key to assign.
function input.setActionKey(name, key)
    if not input.actions[name] then
        input.actions[name] = {}
    end
    assert(not table.contains(input.actions[name], key),
        "Key '" .. key .. "' already assigned to action '" .. name .. "'.")
    table.insert(input.actions[name], key)
end

---Assigns a table of keys to any number of actions.
---@param actions table<string, table> A table of actions, composed by a table of keys.
function input.setActionsKeys(actions)
    for name, keys in pairs(actions) do
        for _, key in ipairs(keys) do
            input.setActionKey(name, key)
        end
    end
end

return input
