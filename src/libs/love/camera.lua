--[[
	Author: Marcus Ferreira
	Description: A camera library for LOVE.
]]


--- Imports
local vector = require("src.libs.love.vector")


--- Library
---@class camera
local camera = {}


--- Classes
---@class Camera
---@field private position Vector2 The position vector of the camera.
---@field private scale number The scale of the camera.
---@field private rotation number The rotation of the camera.
---@field private followSpeed number The speed at which the camera follows a target.
---@field private __index? table The index of the camera (for iterating).
---@field private __class? string The class of the camera.
local Camera = {}
Camera.__index = Camera
Camera.__class = "Camera"


--- Methods
---Creates a new Camera object.
---@param x number X position of the camera.
---@param y number Y position of the camera.
---@param scale? number Scale of the camera.
---@param followSpeed? number The speed at which the camera follows a target.
---@return Camera camera A new Camera object.
function camera.newCamera(x, y, scale, followSpeed)
	scale = scale or 1
	followSpeed = followSpeed or 5

	---@type Camera
	local self = {
		position = vector.newVector2(x, y),
		scale = scale,
		rotation = 0,
		followSpeed = followSpeed
	}
	setmetatable(self, Camera)
	return self
end

---Gets the position vector of the camera.
---@return Vector2 position The position vector of the camera.
function Camera:getPosition()
	return self.position
end

---Gets the scale of the camera.
---@return number scale The scale of the camera.
function Camera:getScale()
	return self.scale
end

---Gets the follow speed of the camera.
---@return number followSpeed The follow speed of the camera.
function Camera:getFollowSpeed()
	return self.followSpeed
end

---Moves a camera to a targe position given a x and y values.
---@param x number The X position target.
---@param y number The Y position target.
---@param dt number The delta time.
function Camera:moveTo(x, y, dt)
	local target = vector.newVector2(x, y)
	local direction = target - self.position
	local distance = direction:magnitude()
	if distance < 0.1 then
		self.position = target
	else
		self.position = self.position + direction * (self.followSpeed * dt)
	end
end

---Rotates the camera.
---@param dr number The amount to rotate the camera by.
function Camera:rotate(dr)
	self.rotation = self.rotation + dr
end

---Sets the camera transformations.
function Camera:setCamera()
	love.graphics.push()
	love.graphics.scale(self.scale, self.scale)
	love.graphics.translate(-self.position:getX(), -self.position:getY())
	love.graphics.rotate(-self.rotation)
end

---Sets the follow speed of the camera.
---@param speed number The follow speed of the camera.
function Camera:setFollowSpeed(speed)
	self.followSpeed = speed
end

---Sets the position of the camera.
---@param x number The X position of the camera.
---@param y number The Y position of the camera.
function Camera:setPosition(x, y)
	self.position:setCoordinates(x, y)
end

---Sets the scale of the camera.
---@param scale number The scale of the camera.
function Camera:setScale(scale)
	self.scale = scale
end

---Resets the camera transformations.
function Camera:unsetCamera()
	love.graphics.pop()
end

return camera
