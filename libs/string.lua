--[[
	Author: Marcus Ferreira
	Version: 0.1.0
	Date: 20/10/2024
]]

---Simulates Python's f-string functionality, allowing variable interpolation in a string template
---@param template string # The template string containing placeholders in the form `{variable}`
---@return string # The formatted string with interpolated variables
function string.fusion(template)
	-- Utiliza o ambiente global para resolver as variáveis
	local env = _G
	return (template:gsub("{(.-)}", function(key)
		return tostring(env[key] or "")
	end))
end
