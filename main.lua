-- Imports all dependencies
require("dependencies")

function love.load()
    -- Initializes the game settings
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setNewFont("assets/fonts/love.ttf", 8)
    love.graphics.setBackgroundColor(colors.sweetie16.BLACK)
    ResizeWindow(2)
    LoadAssets()
    SetupInputs()

    world = physics.newWorld({
        callbacks = {
            beginContact = function(fixtureA, fixtureB, contact)
                local blockFixture = nil
                if fixtureA:getUserData() == "block" then
                    blockFixture = fixtureA
                elseif fixtureB:getUserData() == "block" then
                    blockFixture = fixtureB
                end
                if blockFixture then
                    physics.addQueuedFunction(function()
                        blockFixture:getBody():setPosition(
                            love.math.random(love.graphics.getWidth()),
                            love.math.random(love.graphics.getHeight())
                        )
                    end)
                end
            end
        }
    })

    player = {
        animationManager = animationManager.newAnimationManager(),
        collider = physics.newCollider(world, 100, 100, "dynamic", {
            { "playerMain",   "circle", false, 0, 0, 10 },
            { "playerSensor", "circle", true,  0, 0, 30 },
        })
    }
    player.collider:getBody():setLinearDamping(0.5)

    block = physics.newCollider(world, 200, 200, "static", {
        { "block", "polygon", false, 0, 0, 60, 200 }
    })






    -- local blockWidth, blockheight = 800, 96
    -- block = entity.newEntity(world, blockWidth / 2, 209 + (blockheight / 2), blockWidth, blockheight, "static")

    -- player:getAnimationManager():addAnimations({
    --     idle = { assets.images.player:getImage(), assets.images.player:getGrid(1), { 1 }, 16, 24 },
    --     attack = { assets.images.player:getImage(), assets.images.player:getGrid(2), { 1, 2, 3, 4, 5 }, 16, 32, 0.07 }
    -- })
    -- player:getStateManager():addStates({
    --     idle = {
    --         enter = function()
    --             player:getAnimationManager():changeAnimation("idle")
    --         end,
    --         update = function()
    --             if input.isActionPressed("attack") then
    --                 player:getStateManager():changeState("attack")
    --             end
    --         end
    --     },
    --     attack = {
    --         enter = function()
    --             player:getAnimationManager():changeAnimation("attack")
    --         end,
    --         update = function()
    --             if player:getAnimationManager():getCurrentAnimation():isEnded() then
    --                 player:getStateManager():changeState("idle")
    --             end
    --         end
    --     }
    -- })
    -- player:getStateManager():changeState("idle")

    -- map = tilemap.newTilemap("src.scenes.map", assets.images.tileset)
    -- cam = camera.newCamera(0, 0, 2)
end

---@param dt number
function love.update(dt)
    -- Closes the game
    if input.isActionPressed("quit") then
        love.event.quit()
    end

    world:update(dt)

    local speed = 100
    local vx = input.getAxis("left", "right", "leftx")
    local vy = input.getAxis("up", "down", "lefty")
    player.collider:getBody():applyForce(vx * speed, vy * speed)

    local offset = 20
    local x, y = player.collider:getBody():getPosition()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    if x < -offset then
        player.collider:getBody():setPosition(windowWidth + offset, y)
    elseif x > windowWidth + offset then
        player.collider:getBody():setPosition(-offset, y)
    end
    if y < -offset then
        player.collider:getBody():setPosition(x, windowHeight + offset)
    elseif y > windowHeight + offset then
        player.collider:getBody():setPosition(x, -offset)
    end

    -- cam:moveTo(playerx - (VIRTUAL_WIDTH / 2), playery - (VIRTUAL_HEIGHT / 2), dt)

    input.resetPressedKeys()
end

function love.draw()
    world:drawColliders()

    -- cam:setCamera()

    -- map:draw()
    -- player:drawAll()
    -- block:drawAll()

    -- cam:unsetCamera()
end
