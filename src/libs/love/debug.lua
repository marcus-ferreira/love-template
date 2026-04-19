--[[
	Author: Marcus Ferreira
	Description: A debug library for LOVE.
]]


--- Library
local debugLove = {
    isHidden = true,
    messages = {}
}


--- Methods
---Adds a message in the debug message list.
---@param message string The message to be added.
function debugLove.addMessage(message)
    table.insert(debugLove.messages, message)
end

---Clears the messages in the debug list.
function debugLove.clear()
    debugLove.messages = {}
end

---Prints the debug messages
function debugLove.draw()
    if not debugLove.isHidden then
        for line = 0, #debugLove.messages - 1 do
            love.graphics.print(debugLove.messages[line + 1], 0, line * 8)
        end
    end
end

---Hides the debug messages.
function debugLove.hide()
    debugLove.isHidden = true
end

---Removes a message from the debug message list.
---@param index number The index of the message to be removed.
function debugLove.removeMessage(index)
    table.remove(debugLove.messages, index)
end

---Shows the debug messages.
function debugLove.show()
    debugLove.isHidden = false
end

return debugLove
