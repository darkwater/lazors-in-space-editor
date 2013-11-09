PointEntity = class("PointEntity")

---
-- PointEntity:initialize
-- Creates a new PointEntity object.
--
function PointEntity:initialize(x, y)
    self.x = x or 0
    self.y = y or 0
    self.creating = x == nil or y == nil
end


---
-- PointEntity:update
-- Updates the PointEntity.
--
-- @param dt        Time passed since last frame
--
function PointEntity:update(dt)
    if self.creating then
        if interface.mousepressed["l"] and mapeditor:GetHover() then
            self.x = mapeditor.world.mousex
            self.y = mapeditor.world.mousey
            self.creating = false
        end
    end
end



---
-- PointEntity:draw
-- Draws the PointEntity.
--
function PointEntity:draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setPointSize(5)

    if self.creating then
        love.graphics.point(mapeditor.world.mousex, mapeditor.world.mousey)
        love.graphics.circle("line", mapeditor.world.mousex, mapeditor.world.mousey, 8, 5)
    else
        love.graphics.point(self.x, self.y)
        love.graphics.circle("line", self.x, self.y, 12, 20)
    end

end
