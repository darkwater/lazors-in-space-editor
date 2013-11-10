EntitySpawner = class("EntitySpawner", PointEntity)

---
-- EntitySpawner:initialize
-- Creates a new EntitySpawner object.
--
function EntitySpawner:initialize(data)
    PointEntity.initialize(self, data)

    data = data or {}
    self.type = data.type or ""
end


---
-- EntitySpawner:update
-- Updates the EntitySpawner.
--
-- @param dt        Time passed since last frame
--
function EntitySpawner:update(dt)
    PointEntity.update(self, dt)
end


---
-- EntitySpawner:draw
-- Draws the EntitySpawner.
--
function EntitySpawner:draw()
    PointEntity.draw(self)

    love.graphics.print(self.type, self.x - 12, self.y + 15)
end
