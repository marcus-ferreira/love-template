require("dependencies")

function love.load()
    -- Setups the game
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setNewFont("assets/fonts/love.ttf", 8)

    a = {
        x = 100,
        y = 100,
        width = 32,
        height = 32,
        sprite = love.graphics.newImage("assets/images/example-player.png"),
        getPosition = function(self)
            return self.x, self.y
        end,
        getDimensions = function(self)
            return self.width, self.height
        end
    }
    b = love.graphics.newImage("assets/images/example-background.png")
    c = camera.newCamera(0, 0, 1)
    c:setFollowSpeed(60)
end

function love.update(dt)
    if love.keyboard.isDown("d") then
        a.x = a.x + 100 * dt
    end
    if love.keyboard.isDown("a") then
        a.x = a.x - 100 * dt
    end
    if love.keyboard.isDown("s") then
        a.y = a.y + 100 * dt
    end
    if love.keyboard.isDown("w") then
        a.y = a.y - 100 * dt
    end

    c:pinTo(a, "center", dt)
end

function love.draw()
    c:setCamera()
    love.graphics.draw(b, 0, 0)
    love.graphics.draw(a.sprite, a.x, a.y)
    c:unsetCamera()
end

---@param key love.KeyConstant
function love.keypressed(key)
    -- Closes the game
    if key == "escape" then
        love.event.quit()
    end
end
