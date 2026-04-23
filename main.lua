-- Imports all dependencies
require("dependencies")

function ResizeWindow(scale)
    WindowScale = scale
    love.window.setMode(VIRTUAL_WIDTH * WindowScale, VIRTUAL_HEIGHT * WindowScale, {})
end

function love.load()
    -- Global constants
    VIRTUAL_WIDTH = 400
    VIRTUAL_HEIGHT = 300

    -- Initializes the game settings
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setNewFont("assets/fonts/love.ttf", 8)
    love.keyboard.keysPressed = {}
    ResizeWindow(2)


    playerSpritesheet = love.graphics.newImage("assets/images/ivysaur.png")
    playerGrids = {
        animationManager.newGrid(playerSpritesheet, 32, 32, 10, 2),
        animationManager.newGrid(playerSpritesheet, 74, 40, 5, 1, 0, 64)
    }

    world = physics.newWorld()
    player = entity.newEntity(world, 50, 50, 32, 32, "dynamic")
    block = entity.newEntity(world, 200, 50, 32, 60, "static")

    player:getAnimationManager():addAnimations(
        {
            { "idle",   playerSpritesheet, playerGrids[1], { 1 } },
            { "attack", playerSpritesheet, playerGrids[2], { 1, 2, 3, 4, 5 }, 16, 24, 0.07 }
        }
    )

    player:getStateManager():addStates(
        {
            {
                "idle",
                function()
                    player:getAnimationManager():changeAnimation("idle")
                end,
                function()
                    if love.keyboard.wasPressed("space") then
                        player:getStateManager():changeState("attack")
                    end
                end
            },
            {
                "attack",
                function()
                    player:getAnimationManager():changeAnimation("attack")
                end,
                function()
                    if player:getAnimationManager():getCurrentAnimation():isEnded() then
                        player:getStateManager():changeState("idle")
                    end
                end
            }
        }
    )
end

function love.update(dt)
    world:update(dt)
    player:update(dt)

    local vx, vy = 0, 0
    local playerForce = 2000
    if love.keyboard.isDown("left") then
        vx = -playerForce
        player:getAnimationManager():flipAnimationsHorizontally(true)
    elseif love.keyboard.isDown("right") then
        vx = playerForce
        player:getAnimationManager():flipAnimationsHorizontally(false)
    end
    if love.keyboard.isDown("up") then
        vy = -playerForce
    elseif love.keyboard.isDown("down") then
        vy = playerForce
    end
    player:move(vx, vy, playerForce)

    love.keyboard.keysPressed = {}
end

function love.draw()
    love.graphics.scale(WindowScale, WindowScale)
    player:drawAll()
    block:drawAll()

    -- Debug
    -- love.graphics.print("currentState: " .. player:getStateManager():getCurrentState():getName(), 0, 0)
    -- love.graphics.print("isEnded: " .. tostring(player:getAnimationManager():getCurrentAnimation():isEnded()), 0, 8)
end

---@param key love.KeyConstant
function love.keypressed(key)
    -- Closes the game
    if key == "escape" then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

---Checks is a given key was pressed in the last frame.
---@param key love.KeyConstant The key to be checked.
---@return boolean key The key.
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key] or false
end
