--[[
	Author: Marcus Ferreira
	18/10/2024 - 0.1.1v - Initial
]]

---Creates a sliced table
---@param tbl table # The table to be sliced
---@param first? number # The first index of the sliced table. Default is 1
---@param last? number # The last index of the sliced table. Default is the last key
---@return table table # The sliced table
function table.slice(tbl, first, last)
	local sliced = {}
	for i = first or 1, last or #tbl do
		sliced[#sliced + 1] = tbl[i]
	end
	return sliced
end

---Return the first index with the given value (or nil if not found).
---@param tbl table # The table to search
---@param value any # The value to be searched
---@return number | nil index # The index of the value
function table.indexOf(tbl, value)
	for i, v in ipairs(tbl) do
		if v == value then
			return i
		end
	end
	return nil
end

---Serialize a table to a string
---@param tbl table # The table to be serialized
---@param indent? number # The indentation value
---@return string result # The serialized string
function table.serialize(tbl, indent)
	indent = indent or 0
	local result = "{\n"
	for k, v in pairs(tbl) do
		result = result .. string.rep("  ", indent + 1)
		if type(k) == "number" then
			result = result .. "[" .. k .. "] = "
		elseif type(k) == "string" then
			result = result .. k .. " = "
		end

		if type(v) == "number" then
			result = result .. v .. ",\n"
		elseif type(v) == "string" then
			result = result .. "\"" .. v .. "\",\n"
		elseif type(v) == "table" then
			result = result .. table.serialize(v, indent + 1) .. ",\n"
		else
			result = result .. "\"" .. tostring(v) .. "\",\n"
		end
	end
	result = result .. string.rep("  ", indent) .. "}"
	return result
end

---deserialize a string to a table
---@param str string # The string to be deserialized
---@return function # The deserialize table
function table.deserialize(str)
	local func = load("return " .. str)
	if func then return func() end
	error("String incorreta.")
end

---Prints a Table content
---@param tbl table
function table.print(tbl, indent)
	indent = indent or 0
	local indentStr = string.rep("  ", indent)
	for k, v in pairs(tbl) do
		local keyStr = tostring(k)
		if type(v) == "table" then
			print(indentStr .. keyStr .. " = {")
			table.print(v, indent + 1)
			print(indentStr .. "}")
		else
			local valueStr = tostring(v)
			print(indentStr .. keyStr .. " = " .. valueStr)
		end
	end
end
