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

    local p = {}

    for k,v in pairs(self.points) do
        table.insert(p, v.x)
        table.insert(p, v.y)
    end

    return { "MapBoundary", {
        points = p
    } }
end
