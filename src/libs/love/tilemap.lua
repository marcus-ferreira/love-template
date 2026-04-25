--[[
	Author: Marcus Ferreira
	Description: A tilemap library for LOVE using Tiled exported .lua maps.
]]


--- Imports
local animationManager = require("src.libs.love.animationManager")
local vector = require("src.libs.love.vector")


--- Library
---@class tilemap
local tilemap = {}


--- Classes
---@class Tilemap
---@field private scene table The scene created by Tiled.
---@field private mapSize Vector2 The size vector of the map.
---@field private image love.Image The image of the map.
---@field private grid Grid The grid of the map.
---@field private __index? table The index of the map (for iterating).
---@field private __class? string The class of the map.
local Tilemap = {}
Tilemap.__index = Tilemap
Tilemap.__class = "Tilemap"


--- Methods
---Creates a new Tilemap object.
---@param scenePath string The path of the scene.
---@param image love.Image The image of the scene.
---@param grid Grid The grid of the scene.
---@return Tilemap tilemap The Tilemap object.
function tilemap.newTilemap(scenePath, image, grid)
    ---@type Tilemap
    local self = {
        scene = require(scenePath),
        mapSize = vector.newVector2(),
        image = image,
        grid = grid
    }
    setmetatable(self, Tilemap)
    self:setMapSize(self:getScene().width, self:getScene().height)
    return self
end

---Draws the map.
function Tilemap:draw()
    for _, layer in ipairs(self.scene.layers) do
        local mapData = layer.data
        local width, height = self.mapSize:getCoordinates()
        local tileSize = self.grid:getTileSize()
        for y = 1, height do
            for x = 1, width do
                local tileIndex = x + ((y - 1) * width)
                local quadIndex = mapData[tileIndex]
                if quadIndex ~= 0 then
                    love.graphics.draw(self.image, self.grid:getQuad(quadIndex),
                        (x - 1) * tileSize:getX(), (y - 1) * tileSize:getY())
                end
            end
        end
    end
end

---Gets the grid of the tilemap.
---@return Grid grid The grid of the map.
function Tilemap:getGrid()
    return self.grid
end

---Gets the image of the tilemap.
---@return love.Image image The image of the map.
function Tilemap:getImage()
    return self.image
end

---Gets the size of the map (in tiles).
---@return Vector2 mapSize The size of the map.
function Tilemap:getMapSize()
    return self.mapSize
end

---Gets the scene of the Map.
---@return table scene The scene of the Map.
function Tilemap:getScene()
    return self.scene
end

---Sets the new map size.
---@param x number The new width of the map.
---@param y number The new height of the map.
function Tilemap:setMapSize(x, y)
    self.mapSize:setCoordinates(x, y)
end

return tilemap
