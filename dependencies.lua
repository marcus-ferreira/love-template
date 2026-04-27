require("src.globals")

-- Lua
require("src.libs.lua.math")
require("src.libs.lua.string")
require("src.libs.lua.table")
require("src.libs.lua.utils")

-- Love
animationManager = require("src.libs.love.animationManager")
camera           = require("src.libs.love.camera")
color            = require("src.libs.love.color")
data             = require("src.libs.love.data")
-- debugLove = require("src.libs.love.debug")
entity           = require("src.libs.love.entity")
imageManager     = require("src.libs.love.imageManager")
input            = require("src.libs.love.input")
physics          = require("src.libs.love.physics")
stateManager     = require("src.libs.love.stateManager")
tilemap          = require("src.libs.love.tilemap")
timer            = require("src.libs.love.timer")
vector           = require("src.libs.love.vector")
