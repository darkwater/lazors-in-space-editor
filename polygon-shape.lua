PolygonShape = class("PolygonShape")

function PolygonShape:initialize(data)
    if data then
        self.points = {}
        for i=0, #data.points/2-1 do
            local x = data.points[i * 2 + 1]
            local y = data.points[i * 2 + 2]
            table.insert(self.points, PointEntity:new({
                x = x,
                y = y,
                radius = 8
            }))
        end

        self.creating = false
    else
        self.points = {}
        self.creating = true
    end

    self.attemptingConcave = false
end


function PolygonShape:update(dt)
    if self.creating then
        if #self.points >= 4 then

            local p = {}

            for k,v in pairs(self.points) do
                table.insert(p, v.x)
                table.insert(p, v.y)
            end

            table.insert(p, mapeditor.world.gridmousex)
            table.insert(p, mapeditor.world.gridmousey)
            self.attemptingConcave = not love.math.isConvex(unpack(p))

        end


        if not self.attemptingConcave then
            if mapeditor.world.mousepressed then
                if #self.points >= 3 and util.distance(mapeditor.world.gridmousex, mapeditor.world.gridmousey, self.points[1].x, self.points[1].y) <= 5 then

                    self.creating = false

                else

                    local canPlace = true
                    for k,v in pairs(self.points) do
                        if v.x == mapeditor.world.gridmousex and v.y == mapeditor.world.gridmousey then
                            canPlace = false
                            break
                        end
                    end


                    if canPlace and (self.points[#self.points - 1] ~= mapeditor.world.gridmousex or self.points[#self.points] ~= mapeditor.world.gridmousey) then

                        table.insert(self.points, PointEntity:new({
                            x = mapeditor.world.gridmousex,
                            y = mapeditor.world.gridmousey,
                            radius = 8
                        }))

                    end
                end
            end
        end
    else -- not creating

        for k,v in pairs(self.points) do
            v:update()
        end

    end
end


function PolygonShape:draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setLineWidth(1.2)

    if self.creating then
        if #self.points > 0 then

            local p = {}

            for k,v in pairs(self.points) do
                table.insert(p, v.x)
                table.insert(p, v.y)
                love.graphics.circle("line", v.x, v.y, 5, 10)
            end

            if #p >= 4 then
                love.graphics.line(p)
            end

            if self.attemptingConcave then love.graphics.setColor(255, 50, 20, 200)
                else love.graphics.setColor(180, 200, 255, 100) end

            love.graphics.line(self.points[#self.points].x, self.points[#self.points].y, mapeditor.world.gridmousex, mapeditor.world.gridmousey)

        end

        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.circle("line", mapeditor.world.gridmousex, mapeditor.world.gridmousey, 8, 20)

    else

        local p = {}

        for k,v in pairs(self.points) do
            table.insert(p, v.x)
            table.insert(p, v.y)
        end

        love.graphics.polygon("line", p)

        for k,v in pairs(self.points) do
            v:draw()
        end

    end
end
