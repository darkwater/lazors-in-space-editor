MapBoundary = class("MapBoundary", PolygonShape)

---
-- MapBoundary:initialize
-- Creates a new MapBoundary object.
--
function MapBoundary:initialize(points)
    PolygonShape.initialize(self, points)
end


---
-- MapBoundary:update
-- Updates the MapBoundary.
--
-- @param dt        Time passed since last frame
--
function MapBoundary:update(dt)
    PolygonShape.update(self, dt)
end


---
-- MapBoundary:draw
-- Draws the MapBoundary.
--
function MapBoundary:draw()
    PolygonShape.draw(self)
end
