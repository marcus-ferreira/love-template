--[[
	Author: Marcus Ferreira
	Description: A camera library for LOVE.
]]


--- Library
---@class camera
local camera = {}


--- Classes
---@class Camera
---@field private x number The X position of the camera.
---@field private y number The Y position of the camera.
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
	---@type Camera
	local self = {
		x = x or 0,
		y = y or 0,
		scale = scale or 1,
		followSpeed = followSpeed or 5,
		rotation = 0
	}
	setmetatable(self, Camera)
	return self
end

---Moves the camera to a specific position.
---@param targetX number The X position to move the camera to.
---@param targetY number The Y position to move the camera to.
---@param dt number The delta time.
function Camera:moveTo(targetX, targetY, dt)
	self.x = self.x + (targetX - self.x) * self.followSpeed * dt
	self.y = self.y + (targetY - self.y) * self.followSpeed * dt
end

--- Pins the camera to an entity.
---@param entity table The entity to pin the camera to. Must have getPosition and getDimensions methods.
---@param align string The alignment of the camera to the entity. Can be "center" or "topleft".
---@param dt number The delta time.
function Camera:pinTo(entity, align, dt)
	if not entity.getPosition then
		error("Entity must have a getPosition method.")
	end
	if not entity.getDimensions then
		error("Entity must have a getDimensions method.")
	end

	local entityX, entityY = entity:getPosition()
	local entityWidth, entityHeight = entity:getDimensions()
	if align == "center" then
		entityX = entityX - love.graphics.getWidth() / 2 + entityWidth / 2
		entityY = entityY - love.graphics.getHeight() / 2 + entityHeight / 2
	elseif align == "topleft" then
		entityX = entityX - love.graphics.getWidth() / 2
		entityY = entityY - love.graphics.getHeight() / 2
	end
	self:moveTo(entityX, entityY, dt)
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
	love.graphics.translate(-self.x, -self.y)
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
	self.x = x
	self.y = y
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
