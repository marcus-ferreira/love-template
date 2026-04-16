require("dependencies")

function love.load()
    -- Setups the game
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setNewFont("assets/fonts/love.ttf", 8)
end

function love.update(dt)
end

function love.draw()
end

---@param key love.KeyConstant
function love.keypressed(key)
    -- Closes the game
    if key == "escape" then
        love.event.quit()
    end
end
