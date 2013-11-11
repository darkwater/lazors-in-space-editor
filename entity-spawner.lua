EntitySpawner = class("EntitySpawner", PointEntity)

function EntitySpawner:initialize(data)
    PointEntity.initialize(self, data)

    data = data or {}
    self.type = data.type or ""
end


function EntitySpawner:update(dt)
    PointEntity.update(self, dt)
end


function EntitySpawner:draw()
    PointEntity.draw(self)

    love.graphics.print(self.type, self.x - 12, self.y + 15)
end


function EntitySpawner:GetDataTable()
    if self.creating then return end

    return { "EntitySpawner", {
        x = self.x,
        y = self.y,
        type = "BaseAI",
        data = {},
        interval = {1, 12},
        amount = {1, 4}
    } }
end
