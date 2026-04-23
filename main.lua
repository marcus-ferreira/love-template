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
    ResizeWindow(2)

    playerSpritesheet = love.graphics.newImage("assets/images/ivysaur.png")
    playerGrids = {
        animationManager.newGrid(playerSpritesheet, 32, 32, 10, 2),
        animationManager.newGrid(playerSpritesheet, 74, 40, 5, 1, 0, 64)
    }

    world = physics.newWorld()

    player = entity.newEntity(world, 50, 50, 32, 32)

    player:getAnimationManager():addAnimations(
        {
            { "idle",   playerSpritesheet, playerGrids[1], { 1 } },
            { "attack", playerSpritesheet, playerGrids[2], { 1, 2, 3, 4, 5 }, 0, 0, 0.07 }
        }
    )
    -- player:getAnimationManager():getAnimation("idle"):setOriginPoint(16, 32)
    -- player:getAnimationManager():getAnimation("attack"):setOriginPoint(16, 40)
    player:getAnimationManager():getAnimation("attack"):setOriginPoint(16, 24)

    player:getStateManager():addStates(
        {
            {
                "idle",
                function()
                    player:getAnimationManager():changeAnimation("idle")
                end,
                function()
                    if love.keyboard.isDown("space") then
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

    block = entity.newEntity(world, 200, 50, 32, 60)
end

function love.update(dt)
    world:update(dt)
    player:update(dt)

    local vx, vy = 0, 0
    local playerSpeed = 100
    if love.keyboard.isDown("left") then
        vx = -playerSpeed
        player:getAnimationManager():flipAnimationsHorizontally(true)
    elseif love.keyboard.isDown("right") then
        vx = playerSpeed
        player:getAnimationManager():flipAnimationsHorizontally(false)
    end
    if love.keyboard.isDown("up") then
        vy = -playerSpeed
    elseif love.keyboard.isDown("down") then
        vy = playerSpeed
    end
    player:move(vx, vy, playerSpeed, dt)
end

function love.draw()
    love.graphics.scale(WindowScale, WindowScale)
    player:draw()
    player:getCollider():draw()

    local x, y = player:getCollider():getBody():getPosition()
    player:getAnimationManager():getCurrentAnimation():drawOriginPoint(x, y)



    -- block:getCollider():draw()

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

    if key == "space" then player:getStateManager():changeState("attack") end
end
