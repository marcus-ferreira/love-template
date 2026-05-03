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

    world = physics.newWorld(0, 900, true, {
        ---@param a love.Fixture
        ---@param b love.Fixture
        ---@param coll love.Contact
        beginContact = function(a, b, coll)
            local userDatas = { a:getUserData(), b:getUserData() }
            if table.contains(userDatas, "footSensor") then
                player:getCollider():addContact("ground")
            elseif table.contains(userDatas, "leftSensor") or table.contains(userDatas, "rightSensor") then
                player:getCollider():addContact("wall")
            end
        end,
        ---@param a love.Fixture
        ---@param b love.Fixture
        ---@param coll love.Contact
        endContact = function(a, b, coll)
            local userDatas = { a:getUserData(), b:getUserData() }
            if table.contains(userDatas, "footSensor") then
                player:getCollider():removeContact("ground")
            elseif table.contains(userDatas, "leftSensor") or table.contains(userDatas, "rightSensor") then
                player:getCollider():removeContact("wall")
            end
        end
    })

    player = entity.newPlatformerEntity(world, 100, 100, 100, 300)
    player:getCollider():addFixtures({
        ["main"] = { "polygon", false, 0, 0, 24, 16 },
        ["footSensor"] = { "polygon", true, 0, 8, 18, 4 },
        ["leftSensor"] = { "polygon", true, -12, 0, 4, 10 },
        ["rightSensor"] = { "polygon", true, 12, 0, 4, 10 }
    })
    player:getAnimationManager():addAnimations({
        ["idle"] = { assets.images.player:getImage(), assets.images.player:getGrid(1), { 1 }, 16, 24 },
        ["attack"] = { assets.images.player:getImage(), assets.images.player:getGrid(2), { 1, 2, 3, 4, 5 }, 16, 32, 0.07 }
    })
    player:getStateManager():addStates({
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
    })

    player:getStateManager():changeState("idle")

    block = entity.newStaticEntity(world, 200, 300, "block", 400, 100)
    block2 = entity.newStaticEntity(world, 16, VIRTUAL_HEIGHT / 2, "block", 32, VIRTUAL_HEIGHT)




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

    player:move(input.getAxis("left", "right", "leftx"), 0)
    if input.isActionPressed("jump") and (player:isOnFloor() or player:isByWall()) then
        player:jump()
    end


    -- cam:moveTo(playerx - (VIRTUAL_WIDTH / 2), playery - (VIRTUAL_HEIGHT / 2), dt)

    input.resetPressedKeys()
end

function love.draw()
    love.graphics.scale(Scale, Scale)

    player:draw()
    world:drawColliders()

    -- cam:setCamera()

    -- map:draw()
    -- block:drawAll()

    -- cam:unsetCamera()
end
