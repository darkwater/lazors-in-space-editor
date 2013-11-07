interface.mapeditor = {}
interface.mapeditor.base = loveframes.Create("panel")
local mapeditor = interface.mapeditor.base
mapeditor:SetState("mapeditor")


mapeditor.world = {}
mapeditor.world.objects = {}

mapeditor.world.camerax = 0
mapeditor.world.cameray = 0

mapeditor.world.zoom = 1
mapeditor.world.zoomtarget = 1


mapeditor.Update = function (self)

    -- World objects
    for k,v in pairs(self.world.objects) do
        if v.update then
            v:update()
        end
    end

end


mapeditor.Draw = function (self)

    -- World objects
    love.graphics.push()
    love.graphics.translate(love.graphics.getWidth() / 2 - self.world.camerax, love.graphics.getHeight() / 2 - self.world.cameray)
        for k,v in pairs(self.world.objects) do
            if v.draw then
                v:draw()
            end
        end
    love.graphics.pop()

end


mapeditor.MousePressed = function (self)
    -- TODO: Doesn't get called by LoveFrames yet. fixit

    if but == "wu" then
        self.world.zoomtarget = self.world.zoomtarget * 1.05
    elseif but == "wd" then
        self.world.zoomtarget = self.world.zoomtarget * 0.95
    end

end


mapeditor.LoadMap = function (self, mapname)
    print(mapname)
    self.world.objects = {}

    local str = love.filesystem.read("maps/" .. mapname)
    local obj = json.decode(str)

    for k,v in pairs(obj.mapdata) do
        local classname = v[1]
        if _G[classname] then
            local args = {}

            for i=2, #v do
                args[i-1] = v[i]
            end

            table.insert(self.world.objects, _G[classname]:new(args))
        end
    end
end
