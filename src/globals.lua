--- Constants
VIRTUAL_WIDTH = 400  -- Internal game width size
VIRTUAL_HEIGHT = 300 -- Internal game height size


---@enum Colors
colors = {
    DEFAULT = { 1, 1, 1 },
    RED     = { 1, 0, 0 },
    GREEN   = { 0, 1, 0 },
    BLUE    = { 0, 0, 1 },
}


--- Functions
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

---Setups the inputs.
function SetupInputs()
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
end
