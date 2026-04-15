--[[
	Author: Marcus
	18/10/2024 - 0.1.3v - Initial
]]

---@class color
color = {}

---Converts a hex (given without '#') value to RGB. (output range: 0 - 1)
---@param hex string
---@return number? R
---@return number? G
---@return number? B
function color.hexToRGB(hex)
	hex = hex:gsub("#", "")
	if #hex == 3 then
		return tonumber("0x" .. hex:sub(1, 1) .. hex:sub(1, 1)) / 255,
			tonumber("0x" .. hex:sub(2, 2) .. hex:sub(2, 2)) / 255,
			tonumber("0x" .. hex:sub(3, 3) .. hex:sub(3, 3)) / 255
	elseif #hex == 6 then
		return tonumber("0x" .. hex:sub(1, 2)) / 255,
			tonumber("0x" .. hex:sub(3, 4)) / 255,
			tonumber("0x" .. hex:sub(5, 6)) / 255
	else
		error("Formato hexadecimal inválido.")
	end
end
