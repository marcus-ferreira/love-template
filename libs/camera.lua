--[[
	Author: Marcus Ferreira
	Description: A camera library for LOVE.
	15/04/2026 - 0.2v - Updates and optimizations.
]]

---@class Camera
Camera = {}
Camera.__index = Camera

---Creates a new Camera object
---@param x number # X position of the camera
---@param y number # Y position of the camera
---@param scale number # Scale of the camera
---@return Camera # A new Camera object
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

function Camera:set()
	love.graphics.push()
	love.graphics.scale(self.scale, self.scale)
	love.graphics.translate(-self.x, -self.y)
	love.graphics.rotate(-self.rotation)
end

function Camera:unset()
	love.graphics.pop()
end

---@param targetX number # The X position to move the camera to.
---@param targetY number # The Y position to move the camera to.
---@param dt number # The delta time.
function Camera:moveTo(targetX, targetY, dt)
	self.x = self.x + (targetX - self.x) * self.followSpeed * dt
	self.y = self.y + (targetY - self.y) * self.followSpeed * dt
end

---@param dr number # The amount to rotate the camera by.
function Camera:rotate(dr)
	self.rotation = self.rotation + dr
end

---@param x number # The X position of the camera.
---@param y number # The Y position of the camera.
function Camera:setPosition(x, y)
	self.x = x
	self.y = y
end

---@param scale number # The scale of the camera.
function Camera:setScale(scale)
	self.scale = scale
end

---@param speed number # The follow speed of the camera.
function Camera:setFollowSpeed(speed)
	self.followSpeed = speed
end
