StaticDebris = class("StaticDebris", PolygonShape)

---
-- StaticDebris:initialize
-- Creates a new StaticDebris object.
--
function StaticDebris:initialize(points)
    PolygonShape.initialize(self, points)
end


---
-- StaticDebris:update
-- Updates the StaticDebris.
--
-- @param dt        Time passed since last frame
--
function StaticDebris:update(dt)
    PolygonShape.update(self, dt)
end


---
-- StaticDebris:draw
-- Draws the StaticDebris.
--
function StaticDebris:draw()
    PolygonShape.draw(self)
end
