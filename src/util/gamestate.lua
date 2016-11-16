-- game state

require("util/helper")

GameState = class("GameState")

function GameState:__init()end

function GameState:update(dt)end
function GameState:draw()end
function GameState:start()end
function GameState:stop()end
function GameState:keypressed(k, u)end
function GameState:mousepressed(x, y, button, istouch)end
function GameState:mousereleased(x, y, button, istouch)end
function GameState:mousemoved(x, y, dx, dy, istouch)end
function GameState:wheelmoved(x, y)end
function GameState:resize(w, h)end
