require("polygon-shape")
require("static-debris")
require("map-boundary")

require("point-entity")
require("entity-spawner")

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
interface.mapeditor.tools:SetHeight(230)
interface.mapeditor.tools:SetName("Tools")
interface.mapeditor.tools:ShowCloseButton(false)

interface.mapeditor.toolslist = loveframes.Create("list", interface.mapeditor.tools)
interface.mapeditor.toolslist:SetX(0)
interface.mapeditor.toolslist:SetY(25)
interface.mapeditor.toolslist:SetWidth(150)
interface.mapeditor.toolslist:SetHeight(170)
interface.mapeditor.toolslist:SetPadding(5)
interface.mapeditor.toolslist:SetSpacing(5)
for k,v in pairs({ "StaticDebris", "PointEntity" }) do
    local button = loveframes.Create("button", interface.mapeditor.toolslist)
    button:SetText(v)
    button.OnClick = function (self)
        for k,v in pairs(mapeditor.world.objects) do
            if v.creating then mapeditor.world.objects[k] = nil end
        end
        table.insert(mapeditor.world.objects, _G[v]:new())
    end
end

interface.mapeditor.canceltool = loveframes.Create("button", interface.mapeditor.tools)
interface.mapeditor.canceltool:SetX(5)
interface.mapeditor.canceltool:SetY(200)
interface.mapeditor.canceltool:SetWidth(140)
interface.mapeditor.canceltool:SetText("Cancel")
interface.mapeditor.canceltool.OnClick = function (self)
    for k,v in pairs(mapeditor.world.objects) do -- TODO: Too hacky, improve.
        if v.creating then mapeditor.world.objects[k] = nil end
    end
end


interface.mapeditor.options = loveframes.Create("frame", mapeditor)
interface.mapeditor.options:SetX(20)
interface.mapeditor.options:SetY(270)
interface.mapeditor.options:SetWidth(150)
interface.mapeditor.options:SetHeight(100)
interface.mapeditor.options:SetName("Options")
interface.mapeditor.options:ShowCloseButton(false)

interface.mapeditor.gridcheck = loveframes.Create("checkbox", interface.mapeditor.options)
interface.mapeditor.gridcheck:SetX(5)
interface.mapeditor.gridcheck:SetY(25)
interface.mapeditor.gridcheck:SetChecked(true)
interface.mapeditor.gridcheck.OnChanged = function (self)
    mapeditor.gridenabled = self:GetChecked()
end

interface.mapeditor.gridchecklabel = loveframes.Create("text", interface.mapeditor.options) -- TODO: Checkbox:SetText() doesn't work??
interface.mapeditor.gridchecklabel:SetX(35)
interface.mapeditor.gridchecklabel:SetY(26)
interface.mapeditor.gridchecklabel:SetText("Enable grid")

interface.mapeditor.gridsize = loveframes.Create("numberbox", interface.mapeditor.options)
interface.mapeditor.gridsize:SetX(5)
interface.mapeditor.gridsize:SetY(50)
interface.mapeditor.gridsize:SetWidth(140)
interface.mapeditor.gridsize:SetMin(1)
interface.mapeditor.gridsize:SetMax(100)
interface.mapeditor.gridsize:SetValue(5)
interface.mapeditor.gridsize.OnValueChanged = function (self)
    mapeditor.gridsize = self:GetValue()
end


mapeditor.gridsize = 5
mapeditor.gridenabled = true

mapeditor.world = {}
mapeditor.world.objects = {}

mapeditor.world.mousex = 0
mapeditor.world.mousey = 0
mapeditor.world.gridmousex = 0
mapeditor.world.gridmousey = 0

mapeditor.world.camerax = 0
mapeditor.world.cameray = 0

mapeditor.world.zoom = 1
mapeditor.world.zoomtarget = 1


mapeditor.Update = function (self)

    if self:GetHover() then
        mapeditor.world.mousex = mousex - love.graphics.getWidth() / 2 - mapeditor.world.camerax
        mapeditor.world.mousey = mousey - love.graphics.getHeight() / 2 - mapeditor.world.cameray
        mapeditor.world.gridmousex = math.floor(mapeditor.world.mousex / mapeditor.gridsize + .5) * mapeditor.gridsize
        mapeditor.world.gridmousey = math.floor(mapeditor.world.mousey / mapeditor.gridsize + .5) * mapeditor.gridsize
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
            table.insert(self.world.objects, _G[classname]:new(v[2]))
        end
    end

end
