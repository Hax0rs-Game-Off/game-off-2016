require("util/gamestack")
cargo = require("util/cargo/cargo")

require("intro")

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
    intro = Intro()
    stack = GameStack()
    stack:push(intro)
end

function love.load()
    math.randomseed(os.time())

    reset()
end


function love.update(dt)
    stack:update(dt)
end

function love.draw()
    stack:draw()
    love.graphics.print("FPS: " .. love.timer.getFPS(), 5, 5)
end

function love.keypressed(k, u)
    stack:keypressed(k, u)
end

function love.mousepressed( x, y, button, istouch )
    stack:mousepressed(x, y, button, istouch)
end

function love.quit()
end
