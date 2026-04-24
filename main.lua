-- Imports all dependencies
require("dependencies")

---Resizes the window given a scale factor.
---@param scale number The scale factor.
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
    player = entity.newEntity(world, 50, 50, 32, 32, "dynamic")
    block = entity.newEntity(world, 200, 50, 32, 60, "static")

    player:getAnimationManager():addAnimations({
        ["idle"] = { playerSpritesheet, playerGrids[1], { 1 } },
        ["attack"] = { playerSpritesheet, playerGrids[2], { 1, 2, 3, 4, 5 }, 16, 24, 0.07 }
    })

    player:getStateManager():addStates({
        ["idle"] = {
            ["enter"] = function()
                player:getAnimationManager():changeAnimation("idle")
            end,
            ["update"] = function()
                if input.isActionPressed("attack") then
                    player:getStateManager():changeState("attack")
                end
            end
        },
        ["attack"] = {
            ["enter"] = function()
                player:getAnimationManager():changeAnimation("attack")
            end,
            ["update"] = function()
                if player:getAnimationManager():getCurrentAnimation():isEnded() then
                    player:getStateManager():changeState("idle")
                end
            end
        }
    })

    player:getStateManager():changeState("idle")

    input.setActionsKeys({
        ["up"] = { "up", "w" },
        ["down"] = { "down", "s" },
        ["left"] = { "left", "a" },
        ["right"] = { "right", "d" },
        ["attack"] = { "space" }
    })
end

---@param dt number
function love.update(dt)
    world:update(dt)
    player:update(dt)

    local vx, vy = 0, 0
    local playerForce = 2000
    if input.isActionDown("left") then
        vx = -playerForce
        player:getAnimationManager():flipAnimationsHorizontally(true)
    elseif input.isActionDown("right") then
        vx = playerForce
        player:getAnimationManager():flipAnimationsHorizontally(false)
    end
    if input.isActionDown("up") then
        vy = -playerForce
    elseif input.isActionDown("down") then
        vy = playerForce
    end
    player:move(vx, vy, playerForce)

    input.resetPressedKeys()
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

    input.keypressed(key)
end

---@param key love.KeyConstant
function love.keyreleased(key)
    input.keyreleased(key)
end
