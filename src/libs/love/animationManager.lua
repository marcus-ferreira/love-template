--[[
	Author: Marcus Ferreira
	Description: A animation manager library for LOVE.
]]


--- Imports
local vector = require("src.libs.love.vector")


--- Library
---@class animationManager
local animationManager = {}


--- Enums
---@enum animationState
local animationState = {
	PLAYING = 1,
	STOPPED = 2
}


--- Classes
---@class AnimationManager
---@field private animations Animation[] The animations of the animation manager.
---@field private currentAnimation Animation|nil The current animation of the animation manager.
---@field private rotation number The angle of the animations (in radians).
---@field private scaleX number The scale x value of the animations. 1 = Normal, -1 = Flipped horizontally.
---@field private scaleY number The scale y value of the animations. 1 = Normal, -1 = Flipped vertically.
---@field private __index? table The index of the animation manager (for iterating).
---@field private __class? string The class of the animation manager.
local AnimationManager = {}
AnimationManager.__index = AnimationManager
AnimationManager.__class = "AnimationManager"

---@class Grid
---@field private tileSize Vector2 The size vector of each tile.
---@field private quads love.Quad[] A table of the quads created by newGrid.
---@field private __index? table The index of the grid (for iterating).
---@field private __class? string The class of the grid.
local Grid = {}
Grid.__index = Grid
Grid.__class = "Grid"

---@class Animation
---@field private name string The name of the animation.
---@field private image love.Image The image to be used.
---@field private grid Grid The grid of quads created by newGrid.
---@field private frames number[] A table of the numbers of the quads in order.
---@field private currentFrameIndex number The index of the current frame in the frames table.
---@field private originPoint Vector2 The origin point vector for drawing.
---@field private interval number The interval between frame quads, in seconds.
---@field private loop boolean True if the animation should be looped or false if contrary.
---@field private timer number The timer used to track the time between frame changes.
---@field private currentState animationState The current state of the animation (PLAYING or STOPPED).
---@field private __index? table The index of the animation (for iterating).
---@field private __class? string The class of the animation.
local Animation = {}
Animation.__index = Animation
Animation.__class = "Animation"


--- Methods
---Creates a new AnimationManager object.
---@return AnimationManager animationManager The new AnimationManager object.
function animationManager.newAnimationManager()
	---@type AnimationManager
	local self = {
		animations = {},
		currentAnimation = nil,
		rotation = 0,
		scaleX = 1,
		scaleY = 1
	}
	setmetatable(self, AnimationManager)
	return self
end

---Creates a new grid of quads based on the given parameters.
---@param image love.Image The image to be used.
---@param tileWidth number The width of each tile.
---@param tileHeight number The height of each tile.
---@param columns number The number of the tiles in a row.
---@param rows number The number of the tiles in a column.
---@param left? number Where to start to draw from left. Default = 0.
---@param top? number Where to start to draw from top. Default = 0.
---@param offsetX? number The margin in between tiles columns. Default = 0.
---@param offsetY? number The margin in between tiles rows. Default = 0.
---@return Grid grid The Grid object.
function animationManager.newGrid(image, tileWidth, tileHeight, columns, rows, left, top, offsetX, offsetY)
	local _left = left or 0
	local _top = top or 0
	local _offsetX = offsetX or 0
	local _offsetY = offsetY or 0

	---@type Grid
	local self = {
		tileSize = vector.newVector2(tileWidth, tileHeight),
		quads = {}
	}
	setmetatable(self, Grid)
	for y = 0, rows - 1 do
		for x = 0, columns - 1 do
			local quad = love.graphics.newQuad(
				_left + x * (tileWidth + _offsetX), -- x
				_top + y * (tileHeight + _offsetY), -- y
				tileWidth,              -- width
				tileHeight,             -- height
				image:getDimensions()   -- sw, sh
			)
			self:addQuad(quad)
		end
	end
	return self
end

---Creates a new Animation object.
---@param name string The name of the animation.
---@param image love.Image The image to be used.
---@param grid Grid The grid of quads created by newGrid.
---@param frames number[] A table of the numbers of the quads in order.
---@param originX? number The X origin for drawing. Default = 0.
---@param originY? number The Y origin for drawing. Default = 0.
---@param interval? number The interval between frame quads, in seconds. Default = 1.
---@param loop? boolean True if the animation should be looped or false if contrary. Default = false.
---@return Animation animation The new Animation object.
function animationManager.newAnimation(name, image, grid, frames, originX, originY, interval, loop)
	local tileSize = grid:getTileSize()
	local _originX = originX or tileSize:getX() / 2
	local _originY = originY or tileSize:getY() / 2
	local _interval = interval or 1
	local _loop = loop or false

	---@type Animation
	local self = {
		name = name,
		image = image,
		grid = grid,
		frames = frames,
		currentFrameIndex = 1,
		originPoint = vector.newVector2(_originX, _originY),
		interval = _interval,
		loop = _loop,
		timer = 0,
		currentState = animationState.PLAYING
	}
	setmetatable(self, Animation)
	return self
end

---Adds a new animation to the animation manager.
---@param name string The name of the animation.
---@param image love.Image The image to be used.
---@param grid Grid The grid of quads created by newGrid.
---@param frames number[] A table of the numbers of the quads in order.
---@param originX? number The X origin for drawing. Default = 0.
---@param originY? number The Y origin for drawing. Default = 0.
---@param interval? number The interval between frame quads, in seconds. Default = 1.
---@param loop? boolean True if the animation should be looped or false if contrary. Default = false.
function AnimationManager:addAnimation(name, image, grid, frames, originX, originY, interval, loop)
	assert(not self.animations[name], "Animation with name '" .. name .. "' already exists.")
	self.animations[name] = animationManager.newAnimation(name, image, grid, frames, originX, originY, interval, loop)
	if not self.currentAnimation then
		self.currentAnimation = self.animations[name]
	end
end

---Adds a batch of animations to the animation manager.
---@param animations table[] The table of animations parameters.
function AnimationManager:addAnimations(animations)
	for _, animation in ipairs(animations) do
		local name     = animation[1]
		local image    = animation[2]
		local grid     = animation[3]
		local frames   = animation[4]
		local originX  = animation[5]
		local originY  = animation[6]
		local interval = animation[7]
		local loop     = animation[8]
		self:addAnimation(name, image, grid, frames, originX, originY, interval, loop)
	end
end

---Changes the current animation of the animation manager.
---@param name string The name of the animation to change to.
function AnimationManager:changeAnimation(name)
	assert(self.animations[name], "Animation '" .. name .. "' does not exists.")
	self.currentAnimation = self.animations[name]
	self.currentAnimation:play()
end

---Draws the current animation of the animation manager.
---@param x number The X position of the animation.
---@param y number The Y position of the animation.
function AnimationManager:draw(x, y)
	if self.currentAnimation then
		self.currentAnimation:draw(x, y, self.rotation, self.scaleX, self.scaleY)
	end
end

---Shorthand for setting a scale x value -1 (flip horizontally) the animations.
---@param bool boolean The flip state.
function AnimationManager:flipAnimationsHorizontally(bool)
	assert(type(bool) == "boolean", "Value must be true or false")
	local flipValue = bool == true and -1 or 1
	self:setScaleX(flipValue)
end

---Shorthand for setting a scale y value -1 (flip vertically) the animations.
---@param bool boolean The flip state.
function AnimationManager:flipAnimationsVertically(bool)
	assert(type(bool) == "boolean", "Value must be true or false")
	local flipValue = bool == true and -1 or 1
	self:setScaleY(flipValue)
end

---Gets the animation given its name.
---@param name string The name of the animation.
---@return Animation animation The animation.
function AnimationManager:getAnimation(name)
	assert(self.animations[name], "Animation with name '" .. name .. "' does not exists.")
	return self.animations[name]
end

---Gets the animations of the AnimationManager.
---@return Animation[] animations The list of animations.
function AnimationManager:getAnimations()
	return self.animations
end

---Gets the current animation of the animation manager.
---@return Animation|nil animation The current animation of the animation manager.
function AnimationManager:getCurrentAnimation()
	return self.currentAnimation
end

---Gets the animation manager rotation.
---@return number rotation The rotation value of the animation manager.
function AnimationManager:getRotation()
	return self.rotation
end

---Gets the animation manager scale x.
---@return number rotation The scale x value of the animation manager.
function AnimationManager:getScaleX()
	return self.scaleX
end

---Gets the animation manager scale y.
---@return number rotation The scale y value of the animation manager.
function AnimationManager:getScaleY()
	return self.scaleY
end

---Sets the new rotation value of the animation manager.
---@param value number The new value of the rotation of the animation manager.
function AnimationManager:setRotation(value)
	self.rotation = value
end

---Sets the new scale x value of the animation manager.
---@param value number The new value of the scale x of the animation manager.
function AnimationManager:setScaleX(value)
	self.scaleX = value
end

---Sets the new scale y value of the animation manager.
---@param value number The new value of the scale y of the animation manager.
function AnimationManager:setScaleY(value)
	self.scaleY = value
end

---Updates the current animation of the animation manager.
---@param dt number The delta time.
function AnimationManager:update(dt)
	if self.currentAnimation then
		self.currentAnimation:update(dt)
	end
end

---Adds a quad to the grid.
---@param quad love.Quad The quad to be added to the grid.
function Grid:addQuad(quad)
	table.insert(self.quads, quad)
end

---Gets the tile size of the grid.
---@return Vector2 tileSize The size vector of a tile of the grid.
function Grid:getTileSize()
	return self.tileSize
end

---Gets the quad at the specified index in the grid.
---@return love.Quad quad The quad at the specified index.
function Grid:getQuad(index)
	return self.quads[index]
end

---Gets the quads of the Grid.
---@return love.Quad[] quads The list of quads.
function Grid:getQuads()
	return self.quads
end

---Draws the current frame of the animation. Should be called in love.draw.
---@param x number The X position of the animation.
---@param y number The Y position of the animation.
---@param rotation? number The rotation value of the animation.
---@param sx? number The scaleX of the animation.
---@param sy? number The scaleY of the animation.
function Animation:draw(x, y, rotation, sx, sy)
	local _rotation = rotation or 0
	local _sx = sx or 1
	local _sy = sy or 1
	love.graphics.draw(
		self.image,                          -- image
		self.grid:getQuad(self.currentFrameIndex), -- quad
		x,                                   -- x
		y,                                   -- y
		_rotation,                           -- rotation
		_sx,                                 -- scaleX
		_sy,                                 -- scaleY
		self.originPoint:getX(),             -- originX
		self.originPoint:getY()              -- originY
	)
end

---Draws the origin point of the animation.
---@param x number The X relative position of the origin point.
---@param y number The Y relative position of the origin point.
function Animation:drawOriginPoint(x, y)
	love.graphics.circle("fill", x, y, 2)
end

---Gets the current frame index of the Animation.
---@return number currentFrameIndex The current frame index of the Animation.
function Animation:getCurrentFrameIndex()
	return self.currentFrameIndex
end

---Gets the frames of the Animation.
---@return number[] frames The frames of the Animation.
function Animation:getFrames()
	return self.frames
end

---Gets the grid of the Animation.
---@return Grid grid The Grid of the Animation.
function Animation:getGrid()
	return self.grid
end

---Gets the image of the animation.
---@return love.Image image The image of the animation.
function Animation:getImage()
	return self.image
end

---Gets the interval of the Animation.
---@return number interval The interval of the Animation.
function Animation:getInterval()
	return self.interval
end

---Gets if the Animation loops or not.
---@return boolean loops If the Animation loops or not.
function Animation:loops()
	return self.loop
end

---Gets the name of the Animation.
---@return string name The name of the Animation.
function Animation:getName()
	return self.name
end

---Gets the origin point of the animation.
---@return Vector2 originPoint The position vector of the origin point of the animation.
function Animation:getOriginPoint()
	return self.originPoint
end

---Gets the timer of the Animation.
---@return number timer The timer of the Animation.
function Animation:getTimer()
	return self.timer
end

---Goes to the specified frame index of the animation.
---@param index number The index of the frame to go.
function Animation:goToFrame(index)
	assert(index > 0 and index <= #self.frames, "Frame does not exists in the animation.")
	self.currentFrameIndex = index
	self.timer = 0
end

---Goes to the next frame or goes back to the first frame of the animation.
function Animation:goToNextFrame()
	if self.currentFrameIndex == #self.frames then
		self.currentFrameIndex = 1
	else
		self.currentFrameIndex = self.currentFrameIndex + 1
	end
	self.timer = self.timer - self.interval
end

---Checks if the animation has ended.
---@return boolean isEnded True if the last frame of the animation is playing.
function Animation:isEnded()
	return self.currentFrameIndex == #self.frames
end

---Checks if the animation is currently playing.
---@return boolean isPlaying True if the animation is playing.
function Animation:isPlaying()
	return self.currentState == animationState.PLAYING
end

---Starts playing the animation.
function Animation:play()
	self:goToFrame(1)
	self.currentState = animationState.PLAYING
end

---Resumes the animation.
function Animation:resume()
	self.currentState = animationState.PLAYING
end

---Rewinds the animation to the first frame.
function Animation:rewind()
	self:goToFrame(1)
end

---Sets whether the animation should loop or not.
---@param loop boolean True if the animation should loop or false if contrary.
function Animation:setLoop(loop)
	assert(type(loop) == "boolean", "loop must be true or false")
	self.loop = loop
end

---Sets the origin point of the animation.
---@param x number The new X position of the origin point.
---@param y number The new Y position of the origin point.
function Animation:setOriginPoint(x, y)
	local tileSize = self.grid:getTileSize()
	assert((x >= 0 and x <= tileSize:getX()) and (y >= 0 and y <= tileSize:getY()),
		"Origin point outside animation bounds.")
	self.originPoint:setCoordinates(x, y)
end

---Sets the timer of the animation.
---@param value number The timer of the animation.
function Animation:setTimer(value)
	self.timer = value
end

---Stops the animation.
function Animation:stop()
	self.currentState = animationState.STOPPED
end

---Updates the animation. Should be called in love.update.
---@param dt number The delta time.
function Animation:update(dt)
	if self:isPlaying() and #self.frames ~= 1 then
		self.timer = self.timer + dt

		-- Changes to next frame
		if self.timer > self.interval then
			self:goToNextFrame()
		end

		-- Goes back to first frame if is looping or stop
		if self:isEnded() then
			if self.loop then
				self:goToNextFrame()
			else
				self:stop()
			end
		end
	end
end

return animationManager
