--[[
	Author: Marcus Ferreira
	Description: A camera library for LOVE.
]]


---@class Camera
Camera = {}
Camera.__index = Camera

---Creates a new Camera object.
---@param x number # X position of the camera.
---@param y number # Y position of the camera.
---@param scale number # Scale of the camera.
---@return Camera # A new Camera object.
function Camera.new(x, y, scale)
	---@type Camera
	local self = setmetatable({}, Camera)
	self.x = x or 0
	self.y = y or 0
	self.scale = scale or 1
	self.rotation = 0
	self.followSpeed = 5
	return self
end

---Sets the camera transformations.
function Camera:set()
	love.graphics.push()
	love.graphics.scale(self.scale, self.scale)
	love.graphics.translate(-self.x, -self.y)
	love.graphics.rotate(-self.rotation)
end

---Resets the camera transformations.
function Camera:unset()
	love.graphics.pop()
end

---Moves the camera to a specific position.
---@param targetX number # The X position to move the camera to.
---@param targetY number # The Y position to move the camera to.
---@param dt number # The delta time.
function Camera:moveTo(targetX, targetY, dt)
	self.x = self.x + (targetX - self.x) * self.followSpeed * dt
	self.y = self.y + (targetY - self.y) * self.followSpeed * dt
end

---Rotates the camera.
---@param dr number # The amount to rotate the camera by.
function Camera:rotate(dr)
	self.rotation = self.rotation + dr
end

---Sets the position of the camera.
---@param x number # The X position of the camera.
---@param y number # The Y position of the camera.
function Camera:setPosition(x, y)
	self.x = x
	self.y = y
end

---Sets the scale of the camera.
---@param scale number # The scale of the camera.
function Camera:setScale(scale)
	self.scale = scale
end

---Sets the follow speed of the camera.
---@param speed number # The follow speed of the camera.
function Camera:setFollowSpeed(speed)
	self.followSpeed = speed
end
