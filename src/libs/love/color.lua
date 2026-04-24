--[[
	Author: Marcus Ferreira
	Description: A color library for LOVE.
]]


--- Library
---@class color
local color = {}


--- Methods
---Converts a hex value to RGB. (output range: 0 - 1)
---@param hex string The hex color value (e.g. "ff0000" or "f00" for red).
---@return number R The red component of the color (0 - 1).
---@return number G The green component of the color (0 - 1).
---@return number B The blue component of the color (0 - 1).
function color.hexToRGB(hex)
	hex = hex:gsub("#", "")
	assert(#hex == 3 or #hex == 6, "Invalid hexadecimal format.")
	if #hex == 3 then
		return tonumber("0x" .. hex:sub(1, 1) .. hex:sub(1, 1)) / 255,
			tonumber("0x" .. hex:sub(2, 2) .. hex:sub(2, 2)) / 255,
			tonumber("0x" .. hex:sub(3, 3) .. hex:sub(3, 3)) / 255
	elseif #hex == 6 then
		return tonumber("0x" .. hex:sub(1, 2)) / 255,
			tonumber("0x" .. hex:sub(3, 4)) / 255,
			tonumber("0x" .. hex:sub(5, 6)) / 255
	end
	return 0, 0, 0
end

return color
