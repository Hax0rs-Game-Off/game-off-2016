-- gamestack

require("util/helper")

GameStack = class("GameStack")

function GameStack:__init()
    self.states = {}
end

function GameStack:current()
    if #self.states > 0 then
        return self.states[#self.states]
    else
        return nil
    end
end

function GameStack:push(state)
    if self:current() then self:current():stop() end
    table.insert(self.states, state)
    self:current():start()
end

function GameStack:pop()
    if not self:current() then return end
    self:current():stop()
    table.remove(self.states, #self.states)
    if self:current() then
        self:current():start()
    else
        love.event.quit()
    end
end

function GameStack:update(dt)
    if self:current() then self:current():update(dt) end
end

function GameStack:draw()
    if self:current() then self:current():draw() end
end

function GameStack:keypressed(key, scancode, isrepeat)
    if self:current() then self:current():keypressed(key, scancode, isrepeat) end
end

function GameStack:mousepressed(x, y, button, istouch)
    if self:current() then self:current():mousepressed(x, y, button, istouch) end
end

function GameStack:mousereleased(x, y, button, istouch)
    if self:current() then self:current():mousereleased(x, y, button, istouch) end
end

function GameStack:mousemoved(x, y, dx, dy, istouch)
    if self:current() then self:current():mousemoved(x, y, dx, dy, istouch) end
end

function GameStack:wheelmoved(x, y)
    if self:current() then self:current():wheelmoved(x, y) end
end

function GameStack:resize(w, h)
    if self:current() then self:current():resize(w, h) end
end
