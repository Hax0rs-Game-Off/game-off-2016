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
end

function love.keypressed(key, scancode, isrepeat)
    stack:keypressed(key, scancode, isrepeat)
end

function love.mousepressed(x, y, button, istouch)
    stack:mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
    stack:mousereleased(x, y, button, istouch)
end

function love.mousemoved(x, y, dx, dy, istouch)
    stack:mousemoved(x, y, dx, dy, istouch)
end

function love.wheelmoved(x, y)
    stack:wheelmoved(x, y)
end

function love.resize(w, h)
    stack:resize(w, h)
end

function love.quit()
end
