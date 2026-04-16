-- Imports all dependencies
require("dependencies")

function ResizeWindow(scale)
    WindowScale = scale
    love.window.setMode(VIRTUAL_WIDTH * WindowScale, VIRTUAL_HEIGHT * WindowScale, {})
end

function love.load()
    -- Initializes the game settings
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setNewFont("assets/fonts/love.ttf", 8)
    VIRTUAL_WIDTH = 400
    VIRTUAL_HEIGHT = 300
    ResizeWindow(2)

    world = love.physics.newWorld(0, 980, true)
    a = physics.newRectangleCollider(world, 100, 100, 50, 50, "static")
end

function love.update(dt)
end

function love.draw()
    love.graphics.scale(WindowScale, WindowScale)
end

---@param key love.KeyConstant
function love.keypressed(key)
    -- Closes the game
    if key == "escape" then
        love.event.quit()
    end
end
