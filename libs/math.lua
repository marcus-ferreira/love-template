--[[
	Author: Marcus Ferreira
	08/06/2025 - 0.2.1v - Initial
]]

---Returns the angle between two vectors assuming the same origin.
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function math.angle(x1, y1, x2, y2)
	return math.atan2(y2 - y1, x2 - x1)
end

---Averages an arbitrary number of angles (in radians).
---@param ... unknown
---@return number
function math.averageAngles(...)
	local x, y = 0, 0
	for i = 1, select('#', ...) do
		local a = select(i, ...)
		x, y = x + math.cos(a), y + math.sin(a)
	end
	return math.atan2(y, x)
end

---Cosine interpolation between two numbers.
---@param a number
---@param b number
---@param t number
---@return number
function math.cerp(a, b, t)
	local f = (1 - math.cos(t * math.pi)) * 0.5
	return a * (1 - f) + b * f
end

---Checks if two line segments intersect. Line segments are given in form of ({x,y},{x,y}, {x,y},{x,y}).
---@param l1p1 table
---@param l1p2 table
---@param l2p1 table
---@param l2p2 table
---@return boolean
function math.checkIntersect(l1p1, l1p2, l2p1, l2p2)
	local function checkDir(pt1, pt2, pt3)
		return math.sign(((pt2.x - pt1.x) * (pt3.y - pt1.y)) -
			((pt3.x - pt1.x) * (pt2.y - pt1.y)))
	end
	return (checkDir(l1p1, l1p2, l2p1) ~= checkDir(l1p1, l1p2, l2p2)) and
		(checkDir(l2p1, l2p2, l1p1) ~= checkDir(l2p1, l2p2, l1p2))
end

---Clamps a number to within a certain range.
---@param low number
---@param n number
---@param high number
---@return number
function math.clamp(low, n, high)
	return math.min(math.max(low, n), high)
end

---Returns the distance between two points.
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function math.dist2(x1, y1, x2, y2)
	return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end

---Distance between two 3D points.
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@return number
function math.dist3(x1, y1, z1, x2, y2, z2)
	return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2) ^ 0.5
end

---Checks if two lines intersect (or line segments if seg is true). Lines are given as four numbers (two coordinates).
---@param l1p1x number
---@param l1p1y number
---@param l1p2x number
---@param l1p2y number
---@param l2p1x number
---@param l2p1y number
---@param l2p2x number
---@param l2p2y number
---@param seg1? table
---@param seg2? table
---@return boolean | number
---@return string | number
function math.findIntersect(l1p1x, l1p1y, l1p2x, l1p2y, l2p1x, l2p1y, l2p2x, l2p2y, seg1, seg2)
	local a1, b1, a2, b2 = l1p2y - l1p1y, l1p1x - l1p2x, l2p2y - l2p1y, l2p1x - l2p2x
	local c1, c2 = a1 * l1p1x + b1 * l1p1y, a2 * l2p1x + b2 * l2p1y
	local det = a1 * b2 - a2 * b1
	if det == 0 then return false, "The lines are parallel." end
	local x, y = (b2 * c1 - b1 * c2) / det, (a1 * c2 - a2 * c1) / det
	if seg1 or seg2 then
		local min, max = math.min, math.max
		if seg1 and not (min(l1p1x, l1p2x) <= x and x <= max(l1p1x, l1p2x) and min(l1p1y, l1p2y) <= y and y <= max(l1p1y, l1p2y)) or
			seg2 and not (min(l2p1x, l2p2x) <= x and x <= max(l2p1x, l2p2x) and min(l2p1y, l2p2y) <= y and y <= max(l2p1y, l2p2y)) then
			return false, "The lines don't intersect."
		end
	end
	return x, y
end

---Linear interpolation between two numbers.
---@param a number
---@param b number
---@param t number
---@return number
function math.lerp(a, b, t)
	return (1 - t) * a + t * b
end

---@param a number
---@param b number
---@param t number
---@return number
function math.lerp2(a, b, t)
	return a + (b - a) * t
end

---Returns the closest multiple of 'size' (defaulting to 10).
---@param n number
---@param size? number
---@return number
function math.multiple(n, size)
	size = size or 10
	return math.round(n / size) * size
end

---Normalize two numbers.
---@param x number
---@param y number
---@return integer
---@return integer
---@return integer
function math.normalize(x, y)
	local l = (x * x + y * y) ^ 0.5
	if l == 0 then
		return 0, 0, 0
	else
		return x / l, y / l, l
	end
end

---Gives a precise random decimal number given a minimum and maximum
---@param min number
---@param max number
---@return number
function math.prandom(min, max)
	return love.math.random() * (max - min) + min
end

---Returns 'n' rounded to the nearest 'deci'th (defaulting whole numbers).
---@param n number
---@param deci? number
---@return number
function math.round(n, deci)
	deci = 10 ^ (deci or 0)
	return math.floor(n * deci + 0.5) / deci
end

---Randomly returns either -1 or 1.
---@return integer
function math.rsign()
	return love.math.random(2) == 2 and 1 or -1
end

---Returns 1 if number is positive, -1 if it's negative, or 0 if it's 0.
---@param n number
---@return integer
function math.sign(n)
	return n > 0 and 1 or n < 0 and -1 or 0
end
