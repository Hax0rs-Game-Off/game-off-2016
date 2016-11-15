Time = class("Time")

function Time:__init(starttime)
    self.total_minutes = starttime
    self.rate = 1/1 -- 1 ingame minute per 1 irl second
    self.speed = 1 -- multiplier
end

function Time:calculate()
    local time = {}

    minutes = math.floor(self.total_minutes % 60)
    total_hours = math.floor(self.total_minutes / 60)
    hours = total_hours % 24
    total_days = math.floor(total_hours / 24)

    time["minutes"] = minutes
    time["hours"] = hours
    time["days"] = total_days
    return time
end

function Time:update(dt)
    wdt = self.speed * dt
    self.total_minutes = self.total_minutes + self.rate * wdt
    return wdt
end

function Time:draw()
    local info = self:calculate()
    local timestring = string.format("Time: %02d:%02d on Day %d (x%d)", info["hours"], info["minutes"], info["days"]+1, self.speed)
    love.graphics.print(timestring, 100, 5, 0, 1, 1)
end
