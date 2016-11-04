require("util/gamestate")

require("person")
require("map")

MainGame = class("mainGame", GameState)

function MainGame:start()
    person = Person(images.people.manblue, "stand")
    map = Map(10, 4)
    person:set_pos(50, 50)
end

function MainGame:update(dt)
    person:update(dt)
end

function MainGame:draw()

    love.graphics.setBackgroundColor(17, 17, 17)
    love.graphics.setColor(255, 255, 255)

    love.graphics.clear()

    map:draw()
    person:draw()
end

function MainGame:keypressed(k, u)
    --stack:pop()
end

function MainGame:mousepressed( x, y, button, istouch )
    person:set_pos(x, y)
    --stack:pop()
end
