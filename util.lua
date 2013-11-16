util = {}

function util.distance(x1, y1, x2, y2)
    return math.sqrt((x2-x1) ^ 2 + (y2-y1) ^ 2)
end

function util.pointInRectangle(x1, y1, x2, y2, w2, h2)
    return x1 > x2 and y1 > y2 and x1 < x2 + w2 and y1 < y2 + h2
end
