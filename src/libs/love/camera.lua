--[[
	Author: Marcus Ferreira
	Description: A camera library for LOVE.
]]


--- Imports
local vector = require("src.libs.love.vector")


--- Library
---@class camera
local camera = {
	position    = vector.newVector2(),
	scale       = 1,
	rotation    = 0,
	followSpeed = 5
}


--- Methods
---Moves a camera to a targe position given a x and y values.
---@param x number The X position target.
---@param y number The Y position target.
---@param dt number The delta time.
function camera.moveTo(x, y, dt)
	local target = vector.newVector2(x, y)
	local direction = target - camera.position
	local distance = direction:magnitude()
	if distance < 0.1 then
		camera.position = target
	else
		camera.position = camera.position + direction * (camera.followSpeed * dt)
	end
end

---Rotates the camera.
---@param dr number The amount to rotate the camera by.
function camera.rotate(dr)
	camera.rotation = camera.rotation + dr
end

---Setups the camera transformations.
function camera.set()
	love.graphics.push()
	love.graphics.scale(camera.scale, camera.scale)
	love.graphics.translate(-camera.position:getX(), -camera.position:getY())
	love.graphics.rotate(-camera.rotation)
end

---Sets the follow speed of the camera.
---@param speed number The follow speed of the camera.
function camera.setFollowSpeed(speed)
	camera.followSpeed = speed
end

---Sets the position of the camera.
---@param x number The X position of the camera.
---@param y number The Y position of the camera.
function camera.setPosition(x, y)
	camera.position:setCoordinates(x, y)
end

---Sets the scale of the camera.
---@param scale number The scale of the camera.
function camera.setScale(scale)
	camera.scale = scale
end

---Finishes the camera transformations.
function camera.unset()
	love.graphics.pop()
end

return camera
