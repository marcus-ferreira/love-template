function love.load()
    -- Initializes the game settings
    love.graphics.setDefaultFilter("nearest", "nearest")
    require("dependencies")
    ResizeWindow(2)
    LoadAssets()
    SetupInputs()
    love.graphics.setBackgroundColor(colors.sweetie16.BLACK)
    love.graphics.setFont(assets.fonts["main"])
    input.setDeadzone(0)
    camera.setScale(2)
    camera.setFollowSpeed(10)

    world = physics.newWorld(0, 900, true, {
        ---@param a love.Fixture
        ---@param b love.Fixture
        ---@param coll love.Contact
        beginContact = function(a, b, coll)
            local userDatas = { a:getUserData(), b:getUserData() }
            if table.containsAll(userDatas, { "footSensor", "ground" }) then
                player:getCollider():addContact("ground")
            elseif table.containsAny(userDatas, { "leftSensor", "rightSensor" }) and table.contains(userDatas, "wall") then
                player:getCollider():addContact("wall")
            end
        end,
        ---@param a love.Fixture
        ---@param b love.Fixture
        ---@param coll love.Contact
        endContact = function(a, b, coll)
            local userDatas = { a:getUserData(), b:getUserData() }
            if table.containsAll(userDatas, { "footSensor", "ground" }) then
                player:getCollider():removeContact("ground")
            elseif table.containsAny(userDatas, { "leftSensor", "rightSensor" }) and table.contains(userDatas, "wall") then
                player:getCollider():removeContact("wall")
            end
        end
    })

    player = entity.newPlatformerEntity(world, 100, 100, 100, 300, {
        fixtures = {
            ["main"] = { "polygon", false, 0, 0, 24, 16 },
            ["footSensor"] = { "polygon", true, 0, 8, 18, 4 },
            ["leftSensor"] = { "polygon", true, -12, 0, 4, 10 },
            ["rightSensor"] = { "polygon", true, 12, 0, 4, 10 }
        },
        animations = {
            ["idle"] = { assets.images.player:getImage(), assets.images.player:getGrid(1), { 1 }, 16, 24 },
            ["attack"] = { assets.images.player:getImage(), assets.images.player:getGrid(2), { 1, 2, 3, 4, 5 }, 16, 32, 0.07 },
        },
        states = {
            ["idle"] = {
                enter = function()
                    player:getAnimationManager():changeAnimation("idle")
                end,
                update = function()
                    if input.isActionPressed("attack") then
                        player:getStateManager():changeState("attack")
                    end
                end
            },
            ["attack"] = {
                enter = function()
                    player:getAnimationManager():changeAnimation("attack")
                end,
                update = function()
                    if player:getAnimationManager():getCurrentAnimation():isEnded() then
                        player:getStateManager():changeState("idle")
                    end
                end
            }
        }
    })

    player:getStateManager():changeState("idle")

    map = tilemap.newTilemap("src.scenes.map", assets.images.tileset)

    local mapWidth, mapHeight = map:getMapSizeInPixels():getCoordinates()
    blocks = {
        entity.newStaticEntity(world, "wall", -7.5, VIRTUAL_HEIGHT / 2, 15, VIRTUAL_HEIGHT),
        entity.newStaticEntity(world, "ground", mapWidth / 2, mapHeight - 47.5, mapWidth, 95)
    }
end

---@param dt number
function love.update(dt)
    -- Closes the game
    if input.isActionPressed("quit") then
        love.event.quit()
    end

    world:update(dt)
    player:update(dt)

    player:move(input.getAxis("left", "right", "leftx"), 0)
    if input.isActionPressed("jump") then
        player:jump()
    end


    local playerX, playerY = player:getCollider():getBody():getPosition()
    local mapWidth, mapHeight = map:getMapSizeInPixels():getCoordinates()
    local playerDirection = player:getAnimationManager():getScaleX()
    local cameraX = math.clamp(0, playerX - (VIRTUAL_WIDTH / 2) + (playerDirection * 60), mapWidth - VIRTUAL_WIDTH)
    local cameraY = math.clamp(0, playerY - (VIRTUAL_HEIGHT / 2), mapHeight - VIRTUAL_HEIGHT - 4)
    camera.moveTo(cameraX, cameraY, dt)

    input.resetPressedKeys()
end

function love.draw()
    camera.set()
    map:draw()
    player:draw()
    world:drawColliders()
    camera.unset()
end
