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
            { "playerSensor", "circle", true,  0, 0, 20 }
        })
    }
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

    local vx, vy = 0, 0
    local speed = 100
    vx = input.isActionDown("left") and -1 or input.isActionDown("right") and 1 or 0
    vy = input.isActionDown("up") and -1 or input.isActionDown("down") and 1 or 0

    local joysticks = love.joystick.getJoysticks()
    ---@type love.Joystick
    local joystick = joysticks[1]
    if joystick then
        vx = joystick:getGamepadAxis("leftx")
        vy = joystick:getGamepadAxis("lefty")
    end
    player.collider:getBody():applyForce(vx * speed, vy * speed)

    local x, y = player.collider:getBody():getPosition()
    vx, vy = player.collider:getBody():getLinearVelocity()
    if (x < 0 and vx < 0) or (x > love.graphics.getWidth() and vx > 0) then
        player.collider:getBody():setLinearVelocity(-vx, vy)
    end
    if (y < 0 and vy < 0) or (y > love.graphics.getHeight() and vy > 0) then
        player.collider:getBody():setLinearVelocity(vx, -vy)
    end


    -- if input.isActionDown("left") then
    --     vx = -speed
    -- elseif input.isActionDown("right") then
    --     vx = speed
    -- end
    -- if input.isActionDown("up") then
    --     vy = -speed
    -- elseif input.isActionDown("down") then
    --     vy = speed
    -- end
    -- player.collider:getBody():setLinearVelocity(vx, vy)

    -- local playerx, playery = player:getCollider():getBody():getPosition()
    -- if playerx < VIRTUAL_WIDTH / 2 then
    --     playerx = VIRTUAL_WIDTH / 2
    -- elseif playerx > map:getMapSizeInPixels():getX() - (VIRTUAL_WIDTH / 2) then
    --     playerx = map:getMapSizeInPixels():getX() - (VIRTUAL_WIDTH / 2)
    -- end
    -- if playery < VIRTUAL_HEIGHT / 2 then
    --     playery = VIRTUAL_HEIGHT / 2
    -- elseif playery > map:getMapSizeInPixels():getY() - (VIRTUAL_HEIGHT / 2) then
    --     playery = map:getMapSizeInPixels():getY() - (VIRTUAL_HEIGHT / 2)
    -- end
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

---@param key love.KeyConstant
function love.keypressed(key)
    input.keypressed(key)
end

---@param key love.KeyConstant
function love.keyreleased(key)
    input.keyreleased(key)
end

---@param joystick love.Joystick
---@param button love.GamepadButton
function love.gamepadpressed(joystick, button)
    input.gamepadpressed(joystick, button)
end

---@param joystick love.Joystick
function love.joystickadded(joystick)
    input.addJoystick(joystick)
end

---@param joystick love.Joystick
function love.joystickremoved(joystick)
    input.removeJoystick(joystick)
end
