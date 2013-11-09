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
            table.insert(p, mapeditor.world.gridmousex)
            table.insert(p, mapeditor.world.gridmousey)
            self.attemptingConcave = not love.math.isConvex(unpack(p))

        end


        if not self.attemptingConcave then
            if interface.mousepressed["l"] and mapeditor:GetHover() then
                if #self.points >= 6 and math.sqrt((mapeditor.world.gridmousex - self.points[1])^2 + (mapeditor.world.gridmousey - self.points[2])^2) <= 5 then

                    self.creating = false

                else

                    local canPlace = true
                    for i=0, #self.points/2 do

                        local x = self.points[i * 2 + 1]
                        local y = self.points[i * 2 + 2]

                        if x == mapeditor.world.gridmousex and y == mapeditor.world.gridmousey then
                            canPlace = false
                            break
                        end

                    end


                    if canPlace and (self.points[#self.points - 1] ~= mapeditor.world.gridmousex or self.points[#self.points] ~= mapeditor.world.gridmousey) then

                        table.insert(self.points, mapeditor.world.gridmousex)
                        table.insert(self.points, mapeditor.world.gridmousey)

                    end
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
                love.graphics.circle("line", x, y, 5, 10)
            end

            if self.attemptingConcave then love.graphics.setColor(255, 50, 20, 200)
                else love.graphics.setColor(180, 200, 255, 100) end

            love.graphics.line(self.points[#self.points - 1], self.points[#self.points], mapeditor.world.gridmousex, mapeditor.world.gridmousey)

        end

        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.circle("line", mapeditor.world.gridmousex, mapeditor.world.gridmousey, 8, 20)

    else

        love.graphics.polygon("line", self.points)

    end
end
