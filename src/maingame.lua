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
    time = Time(540, images.sky)

    -- Grab window size
    windowWidth  = love.graphics.getWidth()
    windowHeight = love.graphics.getHeight()

    tx = 0
    ty = 0
    sf = 0.5
    draggin = false

    map = sti("assets/maps/apartment.lua", { "box2d" })

    local finder = generatePathfinder(map)

    objects = {}

    for k,v in pairs(map.layers["locations"].objects) do
        objects[v.name] = v
        objects[v.name].inuse = false
    end

    people = {}
    for k,v in pairs(map.layers["people"].objects) do
        person = Person(v.name, images.people[v.properties["sprite"]], "stand", finder)
        person:set_pos(v.x+64, v.y+64) -- for the middle of the tile
        people[v.name] = person
    end
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
    love.graphics.setBackgroundColor(time:getColor())
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
    if key == "4" then
        time.speed = 4;
    end
    if key == "5" then
        time.speed = 5;
    end
    if key == "6" then
        time.speed = 10;
    end
    if key == "7" then
        time.speed = 20;
    end
    if key == "8" then
        time.speed = 60;
    end
    if key == "9" then
        time.speed = 240;
    end
    if key == "f2" then
        debug = not debug;
        map.layers["locations"].visible = debug
    end
end

function MainGame:mousepressed(x, y, button, istouch)
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

function MainGame:getObject(x, y)
    for k, v in pairs(objects) do
        if x >= v.x and x <= v.x+v.width and
           y >= v.y and y <= v.y+v.height then
            return v
        end
    end
    return nil
end

function MainGame:mousereleased(x, y, button, istouch)
    local truex, truey = x/sf + tx, y/sf + ty
    if button == 1 then
        draggin = false
    elseif button == 2 then
        -- get the object under the mouse
        local obj = self:getObject(truex, truey)
        if obj ~= nil then
            people["mum"]:go_to(obj)
        end
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
