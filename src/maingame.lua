require("util/gamestate")

require("person")

MainGame = class("mainGame", GameState)

function MainGame:start()
    person = Person(images.people.manblue, "stand")
    person:set_pos(50, 50)
end

function MainGame:update(dt)
    person:update(dt)
end

function MainGame:draw()

    love.graphics.setBackgroundColor(17, 17, 17)
    love.graphics.setColor(255, 255, 255)

    love.graphics.clear()

    background = images.tiles.tile_120
    bwidth = background:getWidth()
    bheight = background:getHeight()

    for i = 0, math.floor(love.graphics.getWidth()/bwidth) do
        for j = 0, math.floor(love.graphics.getHeight()/bheight) do
            love.graphics.draw(background, i*bwidth, j*bwidth, 0, 1, 1)
        end
    end

    person:draw()
end

function MainGame:keypressed(k, u)
    --stack:pop()
end

function MainGame:mousepressed( x, y, button, istouch )
    person:set_pos(x, y)
    --stack:pop()
end
