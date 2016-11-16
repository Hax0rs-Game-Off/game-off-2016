require("util/gamestate")

require("person")
require("time")

local sti = require("util/Simple-Tiled-Implementation/sti")

local Grid = require("util/Jumper/jumper.grid")
local Pathfinder = require("util/Jumper/jumper.pathfinder")

MainGame = class("mainGame", GameState)

debug = false

function setblocked(map, layer)
    for j=1,layer["height"] do
        for i=1,layer["width"] do
            local tile = layer["data"][j][i]
            if tile ~= nil then
                map[j][i] = 1
            end
        end
    end
end

function generatePathfinder(map)
    local test = map.layers["walls"]

    -- generate the plain map
    local mapa = {}
    for j=1,test["height"] do
        mapa[j] = {}
        for i=1,test["width"] do
            mapa[j][i] = 0
        end
    end

    setblocked(mapa, map.layers["walls"])
    setblocked(mapa, map.layers["objects"])
    setblocked(mapa, map.layers["outdoor"])

    local grid = Grid(mapa)
    local walkable = 0
    local myFinder = Pathfinder(grid, 'ASTAR', walkable)
    -- only cardinal directions
    --myFinder:setMode('ORTHOGONAL')

    -- so they cannot go through wall edges
    myFinder:setTunnelling(false)

    myFinder:annotateGrid()

    return myFinder
end

function MainGame:start()
    time = Time(540)

    -- Grab window size
    windowWidth  = love.graphics.getWidth()
    windowHeight = love.graphics.getHeight()

    tx = 0
    ty = 0
    sf = 0.5
    draggin = false

    map = sti("assets/maps/1.lua", { "box2d" })

    local finder = generatePathfinder(map)

    people = {}
    dad = Person(images.people.manblue, "stand", finder)
    mum = Person(images.people.womengreen, "stand", finder)
    dad:set_pos(50, 50)
    mum:set_pos(50, 100)

    people[#people+1] = dad
    people[#people+1] = mum
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

    tx = l and tx - 128*16*dt*sf or tx
    tx = r and tx + 128*18*dt*sf or tx
    ty = u and ty - 128*18*dt*sf or ty
    ty = d and ty + 128*18*dt*sf or ty

    wdt = time:update(dt) -- the time acording to the game world
    for i, person in pairs(people) do
        person:update(wdt) -- meirl
    end
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
    for i, person in pairs(people) do
        person:draw()
    end

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
    if key == "f2" then
        debug = not debug;
    end
end

function MainGame:mousepressed(x, y, button, istouch)
    --person:set_pos(x/sf + tx, y/sf + ty)
    local truex, truey = x/sf + tx, y/sf + ty
    if button == 1 then
        draggin = true
    end
end

function MainGame:mousemoved(x, y, dx, dy, istouch)
    if draggin then
        tx = tx + dx * -1/sf
        ty = ty + dy * -1/sf
    end
end

function MainGame:mousereleased(x, y, button, istouch)
    --person:set_pos(x/sf + tx, y/sf + ty)
    local truex, truey = x/sf + tx, y/sf + ty
    if button == 1 then
        draggin = false
    elseif button == 2 then
        mum:path_to(truex, truey)
    end
end

function MainGame:resize(w, h)
    windowWidth  = w
    windowHeight = h
    map:resize(w, h)
end

function MainGame:wheelmoved(x, y)
    sf = sf * (7/8)^(-y)
end
