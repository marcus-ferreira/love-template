--[[
    Author: Marcus Ferreira
    Description: A image manager library for LOVE.
]]


--- Library
---@class imageManager
local imageManager = {}


--- Classes
---@class ImageManager
---@field private image love.Image The image.
---@field private grids Grid[] The table of grids.
---@field private __index? table The index of the image (for iterating).
---@field private __class? string The class of the image.
local ImageManager = {}
ImageManager.__index = ImageManager
ImageManager.__class = "ImageManager"

---@class Grid
---@field private tileSize Vector2 The size vector of each tile.
---@field private quads love.Quad[] A table of the quads created by newGrid.
---@field private __index? table The index of the grid (for iterating).
---@field private __class? string The class of the grid.
local Grid = {}
Grid.__index = Grid
Grid.__class = "Grid"


--- Methods
---Adds a new grid of quads based on the given parameters to the Image.
---@param tileWidth number The width of each tile.
---@param tileHeight number The height of each tile.
---@param columns number The number of the tiles in a row.
---@param rows number The number of the tiles in a column.
---@param width number The width of the image.
---@param height number The height of the image.
---@param left? number Where to start to draw from left. Default = 0.
---@param top? number Where to start to draw from top. Default = 0.
---@param offsetX? number The margin in between tiles columns. Default = 0.
---@param offsetY? number The margin in between tiles rows. Default = 0.
---@return Grid grid The Grid object.
function imageManager.newGrid(tileWidth, tileHeight, columns, rows, width, height, left, top, offsetX, offsetY)
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
                tileWidth,                          -- width
                tileHeight,                         -- height
                width,                              -- sw
                height                              -- sh
            )
            self:addQuad(quad)
        end
    end
    return self
end

---Creates a new Image object.
---@param imagePath string The path of the image.
---@param gridParms table<number[]> The table of parms of the grids (tileWidth, tileHeight, columns, rows, left, top, offsetX, offsetY).
---@return ImageManager image The new Image object.
function imageManager.newImageManager(imagePath, gridParms)
    ---@type ImageManager
    local self = {
        image = love.graphics.newImage(imagePath),
        grids = {}
    }
    setmetatable(self, ImageManager)
    for _, grid in ipairs(gridParms) do
        local tileWidth  = grid[1]
        local tileHeight = grid[2]
        local columns    = grid[3]
        local rows       = grid[4]
        local left       = grid[5]
        local top        = grid[6]
        local offsetX    = grid[7]
        local offsetY    = grid[8]
        self:addNewGrid(tileWidth, tileHeight, columns, rows, left, top, offsetX, offsetY)
    end
    return self
end

---Adds a new grid in the Image.
---@param tileWidth number The width of each tile.
---@param tileHeight number The height of each tile.
---@param columns number The number of the tiles in a row.
---@param rows number The number of the tiles in a column.
---@param left? number Where to start to draw from left. Default = 0.
---@param top? number Where to start to draw from top. Default = 0.
---@param offsetX? number The margin in between tiles columns. Default = 0.
---@param offsetY? number The margin in between tiles rows. Default = 0.
function ImageManager:addNewGrid(tileWidth, tileHeight, columns, rows, left, top, offsetX, offsetY)
    local grid = imageManager.newGrid(
        tileWidth, tileHeight, columns, rows, self.image:getWidth(), self.image:getHeight(), left, top, offsetX, offsetY
    )
    table.insert(self.grids, grid)
end

---Gets the image of the ImageManager.
---@return love.Image image The image of the ImageManager.
function ImageManager:getImage()
    return self.image
end

---Gets the grid of the ImageManager.
---@param index number The index of the grid of the ImageManager.
---@return Grid grid The Grid object.
function ImageManager:getGrid(index)
    return self.grids[index]
end

---Gets the table of grids of the ImageManager.
---@return Grid[]
function ImageManager:getGrids()
    return self.grids
end

---Adds a quad to the grid.
---@param quad love.Quad The quad to be added to the grid.
function Grid:addQuad(quad)
    table.insert(self.quads, quad)
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

---Gets the tile size of the grid.
---@return Vector2 tileSize The size vector of a tile of the grid.
function Grid:getTileSize()
    return self.tileSize
end

return imageManager
