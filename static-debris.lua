StaticDebris = class("StaticDebris", PolygonShape)

function StaticDebris:initialize(points)
    PolygonShape.initialize(self, points)
end


function StaticDebris:update(dt)
    PolygonShape.update(self, dt)
end


function StaticDebris:draw()
    PolygonShape.draw(self)
end


function StaticDebris:GetDataTable()
    if self.creating then return end

    return { "StaticDebris", {
        points = self.points
    } }
end
