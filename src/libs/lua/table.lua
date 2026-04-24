--[[
	Author: Marcus Ferreira
	Description: A timer library for LOVE.
]]


---Checks if a table contains a value.
---@param t table The table to check on.
---@param value any The value to check.
---@return boolean contains True if the table contains the value, false if otherwise.
function table.contains(t, value)
	for _, v in ipairs(t) do
		if v == value then
			return true
		end
	end
	return false
end

---Deserialize a string to a table.
---@param str string The string to be deserialized.
---@return table deserializedTable The deserialize table.
function table.deserialize(str)
	local func = load("return " .. str)
	assert(func, "Invalid string.")
	return func()
end

---Return the first index with the given value (or nil if not found).
---@param t table The table to search.
---@param value any The value to be searched.
---@return number | nil indexOf The index of the value.
function table.indexOf(t, value)
	for i, v in ipairs(t) do
		if v == value then
			return i
		end
	end
	return nil
end

---Prints a Table content.
---@param t table The table to be printed.
---@param indent? number The indentation value.
function table.print(t, indent)
	indent = indent or 0
	local indentStr = string.rep("  ", indent)
	for k, v in pairs(t) do
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

---Serialize a table to a string.
---@param t table The table to be serialized.
---@param indent? number The indentation value.
---@return string serializedString The serialized string.
function table.serialize(t, indent)
	indent = indent or 0
	local result = "{\n"
	for k, v in pairs(t) do
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

---Creates a sliced table.
---@param t table The table to be sliced.
---@param first? number The first index of the sliced table. Default is 1.
---@param last? number The last index of the sliced table. Default is the last key.
---@return table slicedTable The sliced table.
function table.slice(t, first, last)
	local sliced = {}
	for i = first or 1, last or #t do
		sliced[#sliced + 1] = t[i]
	end
	return sliced
end
