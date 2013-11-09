PolygonShape = class("PolygonShape")

---
-- PolygonShape:initialize
-- Creates a new PolygonShape object.
--
function PolygonShape:initialize(points)
    self.points = points or {}
    self.creating = not points
    self.attemptingConcave = false
end


---
-- PolygonShape:update
-- Updates the PolygonShape.
--
-- @param dt        Time passed since last frame
--
function PolygonShape:update(dt)
    if self.creating then
        if #self.points >= 4 then
            local p = { unpack(self.points) }
            table.insert(p, mousex)
            table.insert(p, mousey)
            self.attemptingConcave = not love.math.isConvex(unpack(p))
        end

        if not self.attemptingConcave then
            if interface.mousepressed["l"] and mapeditor:GetHover() then
                local canPlace = true
                for i=0, #self.points/2 - 1 do
                    local x = self.points[i * 2 + 1]
                    local y = self.points[i * 2 + 2]
                    if x == mousex and y == mousey then
                        canPlace = false
                        break
                    end
                end

                if self.points[#self.points - 1] ~= mousex or self.points[#self.points] ~= mousey then
                    table.insert(self.points, mousex)
                    table.insert(self.points, mousey)
                end
            end
        end
    end
end


---
-- PolygonShape:draw
-- Draws the PolygonShape.
--
function PolygonShape:draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setLineWidth(1.2)

    if self.creating then
        if #self.points > 0 then

            if #self.points >= 4 then
                love.graphics.line(self.points)
            end

            for i=0, #self.points/2 - 1 do
                local x = self.points[i * 2 + 1]
                local y = self.points[i * 2 + 2]
                love.graphics.circle("line", x, y, 4, 10)
            end

            if self.attemptingConcave then love.graphics.setColor(255, 50, 20, 200)
                else love.graphics.setColor(180, 200, 255, 100) end

            love.graphics.line(self.points[#self.points - 1], self.points[#self.points], mousex, mousey)

        end

        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.circle("line", mousex, mousey, 8, 20)
        love.graphics.print(self.debug or "", mousex + 10, mousey + 20)

    else

        love.graphics.polygon("line", self.points)

    end
end
