-- Imports all dependencies
require("dependencies")

---Loads the assets.
function LoadAssets()
    local manifest = require("src.assets")
    assets = { fonts = {}, images = {}, sounds = {} }

    for name, parms in pairs(manifest.fonts) do
        assets.fonts[name] = love.graphics.newFont(parms.path, parms.size)
    end

    for name, parms in pairs(manifest.images) do
        assets.images[name] = imageManager.newImageManager(parms.path, parms.grids)
    end

    for name, path in pairs(manifest.sounds) do
        -- "static" para sons curtos, "stream" para músicas longas
        local type = name:sub(1, 3) == "bgm" and "stream" or "static"
        assets.sounds[name] = love.audio.newSource(path, type)
    end
end

---Resizes the window given a scale factor.
---@param scale number The scale factor.
function ResizeWindow(scale)
    WindowScale = scale
    love.window.setMode(VIRTUAL_WIDTH * WindowScale, VIRTUAL_HEIGHT * WindowScale, {})
end

function love.load()
    -- Initializes the game settings
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setNewFont("assets/fonts/love.ttf", 8)
    ResizeWindow(2)
    LoadAssets()

    world = physics.newWorld()
    player = entity.newEntity(world, 50, 190, 20, 16, "dynamic")
    local blockWidth, blockheight = 800, 96
    block = entity.newEntity(world, blockWidth / 2, 209 + (blockheight / 2), blockWidth, blockheight, "static")

    player:getAnimationManager():addAnimations({
        idle = { assets.images.player:getImage(), assets.images.player:getGrid(1), { 1 }, 16, 24 },
        attack = { assets.images.player:getImage(), assets.images.player:getGrid(2), { 1, 2, 3, 4, 5 }, 16, 32, 0.07 }
    })
    player:getStateManager():addStates({
        idle = {
            enter = function()
                player:getAnimationManager():changeAnimation("idle")
            end,
            update = function()
                if input.isActionPressed("attack") then
                    player:getStateManager():changeState("attack")
                end
            end
        },
        attack = {
            enter = function()
                player:getAnimationManager():changeAnimation("attack")
            end,
            update = function()
                if player:getAnimationManager():getCurrentAnimation():isEnded() then
                    player:getStateManager():changeState("idle")
                end
            end
        }
    })
    player:getStateManager():changeState("idle")

    input.setActionsKeys({
        up = {
            keyboard = { "up", "w" },
            gamepad  = { "dpup" }
        },
        down = {
            keyboard = { "down", "s" },
            gamepad  = { "dpdown" }
        },
        left = {
            keyboard = { "left", "a" },
            gamepad  = { "dpleft" }
        },
        right = {
            keyboard = { "right", "d" },
            gamepad  = { "dpright" }
        },
        attack = {
            keyboard = { "space" },
            gamepad  = { "x" }
        },
        jump = {
            keyboard = { "up", "w" },
            gamepad  = { "a" }
        },
        quit = {
            keyboard = { "escape" },
            gamepad  = { "back" }
        }
    })

    map = tilemap.newTilemap("src.scenes.map", assets.images.tileset)
    cam = camera.newCamera(0, 0, 2)

    love.graphics.setBackgroundColor(color.hexToRGB("#a4d6fc"))
end

---@param dt number
function love.update(dt)
    world:update(dt)
    player:update(dt)

    local playerx, playery = player:getCollider():getBody():getPosition()
    if playerx < VIRTUAL_WIDTH / 2 then
        playerx = VIRTUAL_WIDTH / 2
    elseif playerx > map:getMapSizeInPixels():getX() - (VIRTUAL_WIDTH / 2) then
        playerx = map:getMapSizeInPixels():getX() - (VIRTUAL_WIDTH / 2)
    end
    if playery < VIRTUAL_HEIGHT / 2 then
        playery = VIRTUAL_HEIGHT / 2
    elseif playery > map:getMapSizeInPixels():getY() - (VIRTUAL_HEIGHT / 2) then
        playery = map:getMapSizeInPixels():getY() - (VIRTUAL_HEIGHT / 2)
    end
    cam:moveTo(playerx - (VIRTUAL_WIDTH / 2), playery - (VIRTUAL_HEIGHT / 2), dt)

    local vx, vy = 0, 0
    local speed = 100
    local jumpForce = 200
    if input.isActionDown("left") then
        vx = -1
        player:getAnimationManager():flipAnimationsHorizontally(true)
    elseif input.isActionDown("right") then
        vx = 1
        player:getAnimationManager():flipAnimationsHorizontally(false)
    else
        vx = 0
    end
    if input.isActionDown("up") then
        vy = -1
    elseif input.isActionDown("down") then
        vy = 1
    else
        vy = 0
    end
    player:move(vx, vy, speed)
    if input.isActionPressed("jump") and player:getCollider():getBody():isTouching(block:getCollider():getBody()) then
        player:getCollider():getBody():applyForce(0, -jumpForce)
    end

    -- Closes the game
    if input.isActionPressed("quit") then
        love.event.quit()
    end

    input.resetPressedKeys()
end

function love.draw()
    cam:setCamera()

    map:draw()
    player:draw()
    block:draw()

    world:drawColliders()

    cam:unsetCamera()
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
