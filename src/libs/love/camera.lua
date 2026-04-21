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
---@class (exact) Camera
---@field private position Vector2 The position vector of the camera.
---@field private scale number The scale of the camera.
---@field private rotation number The rotation of the camera.
---@field private followSpeed number The speed at which the camera follows a target.
---@field private __index? table The index of the camera (for iterating).
local Camera = {}
Camera.__index = Camera


--- Methods
---Creates a new Camera object.
---@param x number X position of the camera.
---@param y number Y position of the camera.
---@param scale? number Scale of the camera.
---@param followSpeed? number The speed at which the camera follows a target.
---@return Camera camera A new Camera object.
function camera.newCamera(x, y, scale, followSpeed)
	local _scale = scale or 1
	local _followSpeed = followSpeed or 5

	---@type Camera
	local self = {
		position = vector.newVector2(x, y),
		scale = _scale,
		followSpeed = _followSpeed,
		rotation = 0
	}
	setmetatable(self, Camera)
	return self
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
