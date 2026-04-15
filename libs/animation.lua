--[[
	Author: Marcus Ferreira
	Description: A animation library for LOVE.
	15/04/2026 - 0.4v
]]


---@class Animation
Animation = {}
Animation.__index = Animation


---@param image love.Image # The image to be used.
---@param tileColumns number # The number of the tiles in a row.
---@param tileRows number # The number of the tiles in a column.
---@param left? number # Where to start to draw from left. Default = 0.
---@param top? number # Where to start to draw from top. Default = 0.
---@param offsetX? number # The margin in between tiles columns. Default = 0.
---@param offsetY? number # The margin in between tiles rows. Default = 0.
---@return table grid # The Grid object.
function love.graphics.newGrid(image, tileColumns, tileRows, left, top, offsetX, offsetY)
	local tileWidth = image:getWidth() / tileColumns
	local tileHeight = image:getHeight() / tileRows
	left = left or 0
	top = top or 0
	offsetX = offsetX or 0
	offsetY = offsetY or 0

	local grid = {}
	for row = 0, tileRows - 1 do
		for col = 0, tileColumns - 1 do
			local x = left + col * (tileWidth + offsetX)
			local y = top + row * (tileHeight + offsetY)
			local quad = love.graphics.newQuad(x, y, tileWidth, tileHeight, image:getWidth(), image:getHeight())
			table.insert(grid, quad)
		end
	end
	return grid
end

---@param image love.Image # The image to be used.
---@param grid table # The grid of quads created by newGrid.
---@param frames table # A table of the numbers of the quads in order.
---@param originX? number # The X origin for drawing. Default = 0.
---@param originY? number # The Y origin for drawing. Default = 0.
---@param interval? number # The interval between frame quads, in seconds. Default = 1.
---@param loop? boolean # True if the animation should be looped or false if contrary. Default = true.
---@return Animation animation # The new Animation object.
function love.graphics.newAnimation(image, grid, frames, originX, originY, interval, loop)
	originX = originX or 0
	originY = originY or 0
	interval = interval or 1
	loop = loop == nil and true or loop


	---@class Animation
	local self = setmetatable({}, Animation)
	self.image = image
	self.grid = grid
	self.frames = frames
	self.currentFrameIndex = 1
	self.originX = originX
	self.originY = originY
	self.interval = interval
	self.loop = loop
	self.timer = 0
	self.states = {
		PLAYING = 1,
		STOPPED = 2
	}
	self.currentState = self.states.PLAYING
	return self
end

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

---@param x number # The X position of the animation.
---@param y number # The Y position of the animation.
---@param rotation? number # The rotation value of the animation.
---@param sx? number # The scaleX of the animation.
---@param sy? number # The scaleY of the animation.
function Animation:draw(x, y, rotation, sx, sy)
	rotation = rotation or 0
	sx = sx or 1
	sy = sy or 1

	love.graphics.draw(
		self.image,                  -- image
		self.grid[self:getCurrentFrame()], -- quad
		x,                           -- x
		y,                           -- y
		rotation,                    -- rotation
		sx,                          -- scaleX
		sy,                          -- scaleY
		self.originX,                -- originX
		self.originY                 -- originY
	)
end

---Gets the current frame (quad) of the animation (not the index)
---@return love.Quad # The frame of the animation
function Animation:getCurrentFrame()
	return self.frames[self.currentFrameIndex]
end

---@param frameIndex number # The index of the frame to go.
function Animation:goToFrame(frameIndex)
	self.currentFrameIndex = frameIndex
end

---@return boolean # True if the last frame of the animation is playing
function Animation:isEnded()
	return self.currentFrameIndex == #self.frames
end

function Animation:isPlaying()
	return self.currentState == self.states.PLAYING
end

function Animation:play()
	self.currentFrameIndex = 1
	self.currentState = self.states.PLAYING
end

function Animation:resume()
	self.currentState = self.states.PLAYING
end

---@param boolean boolean # True to turn loop on, false to turn off
function Animation:setLoop(boolean)
	self.loop = boolean
end

function Animation:stop()
	self.currentState = self.states.STOPPED
end
