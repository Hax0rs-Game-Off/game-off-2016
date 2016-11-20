require("ai")

Person = class("Person")

function Person:__init(name, folder, state, finder)
    self.name = name

    self.r = 0
    self.x = 0
    self.y = 0

    self.speed = 5000

    self.finder = finder
    self.path = nil
    self.next_node = nil
    self.nodes = nil
    self.callback = nil

    self.currentLoc = nil
    self.targetLoc = nil

    self.needs = {}
    self.needs_decay = {}
    self.needs_callback = {}
    self.needs_objects = {}
    -- order of importance
    self:addNeed("Bladder", 100, 2, function() print("0 bladder, pee self") end)
    self:addNeed("Hunger", 100, 10, function() print("0 hunger, dead") end)
    self:addNeed("Sleep", 100, 3, function() print("0 sleep, passout") end)
    self:addNeed("Fun", 100, 1, function() print("0 fun, cry") end)

    self.us = folder
    self:change_state(state)

    self.ai = AI(self)
end

function Person:addNeedLocation(need, location)
    self.needs_objects[need][#self.needs_objects[need]+1] = location
end

function Person:addNeed(name, initial, decay_rate, callback)
    self.needs[name] = initial
    self.needs_decay[name] = decay_rate
    self.needs_callback[name] = callback
    self.needs_objects[name] = {}
end

function Person:change_state(state)
    self.state = state
    self.currentImage = self.us[state]
    self.ciw = self.currentImage:getWidth()
    self.cih = self.currentImage:getHeight()
end

function Person:set_pos(x, y)
    self.x = x + self.ciw/2
    self.y = y + self.cih/2
end

function Person:go_to(object)
    if object.inuse then return end

    if self.currentLoc then
        self.currentLoc.inuse = false
        self.currentLoc = nil
    end

    if self.targetLoc then
        self.targetLoc.inuse = false
        self.currentTatget = nil
    end

   self.targetLoc = object

    -- as we are going to use it, stop others from snatching
    object.inuse = true;

    self:path_to(object.x, object.y, function()
        self.r = (object.properties["face"]-1) * 1.5708; 
        self.currentLoc = object;
        self.targetLoc = nil;
    end)
end

function Person:path_to(x, y, callback)
    local tilesx, tilesy = math.floor(self.x/128)+1, math.floor(self.y/128)+1
    local tilex, tiley = math.floor(x/128)+1, math.floor(y/128)+1

    local path = self.finder:getPath(tilesx, tilesy, tilex, tiley, 1)
    if path then
        self.path = path
        self.nodes = self.path:nodes()
        self.next_node = self.nodes()
        self.callback = callback
    else
        self.path = nil
        self.nodes = nil
        self.next_node = nil
        self.callback = nil
    end
end

function Person:getCenter()
    local out = {}
    out.x = self.x-self.ciw/2
    out.y = self.y-self.cih/2
    return out
end

function Person:getNextAvail(need)
    for k, v in pairs(self.needs_objects[need]) do
        if not v.inuse then
            return v
        end
    end
    return nil
end

function Person:update(dt)
    for k, v in pairs(self.needs) do
        -- if we are increasing, we only care about increasing
        if self.currentLoc and self.currentLoc.properties["need"] == k then
            -- apply increase
            self.needs[k] = self.needs[k] + self.currentLoc.properties["need_boost"] * dt
            -- set maximum
            self.needs[k] = self.needs[k] > 100 and 100 or self.needs[k]
        elseif self.needs[k] > 0 then -- skip over zero needs
            -- apply decay
            self.needs[k] = self.needs[k] - self.needs_decay[k] * dt
            -- set minimum
            self.needs[k] = self.needs[k] < 0 and 0 or self.needs[k]
            if self.needs[k] <= 0 then -- callback
                self.needs_callback[k]()
            end
        end
    end

    if self.path then
        if self.next_node then
            local center = self:getCenter()
            local tox, toy = self.next_node:getX()*128-64, self.next_node:getY()*128-64;
            local xa = tox - center.x
            local ya = toy - center.y
            local len = math.sqrt(xa*xa + ya*ya)
            if len < dt * self.speed then -- if we can get there in one step
                -- teleport them to on point
                self:set_pos(tox, toy)
                self.next_node = self.nodes()
                if self.next_node == nil then
                    self.path = nil
                    self.nodes = nil
                    if self.callback then
                        self.callback()
                        self.callback = nil
                    end
                end
            else
                self.r = math.atan2(ya, xa)
                self.x = self.x + dt * xa/len * self.speed
                self.y = self.y + dt * ya/len * self.speed
            end
        end
    end

    -- AI here
    self.ai:think(dt)
end

function Person:getinfostring()
    local info = {}
    for k,v in pairs(self.needs) do
        info[k] = string.format("%02d", self.needs[k])
    end
    info["Name"] = self.name
    info["State"] = self.state
    info["CurrentLoc"] = self.currentLoc and self.currentLoc.name or "none"
    info["TargetLoc"] = self.targetLoc and self.targetLoc.name or "none"
    local infostring = ""
    for k,v in pairs(info) do
        infostring = infostring .. k .. ": " .. v .. "\n"
    end
    return infostring
end

function Person:draw()
    local center = self:getCenter()
    love.graphics.draw(self.currentImage, center.x, center.y, self.r, 2, 2, self.ciw/2, self.cih/2)
    if debug then
        if self.path then
            local points = {}
            for node, count in self.path:nodes() do
                points[#points+1] = node:getX()*128 - 64
                points[#points+1] = node:getY()*128 - 64
            end
            love.graphics.line(points)
            if self.next_node ~= nil then
               love.graphics.setColor(255,0,0)
               love.graphics.line(center.x, center.y, self.next_node:getX()*128 - 64, self.next_node:getY()*128-64)
               love.graphics.setColor(255,255,255)
            end
        end
        love.graphics.print(self:getinfostring(), self.x, self.y, 0, 1, 1)
    end
end
