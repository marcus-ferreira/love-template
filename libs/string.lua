--[[
	Author: Marcus Ferreira
	20/10/2024 - 0.1.0v - Initial
]]

---Simulates Python's f-string functionality, allowing variable interpolation in a string template
---@param template string # The template string containing placeholders in the form `{variable}`
---@return string # The formatted string with interpolated variables
function string.fusion(template)
	return (template:gsub("{(.-)}", function(key)
		return tostring(_G[key] or "")
	end))
end
