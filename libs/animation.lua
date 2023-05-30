--[[
	Version: 0.1.2
]]

---@class Grid
Grid = {}
Grid.__index = Grid

---@class Animation
Animation = {}
Animation.__index = Animation

---Creates a new Grid, a list of Quads.
---@param tileWidth number
---@param tileHeight number
---@param left? number # Default = 0.
---@param top? number # Default = 0.
---@param offsetX? number # Default = 0.
---@param offsetY? number # Default = 0.
---@return Grid
function Grid.new(tileWidth, tileHeight, imageWidth, imageHeight, left, top, offsetX, offsetY)
	---@class Grid
	local grid = {}
	grid.tileWidth = tileWidth
	grid.tileHeight = tileHeight

	left = left or 0
	top = top or 0
	offsetX = offsetX or 0
	offsetY = offsetY or 0

	for y = top, imageHeight - 1, grid.tileHeight + offsetY do
		for x = left, imageWidth - 1, grid.tileWidth + offsetX do
			local tile = love.graphics.newQuad(x, y, grid.tileWidth, grid.tileHeight, imageWidth, imageHeight)
			table.insert(grid, tile)
		end
	end

	setmetatable(grid, Grid)
	return grid
end

---Creates a new Animation.
---@param image love.Image # The image to be used.
---@param grid Grid # The grid table to be used.
---@param frames table # A table of the numbers of the frames in a quad list.
---@param interval? number # The interval between frame quads, in seconds. Default = 1.
---@param loop? boolean # True if the animation should be looped or false if contrary. Default = true.
---@return Animation animation # The new Animation object
function Animation.new(image, grid, frames, interval, loop)
	---@class Animation
	local animation = {}
	animation.image = image
	animation.grid = grid
	animation.frames = frames
	animation.indexCurrentFrame = 1
	animation.interval = interval or 1
	animation.loop = loop or true
	animation.timer = 0
	animation.isPlaying = true
	animation.isFlipped = false

	setmetatable(animation, Animation)
	return animation
end

---Updates the Animation
---@param dt number
function Animation:update(dt)
	-- don't update if there's only 1 frame
	if #self.frames == 1 then return end

	if self.isPlaying then
		-- increases timer over time
		self.timer = self.timer + dt

		-- change to next frame and reset timer
		if self.timer > self.interval then
			self.indexCurrentFrame = self.indexCurrentFrame + 1
			self.timer = self.timer - self.interval
		end

		-- go back to first frame if is looping or stop
		if self.indexCurrentFrame > #self.frames then
			if self.loop then
				self.indexCurrentFrame = 1
			else
				self.indexCurrentFrame = #self.frames
			end
		end
	end
end

---Draws the animation
---@param x number # The X position of the animation.
---@param y number # The Y position of the animation.
function Animation:draw(x, y)
	love.graphics.draw(
		self.image,                  -- image
		self.grid[self:getCurrentFrame()], -- quad
		x,                           -- x
		y,                           -- y
		0,                           -- rotation
		self.isFlipped and -1 or 1,  -- scaleX
		1,                           -- scaleY
		self.grid.tileWidth / 2,     -- originX
		self.grid.tileHeight / 2     -- originY
	)
end

---Gets the current frame of the animation (not the index)
---@return love.Quad # The frame of the animation
function Animation:getCurrentFrame() return self.frames[self.indexCurrentFrame] end

---Set the animation to a specific frame.
---@param frameNumber number # The index of the frame to go.
function Animation:goToFrame(frameNumber) self.indexCurrentFrame = frameNumber end

---Checks if the animation has ended
---@return boolean # True if the last frame of the animation is playing
function Animation:isEnded() return self.indexCurrentFrame == #self.frames end

---Plays current animation
function Animation:play() self.isPlaying = true end

---Sets the animation flipped status
---@param boolean boolean
function Animation:setFlipped(boolean) self.isFlipped = boolean end

---Sets the animation to loop or not
---@param boolean boolean # True to turn loop on, false to turn off
function Animation:setLoop(boolean) self.loop = boolean end

---Stops current animation
function Animation:stop() self.isPlaying = false end
