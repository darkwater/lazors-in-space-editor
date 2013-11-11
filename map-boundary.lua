MapBoundary = class("MapBoundary", PolygonShape)

function MapBoundary:initialize(points)
    PolygonShape.initialize(self, points)
end


function MapBoundary:update(dt)
    PolygonShape.update(self, dt)
end


function MapBoundary:draw()
    PolygonShape.draw(self)
end


function MapBoundary:GetDataTable()
    if self.creating then return end

    return { "MapBoundary", {
        points = self.points
    } }
end
