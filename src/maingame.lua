require("util/gamestate")

require("person")
require("time")

local sti = require("util/Simple-Tiled-Implementation/sti")

MainGame = class("mainGame", GameState)

function MainGame:start()
    person = Person(images.people.manblue, "stand")
    person:set_pos(50, 50)

    time = Time(540)

    -- Grab window size
    windowWidth  = love.graphics.getWidth()
    windowHeight = love.graphics.getHeight()
    tx = 0
    ty = 0
    sf = 0.5
    map = sti("assets/maps/1.lua", { "box2d" })
end

function MainGame:update(dt)
    -- update map
    map:update(dt)

    -- map controls
    local kd = love.keyboard.isDown
    local l  = kd("left")  or kd("a")
    local r  = kd("right") or kd("d")
    local u  = kd("up")    or kd("w")
    local d  = kd("down")  or kd("s")

    tx = l and tx - 128*8*dt or tx
    tx = r and tx + 128*8*dt or tx
    ty = u and ty - 128*8*dt or ty
    ty = d and ty + 128*8*dt or ty

    wdt = time:update(dt) -- the time acording to the game world
    person:update(wdt) -- meirl
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

    love.graphics.translate(tx, ty)
    love.graphics.scale(1/sf)

    time:draw()

    love.graphics.print("FPS: " .. love.timer.getFPS(), 5, 5)
end

function MainGame:keypressed(key, scancode, isrepeat)
    if key == "`" then
        time.speed = 0;
    end
    if key == "1" then
        time.speed = 1;
    end
    if key == "2" then
        time.speed = 2;
    end
    if key == "3" then
        time.speed = 3;
    end
    --stack:pop()
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
