--[[
	Version: 0.1.5
	19/11/2023
]]

---@class Rectangle
Rectangle = {}

---@class Circle
Circle = {}

---Creates a new Rectangle.
---@param x number
---@param y number
---@param width number
---@param height number
---@return Rectangle
function Rectangle.new(x, y, width, height)
	---@class Rectangle
	local rectangle = {}
	rectangle.x = x
	rectangle.y = y
	rectangle.width = width
	rectangle.height = height
	setmetatable(rectangle, Rectangle)
	Rectangle.__index = Rectangle
	return rectangle
end

---Creates a new Circle.
---@param x number
---@param y number
---@param radius number
---@return Circle
function Circle.new(x, y, radius)
	---@class Circle
	local circle = {}
	circle.x = x
	circle.y = y
	circle.radius = radius
	setmetatable(circle, Circle)
	Circle.__index = Circle
	return circle
end

---Checks if the Rectangle is colliding with other object.
---@param object Rectangle | Circle
---@param x? number
---@param y? number
---@return boolean
function Rectangle:isColliding(object, x, y)
	local class = getmetatable(object)
	assert(class == Rectangle or class == Circle, "Object must be a Rectangle or Circle.")
	x = x or 0
	y = y or 0

	if class == Rectangle then
		return self.x + x <= object.x + object.width and
			self.y + y <= object.y + object.height and
			self.x + self.width + x >= object.x and
			self.y + self.height + y >= object.y
	elseif class == Circle then
		local dx = object.x - math.max(self.x + x, math.min(object.x, self.x + self.width + x))
		local dy = object.y - math.max(self.y + y, math.min(object.y, self.y + self.height + y))
		return math.sqrt(dx ^ 2 + dy ^ 2) <= object.radius
	end
	return false
end

---Checks if the Circle is colliding with other object.
---@param object Rectangle | Circle
---@param x? number
---@param y? number
---@return boolean
function Circle:isColliding(object, x, y)
	local class = getmetatable(object)
	assert(class == Rectangle or class == Circle, "Param must be a Rectangle or Circle.")
	x = x or 0
	y = y or 0

	if class == Rectangle then
		local dx = self.x + x - math.max(object.x, math.min(self.x + x, object.x + object.width))
		local dy = self.y + y - math.max(object.y, math.min(self.y + y, object.y + object.height))
		return math.sqrt(dx ^ 2 + dy ^ 2) <= self.radius
	elseif class == Circle then
		return ((object.x - self.x - x) ^ 2 + (object.y - self.y - y) ^ 2) ^ 0.5 <= self.radius + object.radius
	end
	return false
end

---Draws the Rectangle.
function Rectangle:draw()
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

---Draws the Circle.
function Circle:draw()
	love.graphics.circle("line", self.x, self.y, self.radius)
end
