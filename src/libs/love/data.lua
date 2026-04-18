--[[
	Author: Marcus Ferreira
	Description: A data library for LOVE.
]]


--- Library
---@class data
local data = {}


--- Methods
---Saves game data to a file.
---@param fileName string The name of the file to save the data to.
---@param gameData table The game data to save.
function data.saveData(fileName, gameData)
	local serializedString = "{"
	for k, v in pairs(gameData) do
		serializedString = serializedString .. k .. "=" .. v .. ","
	end
	serializedString = string.sub(serializedString, 1, -2) .. "}"

	love.filesystem.write(fileName, serializedString)
end

---Loads game data from a file.
---@param fileName string The name of the file to load the data from.
---@return table | nil deserializedTable The loaded game data or nil if the file could not be read.
function data.loadData(fileName)
	local fileString = love.filesystem.read(fileName)
	if fileString == nil then return end

	local deserializedTable = {}
	for k, v in string.gmatch(fileString, "(%w+)=(%d+)") do deserializedTable[k] = tonumber(v) end
	for k, v in string.gmatch(fileString, "(%w+)=(%a+)") do deserializedTable[k] = v end

	return deserializedTable
end

return data
