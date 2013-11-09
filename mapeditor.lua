interface.mapeditor = {}
interface.mapeditor.base = loveframes.Create("panel")
mapeditor = interface.mapeditor.base
mapeditor:SetState("mapeditor")
mapeditor:SetX(0)
mapeditor:SetY(0)
mapeditor:SetWidth(1024)
mapeditor:SetHeight(768)

interface.mapeditor.tools = loveframes.Create("frame", mapeditor)
interface.mapeditor.tools:SetX(20)
interface.mapeditor.tools:SetY(20)
interface.mapeditor.tools:SetWidth(150)
interface.mapeditor.tools:SetHeight(300)
interface.mapeditor.tools:SetName("Tools")
interface.mapeditor.toolslist = loveframes.Create("list", interface.mapeditor.tools)
interface.mapeditor.toolslist:SetX(0)
interface.mapeditor.toolslist:SetY(25)
interface.mapeditor.toolslist:SetWidth(150)
interface.mapeditor.toolslist:SetHeight(295)
interface.mapeditor.toolslist:SetPadding(5)
interface.mapeditor.toolslist:SetSpacing(5)
for k,v in pairs({ "StaticDebris", "PointEntity" }) do
    local button = loveframes.Create("button", interface.mapeditor.toolslist)
    button:SetText(v)
    button.OnClick = function (self)
        table.insert(mapeditor.world.objects, _G[v]:new())
    end
end


mapeditor.world = {}
mapeditor.world.objects = {}

mapeditor.world.mousex = 0
mapeditor.world.mousey = 0

mapeditor.world.camerax = 0
mapeditor.world.cameray = 0

mapeditor.world.zoom = 1
mapeditor.world.zoomtarget = 1


mapeditor.Update = function (self)

    if self:GetHover() then
        mapeditor.world.mousex = mousex - love.graphics.getWidth() / 2 - mapeditor.world.camerax
        mapeditor.world.mousey = mousey - love.graphics.getHeight() / 2 - mapeditor.world.cameray
    end


    -- World objects
    for k,v in pairs(self.world.objects) do
        if v.update then
            v:update()
        end
    end


    -- Zooming
    if interface.mousepressed["wu"] and self:GetHover() then
        self.world.zoomtarget = self.world.zoomtarget * 1.05
    end
    if interface.mousepressed["wd"] and self:GetHover() then
        self.world.zoomtarget = self.world.zoomtarget * 0.95
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


mapeditor.LoadMap = function (self, mapname)

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
