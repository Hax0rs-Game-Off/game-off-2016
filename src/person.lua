
Person = class("Person")

function Person:__init(folder, state)
    self.r = 0
    self.x = 0
    self.y = 0

    self.hunger = 100
    self.hunger_decay = -10
    self.sleepy = 100
    self.sleepy_decay = -10

    self.us = folder
    self:change_state(state)
end

function Person:change_state(state)
    self.state = state
    self.currentImage = self.us[state]
    self.ciw = self.currentImage:getWidth()
    self.cih = self.currentImage:getHeight()
end

function Person:set_pos(x, y)
    self.x = x
    self.y = y
end

function Person:update(dt)
    self.r = self.r + 2 * dt
    self.hunger = self.hunger + self.hunger_decay * dt
    self.sleepy = self.sleepy + self.sleepy_decay * dt
end

function Person:draw()
    love.graphics.draw(self.currentImage, self.x-self.ciw/2, self.y-self.cih/2, self.r, 1, 1, self.ciw/2, self.cih/2)
end
