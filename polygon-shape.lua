PolygonShape = class("PolygonShape")

function PolygonShape:initialize(data)
    if data then
        self.points = {}
        for i=0, #data.points/2-1 do
            local x = data.points[i * 2 + 1]
            local y = data.points[i * 2 + 2]
            self:addPoint(x, y)
        end

        self.creating = false
    else
        self.points = {}
        self.creating = true
    end

    self.invalid = false
    self.canconvex = false
    self.hover = false
end


function PolygonShape:update(dt)
    if self.creating then

        mapeditor.world.hoverobject = self

        if #self.points >= 3 and not self.canconvex then

            local p = {}

            for k,v in pairs(self.points) do
                table.insert(p, v.x)
                table.insert(p, v.y)
            end

            table.insert(p, mapeditor.world.gridmousex)
            table.insert(p, mapeditor.world.gridmousey)
            self.invalid = not love.math.isConvex(unpack(p))

        end


        if not self.invalid then
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

                        self:addPoint(mapeditor.world.gridmousex, mapeditor.world.gridmousey)

                    end
                end
            end
        end
    else -- not creating

        for k,v in pairs(self.points) do
            v:update()
        end

        self.hover = false
        if mapeditor:GetHover() and not mapeditor.world.hoverobject then

            for i = 1, #self.points do
                local j = (i < #self.points) and (i + 1) or 1
                local a, b = self.points[i], self.points[j]
                local dist, u = util.distancePointToLine(a.x, a.y, b.x, b.y, mapeditor.world.mousex, mapeditor.world.mousey)

                if dist < 10 then
                    local x = util.lerp(a.x, b.x, u)
                    local y = util.lerp(a.y, b.y, u)
                    self.hover = {x=x, y=y, i=i}
                    mapeditor.world.hoverobject = self
                end
            end

        end

        if self.hover and interface.mousepressed["l"] then
            self:addPoint(self.hover.x, self.hover.y, self.hover.i + 1, true)
        end

        if self.hover and interface.mousepressed["r"] then
            self:ContextMenu()
        end

    end
end


function PolygonShape:ContextMenu()
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

            if self.invalid then love.graphics.setColor(255, 50, 20, 200)
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

        if self.invalid then love.graphics.setColor(255, 50, 20, 200)
            else love.graphics.setColor(255, 255, 255, 255) end

        love.graphics.polygon("line", p)

        if self.hover then
            love.graphics.setPointSize(10)
            love.graphics.setColor(150, 255, 150)
            love.graphics.point(self.hover.x, self.hover.y)
        end

        for k,v in pairs(self.points) do
            v:draw()
        end

    end
end


function PolygonShape:addPoint(x, y, i, grabbed)
    local ent = PointEntity:new({
        x = x,
        y = y,
        radius = 8,
        onMove = function ()

            if self.canconvex then return end

            local p = {}

            for k,v in pairs(self.points) do
                table.insert(p, v.x)
                table.insert(p, v.y)
            end

            self.invalid = not love.math.isConvex(unpack(p))

        end,
        onRemove = function (point)

            local id = 0
            for i=1, #self.points do
                if self.points[i] == point then
                    id = i
                    break
                end
            end
            if id == 0 then return end

            table.remove(self.points, id)

            if #self.points <= 2 then
                self:remove()
            end

        end,
        onContextMenu = function ()
        
            self:ContextMenu()

        end
    })
    ent.grabbed = grabbed
    if i then table.insert(self.points, i, ent)
         else table.insert(self.points, ent) end
end
