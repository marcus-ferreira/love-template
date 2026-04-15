--[[
	Author: Marcus Ferreira
	09/12/2023 - 0.1.2v - Initial
]]

---@class data
data = {}

function data.save(fileName, gameData)
	local serializedString = "{"
	for k, v in pairs(gameData) do serializedString = serializedString .. k .. "=" .. v .. "," end
	serializedString = string.sub(serializedString, 1, -2) .. "}"

	love.filesystem.write(fileName, serializedString)
end

function data.load(fileName)
	local fileString = love.filesystem.read(fileName)
	if fileString == nil then return end

	local deserializedTable = {}
	for k, v in string.gmatch(fileString, "(%w+)=(%d+)") do deserializedTable[k] = tonumber(v) end
	for k, v in string.gmatch(fileString, "(%w+)=(%a+)") do deserializedTable[k] = v end

	return deserializedTable
end
