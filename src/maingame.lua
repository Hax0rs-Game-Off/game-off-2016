require("util/gamestate")

require("person")

local sti = require("util/Simple-Tiled-Implementation/sti")

MainGame = class("mainGame", GameState)

function MainGame:start()
    person = Person(images.people.manblue, "stand")
    person:set_pos(50, 50)

    -- Grab window size
    windowWidth  = love.graphics.getWidth()
    windowHeight = love.graphics.getHeight()
    tx = 0
    ty = 0
    sf = 0.5
    map = sti("assets/maps/1.lua", { "box2d" })
end

function MainGame:update(dt)
    person:update(dt)
    map:update(dt)
end

function MainGame:draw()
    love.graphics.setBackgroundColor(17, 17, 17)
    love.graphics.setColor(255, 255, 255)

    love.graphics.scale(sf)

    love.graphics.translate(-tx, -ty)
    map:setDrawRange(tx, ty, windowWidth/sf, windowHeight/sf)

    -- Draw the map and all objects within
    map:draw()

    love.graphics.scale(1)
    person:draw()

    --love.graphics.print("FPS: " .. love.timer.getFPS(), 5, 5)
end

function MainGame:keypressed(k, u)
    --stack:pop()
    local kd = love.keyboard.isDown
    local l  = kd("left")  or kd("a")
    local r  = kd("right") or kd("d")
    local u  = kd("up")    or kd("w")
    local d  = kd("down")  or kd("s")

    tx = l and tx - 128 or tx
    tx = r and tx + 128 or tx
    ty = u and ty - 128 or ty
    ty = d and ty + 128 or ty
end

function MainGame:mousepressed(x, y, button, istouch)
    person:set_pos(x/sf + tx, y/sf + ty)
    --stack:pop()
end

function MainGame:resize(w, h)
    windowWidth  = w
    windowHeight = h
    map:resize(w, h)
end
