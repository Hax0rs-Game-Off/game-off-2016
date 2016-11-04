require("util/gamestack")
cargo = require("util/cargo/cargo")

-- load our assets using cargo
assets = cargo.init({
  dir = 'assets',
  processors = {
    ['images/'] = function(image, filename)
      image:setFilter('nearest', 'nearest')
    end
  }
})

-- allow assets to be loaded from anywhere
setmetatable(_G, {
  __index = assets
})

function reset()
    -- start game
    -- stack = GameStack()
end

function love.load()
    math.randomseed(os.time())

    reset()
end

r = 0

function love.update(dt)
    -- stack:update(dt)
    r = r + 2 * dt
end

function love.draw()
    -- stack:draw()

    background = images.tiles.tile_120
    bwidth = background:getWidth()
    bheight = background:getHeight()

    for i = 0, math.floor(love.graphics.getWidth()/bwidth) do
        for j = 0, math.floor(love.graphics.getHeight()/bheight) do
            love.graphics.draw(background, i*bwidth, j*bwidth, 0, 1, 1)
        end
    end


    person = images.people.manblue.stand
    width = person:getWidth()
    height = person:getHeight()

    love.graphics.draw(person, 50, 50, r, 1, 1, width/2, height/2)

    love.graphics.print("FPS: " .. love.timer.getFPS(), 5, 5)
end

function love.keypressed(k, u)
    --stack:keypressed(k, u)
end

function love.mousepressed( x, y, button )
    --stack:mousepressed(x, y, button)
end

function love.quit()
end
