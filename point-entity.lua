PointEntity = class("PointEntity")

---
-- PointEntity:initialize
-- Creates a new PointEntity object.
--
function PointEntity:initialize(data)
    if data then
        self.x = data.x
        self.y = data.y
        self.creating = false
    else
        self.x = 0
        self.y = 0
        self.creating = true
    end
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
            self.x = mapeditor.world.gridmousex
            self.y = mapeditor.world.gridmousey
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
        love.graphics.point(mapeditor.world.gridmousex, mapeditor.world.gridmousey)
        love.graphics.circle("line", mapeditor.world.gridmousex, mapeditor.world.gridmousey, 8, 5)
    else
        love.graphics.point(self.x, self.y)
        love.graphics.circle("line", self.x, self.y, 12, 20)
    end

end
