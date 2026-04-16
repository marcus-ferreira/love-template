--[[
	Author: Marcus Ferreira
	Description: A math library for LOVE.
]]


---Returns the angle between two vectors assuming the same origin.
---@param x1 number # The X coordinate of the first vector.
---@param y1 number # The Y coordinate of the first vector.
---@param x2 number # The X coordinate of the second vector.
---@param y2 number # The Y coordinate of the second vector.
---@return number # The angle between the two vectors, in radians.
function love.math.angle(x1, y1, x2, y2)
	return math.atan2(y2 - y1, x2 - x1)
end

---Averages an arbitrary number of angles (in radians).
---@param ... unknown # The angles to average.
---@return number # The average angle, in radians.
function love.math.averageAngles(...)
	local x, y = 0, 0
	for i = 1, select('#', ...) do
		local a = select(i, ...)
		x, y = x + math.cos(a), y + math.sin(a)
	end
	return math.atan2(y, x)
end

---Cosine interpolation between two numbers.
---@param a number # The first number.
---@param b number # The second number.
---@param t number # The interpolation parameter.
---@return number # The interpolated number.
function love.math.cerp(a, b, t)
	local f = (1 - math.cos(t * math.pi)) * 0.5
	return a * (1 - f) + b * f
end

---Checks if two line segments intersect. Line segments are given in form of ({x,y},{x,y}, {x,y},{x,y}).
---@param l1p1 table # The first point of the first line segment.
---@param l1p2 table # The second point of the first line segment.
---@param l2p1 table # The first point of the second line segment.
---@param l2p2 table # The second point of the second line segment.
---@return boolean # Whether the line segments intersect.
function love.math.checkIntersect(l1p1, l1p2, l2p1, l2p2)
	local function checkDir(pt1, pt2, pt3)
		return love.math.sign(((pt2.x - pt1.x) * (pt3.y - pt1.y)) -
			((pt3.x - pt1.x) * (pt2.y - pt1.y)))
	end
	return (checkDir(l1p1, l1p2, l2p1) ~= checkDir(l1p1, l1p2, l2p2)) and
		(checkDir(l2p1, l2p2, l1p1) ~= checkDir(l2p1, l2p2, l1p2))
end

---Clamps a number to within a certain range.
---@param low number # The lower bound.
---@param n number # The number to clamp.
---@param high number # The upper bound.
---@return number # The clamped number.
function love.math.clamp(low, n, high)
	return math.min(math.max(low, n), high)
end

---Returns the distance between two points.
---@param x1 number # The X coordinate of the first point.
---@param y1 number # The Y coordinate of the first point.
---@param x2 number # The X coordinate of the second point.
---@param y2 number # The Y coordinate of the second point.
---@return number # The distance between the two points.
function love.math.dist2(x1, y1, x2, y2)
	return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end

---Distance between two 3D points.
---@param x1 number # The X coordinate of the first point.
---@param y1 number # The Y coordinate of the first point.
---@param z1 number # The Z coordinate of the first point.
---@param x2 number # The X coordinate of the second point.
---@param y2 number # The Y coordinate of the second point.
---@param z2 number # The Z coordinate of the second point.
---@return number # The distance between the two points.
function love.math.dist3(x1, y1, z1, x2, y2, z2)
	return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2) ^ 0.5
end

---Checks if two lines intersect (or line segments if seg is true). Lines are given as four numbers (two coordinates).
---@param l1p1x number # The X coordinate of the first point of the first line.
---@param l1p1y number # The Y coordinate of the first point of the first line.
---@param l1p2x number # The X coordinate of the second point of the first line.
---@param l1p2y number # The Y coordinate of the second point of the first line.
---@param l2p1x number # The X coordinate of the first point of the second line.
---@param l2p1y number # The Y coordinate of the first point of the second line.
---@param l2p2x number # The X coordinate of the second point of the second line.
---@param l2p2y number # The Y coordinate of the second point of the second line.
---@param seg1? table # Whether the first line is a segment.
---@param seg2? table # Whether the second line is a segment.
---@return boolean | number # Whether the lines intersect, or the X coordinate of the intersection point.
---@return string | number # An error message or the Y coordinate of the intersection point.
function love.math.findIntersect(l1p1x, l1p1y, l1p2x, l1p2y, l2p1x, l2p1y, l2p2x, l2p2y, seg1, seg2)
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
---@param a number # The first number.
---@param b number # The second number.
---@param t number # The interpolation parameter.
---@return number # The interpolated number.
function love.math.lerp(a, b, t)
	return (1 - t) * a + t * b
end

---Linear interpolation between two numbers without clamping 't' between 0 and 1.
---@param a number # The first number.
---@param b number # The second number.
---@param t number # The interpolation parameter.
---@return number # The interpolated number.
function love.math.lerp2(a, b, t)
	return a + (b - a) * t
end

---Returns the closest multiple of 'size' (defaulting to 10).
---@param n number # The number to round.
---@param size? number # The size of the multiples.
---@return number # The closest multiple.
function love.math.multiple(n, size)
	size = size or 10
	return math.floor(n / size + 0.5) * size
end

---Normalize two numbers.
---@param x number # The X coordinate.
---@param y number # The Y coordinate.
---@return integer # The normalized X coordinate.
---@return integer # The normalized Y coordinate.
---@return integer # The length of the vector.
function love.math.normalize(x, y)
	local l = (x * x + y * y) ^ 0.5
	if l == 0 then
		return 0, 0, 0
	else
		return x / l, y / l, l
	end
end

---Gives a precise random decimal number given a minimum and maximum.
---@param min number # The minimum value.
---@param max number # The maximum value.
---@return number # The random number.
function love.math.prandom(min, max)
	return love.math.random() * (max - min) + min
end

---Returns 'n' rounded to the nearest 'deci'th (defaulting whole numbers).
---@param n number # The number to round.
---@param deci? number # The number of decimal places to round to.
---@return number # The rounded number.
function love.math.round(n, deci)
	deci = 10 ^ (deci or 0)
	return math.floor(n * deci + 0.5) / deci
end

---Randomly returns either -1 or 1.
---@return integer # Either -1 or 1.
function love.math.rsign()
	return love.math.random(2) == 2 and 1 or -1
end

---Returns 1 if number is positive, -1 if it's negative, or 0 if it's 0.
---@param n number # The number to evaluate.
---@return integer # The sign of the number.
function love.math.sign(n)
	return n > 0 and 1 or n < 0 and -1 or 0
end
