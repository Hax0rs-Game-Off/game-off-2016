-- intro

require("util/gamestate")

require("maingame")

Intro = class("Intro", GameState)

function Intro:draw()
    love.graphics.setBackgroundColor(17, 17, 17)
    love.graphics.setColor(255, 255, 255)

    love.graphics.clear()
    --love.graphics.setFont(resources.fonts.normal)
    love.graphics.print("Press mouse to proceed\nArrows keys to scroll, or grab scroll\nScroll wheel to zoom\n`,1,2,..,9 to change speed\nF2 for debug info", 10, 10)
end

local function startgame()
    mainGame = MainGame()
    stack:push(mainGame)
    --stack:pop()
end

function Intro:keypressed(key, scancode, isrepeat)
    --startgame()
end

function Intro:mousepressed(x, y, button, istouch)
    startgame()
end
