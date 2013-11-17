PointEntity = class("PointEntity")

function PointEntity:initialize(data)
    if not data then data = {} end

    if not data.x or not data.y then
        self.x = 0
        self.y = 0
        self.creating = true
    else
        self.x = data.x
        self.y = data.y
        self.creating = false
    end

    self.radius = data.radius or 12
    self.hovering = false

    self.onMove = data.onMove or nil
    self.onRemove = data.onRemove or nil
end


function PointEntity:update(dt)
    if self.creating then
        if mapeditor.world.mousepressed then
            self.x = mapeditor.world.gridmousex
            self.y = mapeditor.world.gridmousey
            self.creating = false
        end
    else
        self.hovering = self.grabbed or mapeditor:GetHover() and not mapeditor.world.mouseonobject and util.distance(mapeditor.world.mousex, mapeditor.world.mousey, self.x, self.y) < self.radius

        if self.grabbed then
            if interface.mousereleased["l"] then
                self.grabbed = false
            else
                mapeditor.world.mouseonobject = true
                if self.x ~= mapeditor.world.gridmousex or self.y ~= mapeditor.world.gridmousey then
                    self.x = mapeditor.world.gridmousex
                    self.y = mapeditor.world.gridmousey

                    if self.onMove then self:onMove(x, y) end
                end
            end
        elseif self.hovering then
            mapeditor.world.mouseonobject = true

            if interface.mousepressed["l"] then
                self.grabbed = true
            end
        end
    end

    if interface.mousepressed["m"] and self.hovering and self.onRemove then
        self:onRemove()
    end
end


function PointEntity:draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setPointSize(5)

    if self.creating then
        love.graphics.point(mapeditor.world.gridmousex, mapeditor.world.gridmousey)
        love.graphics.circle("line", mapeditor.world.gridmousex, mapeditor.world.gridmousey, 8, 5)
    else
        if self.hovering then
            love.graphics.setColor(100, 100, 100, 255)
            love.graphics.circle("fill", self.x, self.y, self.radius, math.max(10, self.radius))
        end

        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.point(self.x, self.y)
        love.graphics.circle("line", self.x, self.y, self.radius, math.max(10, self.radius))
    end

end
