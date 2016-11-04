require("tile")

Map = class("Map")

function Map:__init(width, height)
    self.width = width
    self.height = height
    -- image width and height for this setup
    self.tw = 64
    self.th = 64

    test = {Tile(images.tiles.tile_01, true), Tile(images.tiles.tile_120, false)}

    self.grid = {}
    for i = 1, self.width do
        self.grid[i] = {}
        for j = 1, self.height do
            -- get a random tile by reference
            self.grid[i][j] = test[math.random(#test)]
        end
    end
end

function Map:update(dt)
end

function Map:draw()
    -- use a canvas, enventually we will want to move the drawing around
    canvas = love.graphics.newCanvas(self.tw*self.width, self.th*self.height)
    love.graphics.setCanvas(canvas)
    for i = 1, self.width do
        for j = 1, self.height do
            love.graphics.draw(self.grid[i][j].image, (i-1)*self.tw, (j-1)*self.th, 0, 1, 1)
        end
    end
    -- go back to normal
    love.graphics.setCanvas()
    love.graphics.draw(canvas, 0, 0)
end
