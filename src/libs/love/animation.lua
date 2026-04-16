--[[
	Author: Marcus Ferreira
	Description: A animation library for LOVE.
]]


--- Library
---@class animation
local animation = {}


--- Enums
---@enum animationState
local animationState = {
	PLAYING = 1,
	STOPPED = 2
}


--- Classes
---@class Grid
---@field private tileWidth number The width of each tile.
---@field private tileHeight number The height of each tile.
---@field private __index? table The index of the grid (for iterating).
local Grid = {}
Grid.__index = Grid

---@class Animation
---@field private image love.Image The image to be used.
---@field private grid Grid The grid of quads created by newGrid.
---@field private frames number[] A table of the numbers of the quads in order.
---@field private currentFrameIndex number The index of the current frame in the frames table.
---@field private originX? number The X origin for drawing.
---@field private originY? number The Y origin for drawing.
---@field private interval? number The interval between frame quads, in seconds.
---@field private loop? boolean True if the animation should be looped or false if contrary.
---@field private timer number The timer used to track the time between frame changes.
---@field private currentState animationState The current state of the animation (PLAYING or STOPPED).
---@field private __index? table The index of the animation (for iterating).
local Animation = {}
Animation.__index = Animation


--- Methods
---Creates a grid of quads based on the given parameters.
---@param tileWidth number # The width of each tile.
---@param tileHeight number # The height of each tile.
---@param columns number # The number of the tiles in a row.
---@param rows number # The number of the tiles in a column.
---@param left? number # Where to start to draw from left. Default = 0.
---@param top? number # Where to start to draw from top. Default = 0.
---@param offsetX? number # The margin in between tiles columns. Default = 0.
---@param offsetY? number # The margin in between tiles rows. Default = 0.
---@return Grid grid # The Grid object.
function animation.newGrid(tileWidth, tileHeight, columns, rows, left, top, offsetX, offsetY)
	local _left = left or 0
	local _top = top or 0
	local _offsetX = offsetX or 0
	local _offsetY = offsetY or 0

	---@type Grid
	local self = {
		tileWidth = tileWidth,
		tileHeight = tileHeight,
		columns = columns,
		rows = rows,
		left = _left,
		top = _top,
		offsetX = _offsetX,
		offsetY = _offsetY
	}
	setmetatable(self, Grid)
	for row = 0, rows - 1 do
		for col = 0, columns - 1 do
			local x = _left + col * (tileWidth + _offsetX)
			local y = _top + row * (tileHeight + _offsetY)
			local quad = love.graphics.newQuad(
				x, y, tileWidth, tileHeight, tileWidth * columns, tileHeight * rows
			)
			table.insert(self, quad)
		end
	end
	return self
end

---Gets the quad at the specified index in the grid.
---@return love.Quad # The quad at the specified index.
function Grid:getQuad(index)
	return self[index]
end


---Creates a new Animation object.
---@param image love.Image # The image to be used.
---@param grid Grid # The grid of quads created by newGrid.
---@param frames number[] # A table of the numbers of the quads in order.
---@param originX? number # The X origin for drawing. Default = 0.
---@param originY? number # The Y origin for drawing. Default = 0.
---@param interval? number # The interval between frame quads, in seconds. Default = 1.
---@param loop? boolean # True if the animation should be looped or false if contrary. Default = true.
---@return Animation animation # The new Animation object.
function animation.newAnimation(image, grid, frames, originX, originY, interval, loop)
	---@type Animation
	local self = {
		image = image,
		grid = grid,
		frames = frames,
		currentFrameIndex = 1,
		originX = originX or 0,
		originY = originY or 0,
		interval = interval or 1,
		loop = loop == nil and true or loop,
		timer = 0,
		currentState = animationState.PLAYING
	}
	setmetatable(self, Animation)
	return self
end

---Updates the animation. Should be called in love.update.
---@param dt number
function Animation:update(dt)
	-- Don't update if there's only 1 frame
	if #self.frames == 1 then return end

	if self:isPlaying() then
		self.timer = self.timer + dt

		-- Changes to next frame and reset timer
		if self.timer > self.interval then
			self.currentFrameIndex = self.currentFrameIndex + 1
			self.timer = self.timer - self.interval
		end

		-- Goes back to first frame if is looping or stop
		if self.currentFrameIndex > #self.frames then
			if self.loop then
				self.currentFrameIndex = 1
			else
				self.currentFrameIndex = #self.frames
				self:stop()
			end
		end
	end
end

---Draws the current frame of the animation. Should be called in love.draw.
---@param x number # The X position of the animation.
---@param y number # The Y position of the animation.
---@param rotation? number # The rotation value of the animation.
---@param sx? number # The scaleX of the animation.
---@param sy? number # The scaleY of the animation.
function Animation:draw(x, y, rotation, sx, sy)
	love.graphics.draw(
		self.image,                          -- image
		self.grid:getQuad(self:getCurrentFrame()), -- quad
		x,                                   -- x
		y,                                   -- y
		rotation or 0,                       -- rotation
		sx or 1,                             -- scaleX
		sy or 1,                             -- scaleY
		self.originX,                        -- originX
		self.originY                         -- originY
	)
end

---Gets the current frame (quad) of the animation (not the index).
---@return number # The frame of the animation.
function Animation:getCurrentFrame()
	return self.frames[self.currentFrameIndex]
end

---Goes to the specified frame index of the animation.
---@param frameIndex number # The index of the frame to go.
function Animation:goToFrame(frameIndex)
	self.currentFrameIndex = frameIndex
	self.timer = 0
end

---Checks if the animation has ended.
---@return boolean # True if the last frame of the animation is playing.
function Animation:isEnded()
	return self.currentFrameIndex == #self.frames
end

---Checks if the animation is currently playing.
---@return boolean # True if the animation is playing.
function Animation:isPlaying()
	return self.currentState == animationState.PLAYING
end

---Starts playing the animation.
function Animation:play()
	self.currentFrameIndex = 1
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
---@param loop boolean # True if the animation should loop or false if contrary.
function Animation:setLoop(loop)
	self.loop = loop
end

---Stops the animation.
function Animation:stop()
	self.currentState = animationState.STOPPED
end

return animation
