util = {}

function util.distance(x1, y1, x2, y2)
    return math.sqrt((x2-x1) ^ 2 + (y2-y1) ^ 2)
end

function util.pointInRectangle(px, py, rx, ry, rw, rh)
    return px > rx and py > ry and px < rx + rw and py < ry + rh
end

function util.distancePointToLine(x1, y1, x2, y2, px, py)
    local lx = x2 - x1
    local ly = y2 - y1

    local d = lx*lx + ly*ly

    local u = ((px - x1) * lx + (py - y1) * ly) / d

    if u > 1 then
        u = 1
    elseif u < 0 then
        u = 0
    end

    local x = x1 + u * lx
    local y = y1 + u * ly

    local dx = x - px
    local dy = y - py

    dist = math.sqrt(dx*dx + dy*dy)

    return dist, u
end

function util.lerp(x, y, a)
    return x + (y - x) * a
end
