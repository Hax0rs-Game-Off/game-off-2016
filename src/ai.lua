
AI = class("AI")

function AI:__init(host)
    self.host = host
end

function AI:think(dt)
    for k, v in pairs(self.host.needs) do
        if self.host.needs[k] < 30 then
            -- check we are not inroute to a fixup or at one already
            if (not (self.host.currentLoc and self.host.currentLoc.properties["need"] == k)) and
                (not (self.host.targetLoc and self.host.targetLoc.properties["need"] == k)) then
                print(self.host.name .. " is low on " .. k)
                local fixingLoc = self.host:getNextAvail(k)
                if fixingLoc then
                    print("Going to " .. fixingLoc.name .. " for fix")
                    self.host:go_to(fixingLoc)
                    break
                else
                    print("Cannot find my fix")
                end
            else
                break -- don't let another need take over
            end
        end
    end
end

