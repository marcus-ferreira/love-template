--[[
	Author: Marcus Ferreira
	Description: A utils library for LOVE.
]]

---Gets the class of an object.
---@param object table The object to get the class.
---@return string class The class of the object.
function getclass(object)
    local _class = object.__class or ""
    return _class
end
