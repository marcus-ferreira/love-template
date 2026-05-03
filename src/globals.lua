--- Constants
VIRTUAL_WIDTH  = 400 -- Internal game width size
VIRTUAL_HEIGHT = 300 -- Internal game height size
Scale          = 1   -- Scale of the window dimension


---@enum Colors
colors = {
    _DEFAULT  = { 1, 1, 1 },
    _BLACK    = { 0, 0, 0 },
    sweetie16 = {
        BLACK       = { 0.10, 0.11, 0.17 }, -- #1a1c2c
        PURPLE_DARK = { 0.36, 0.15, 0.36 }, -- #5d275d
        RED         = { 0.69, 0.24, 0.33 }, -- #b13e53
        ORANGE      = { 0.94, 0.49, 0.34 }, -- #ef7d57
        YELLOW      = { 1.00, 0.80, 0.46 }, -- #ffcd75
        LIME        = { 0.65, 0.94, 0.44 }, -- #a7f070
        GREEN       = { 0.22, 0.72, 0.39 }, -- #38b764
        TEAL_DARK   = { 0.15, 0.44, 0.47 }, -- #257179
        BLUE_DARK   = { 0.16, 0.21, 0.44 }, -- #29366f
        BLUE        = { 0.23, 0.36, 0.79 }, -- #3b5dc9
        BLUE_LIGHT  = { 0.25, 0.65, 0.96 }, -- #41a6f6
        CYAN        = { 0.45, 0.94, 0.97 }, -- #73eff7
        WHITE       = { 0.96, 0.96, 0.96 }, -- #f4f4f4
        GREY_BLUE   = { 0.58, 0.69, 0.76 }, -- #94b0c2
        GREY        = { 0.34, 0.42, 0.53 }, -- #566c86
        GREY_DARK   = { 0.20, 0.24, 0.34 }, -- #333c57
    }
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
    Scale = scale
    love.window.setMode(VIRTUAL_WIDTH * Scale, VIRTUAL_HEIGHT * Scale, {})
end

---Setups the inputs.
function SetupInputs()
    input.setActionsKeys({
        ["up"]     = {
            keys    = { "up", "w" },
            buttons = { "dpup" },
            axes    = { "lefty-" }
        },
        ["down"]   = {
            keys    = { "down", "s" },
            buttons = { "dpdown" },
            axes    = { "lefty+" }
        },
        ["left"]   = {
            keys    = { "left", "a" },
            buttons = { "dpleft" },
            axes    = { "leftx-" }
        },
        ["right"]  = {
            keys    = { "right", "d" },
            buttons = { "dpright" },
            axes    = { "leftx+" }
        },
        ["attack"] = {
            keys    = { "space" },
            buttons = { "x" }
        },
        ["jump"]   = {
            keys    = { "up", "w" },
            buttons = { "a" }
        },
        ["quit"]   = {
            keys    = { "escape" },
            buttons = { "back" }
        }
    })
end
