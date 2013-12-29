require("polygon-shape")
require("static-debris")

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


interface.mapeditor.options = loveframes.Create("frame", mapeditor)
interface.mapeditor.options:SetX(20)
interface.mapeditor.options:SetY(20)
interface.mapeditor.options:SetWidth(150)
interface.mapeditor.options:SetHeight(150)
interface.mapeditor.options:SetName("Actions")
interface.mapeditor.options:ShowCloseButton(false)

    interface.mapeditor.optionslist = loveframes.Create("list", interface.mapeditor.options)
    interface.mapeditor.optionslist:SetX(0)
    interface.mapeditor.optionslist:SetY(25)
    interface.mapeditor.optionslist:SetWidth(150)
    interface.mapeditor.optionslist:SetHeight(125)
    interface.mapeditor.optionslist:SetPadding(5)
    interface.mapeditor.optionslist:SetSpacing(5)

    interface.mapeditor.option_save = loveframes.Create("button", interface.mapeditor.optionslist)
    interface.mapeditor.option_save:SetText("Save")
    interface.mapeditor.option_save.OnClick = function (self)
        mapeditor:SaveTo(mapeditor.mapname)
    end

    interface.mapeditor.option_saveas = loveframes.Create("button", interface.mapeditor.optionslist)
    interface.mapeditor.option_saveas:SetText("Save as...")
    interface.mapeditor.option_saveas.OnClick = function (self)
        mapeditor:SaveAs()
    end

    interface.mapeditor.option_close = loveframes.Create("button", interface.mapeditor.optionslist)
    interface.mapeditor.option_close:SetText("Close")
    interface.mapeditor.option_close.OnClick = function (self)
        loveframes.SetState("mapselect")
    end


interface.mapeditor.tools = loveframes.Create("frame", mapeditor)
interface.mapeditor.tools:SetX(20)
interface.mapeditor.tools:SetY(190)
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
    for k,v in pairs({ "StaticDebris", "EntitySpawner" }) do
        local button = loveframes.Create("button", interface.mapeditor.toolslist)
        button:SetText(v)
        button.OnClick = function (self)
            for k,v in pairs(mapeditor.world.objects) do
                if v.creating then mapeditor.world.objects[k] = nil end
            end
            local id = #mapeditor.world.objects + 1
            table.insert(mapeditor.world.objects, _G[v]:new(nil, id))
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
interface.mapeditor.options:SetY(440)
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
    interface.mapeditor.gridsize:SetValue(50)
    interface.mapeditor.gridsize.OnValueChanged = function (self)
        mapeditor.gridsize = self:GetValue()
    end


mapeditor.gridsize = 50
mapeditor.gridenabled = true

mapeditor.world = {}
mapeditor.world.objects = {}

mapeditor.world.mousex = 0
mapeditor.world.mousey = 0
mapeditor.world.gridmousex = 0
mapeditor.world.gridmousey = 0
mapeditor.world.hoverobject = nil

mapeditor.world.mousedown = false
mapeditor.world.mousepressed = false

mapeditor.world.camerax = 0
mapeditor.world.cameray = 0
mapeditor.world.cameragrabx = 0
mapeditor.world.cameragraby = 0
mapeditor.world.cameragrabbed = false

mapeditor.world.zoom = 1
mapeditor.world.zoomtarget = 1


mapeditor.Update = function (self)

    self.world.hoverobject = nil

    if self:GetHover() then
        mapeditor.world.mousex = mousex - (love.graphics.getWidth() / 2 - mapeditor.world.camerax)
        mapeditor.world.mousey = mousey - (love.graphics.getHeight() / 2 - mapeditor.world.cameray)
        mapeditor.world.gridmousex = mapeditor.gridenabled and (math.floor(mapeditor.world.mousex / mapeditor.gridsize + .5) * mapeditor.gridsize) or mapeditor.world.mousex
        mapeditor.world.gridmousey = mapeditor.gridenabled and (math.floor(mapeditor.world.mousey / mapeditor.gridsize + .5) * mapeditor.gridsize) or mapeditor.world.mousey

        if interface.mousepressed["l"] then
            if love.keyboard.isDown(" ") then
                mapeditor.world.cameragrabbed = true
                mapeditor.world.cameragrabx = mousex
                mapeditor.world.cameragraby = mousey
                love.mouse.setVisible(false)
                interface.mousepressed["l"] = false
            else
                mapeditor.world.mousedown = true
                mapeditor.world.mousepressed = true
            end
        end
    end

    if not love.mouse.isDown("l") and mapeditor.world.mousedown then
        mapeditor.world.mousedown = false
    end

    if mapeditor.world.cameragrabbed then
        if love.mouse.isDown("l") then
            mapeditor.world.camerax = mapeditor.world.camerax - (mousex - mapeditor.world.cameragrabx)
            mapeditor.world.cameray = mapeditor.world.cameray - (mousey - mapeditor.world.cameragraby)
            love.mouse.setPosition(mapeditor.world.cameragrabx, mapeditor.world.cameragraby)
        else
            mapeditor.world.cameragrabbed = false
            love.mouse.setVisible(true)
        end
    end


    -- World objects
    local toupdate = {}
    for k,v in pairs(self.world.objects) do
        if v.update then
            table.insert(toupdate, v)
        end
    end
    for i = #toupdate, 1, -1 do
        toupdate[i]:update()
    end


    -- -- Zooming -- do we even want this
    -- if interface.mousepressed["wu"] and self:GetHover() then
    --     self.world.zoomtarget = self.world.zoomtarget * 1.1
    -- end
    -- if interface.mousepressed["wd"] and self:GetHover() then
    --     self.world.zoomtarget = self.world.zoomtarget * 0.9
    -- end
    -- mapeditor.world.zoom = mapeditor.world.zoom + (mapeditor.world.zoomtarget - mapeditor.world.zoom) / 5

end


mapeditor.Draw = function (self)


    -- World
    love.graphics.push()  
    love.graphics.translate(love.graphics.getWidth() / 2 - self.world.camerax, love.graphics.getHeight() / 2 - self.world.cameray)

        -- Spawnpoint
        love.graphics.setPointSize(5)
        love.graphics.setColor(255, 175, 0)
        love.graphics.point(0, 0)

        for k,v in pairs(self.world.objects) do
            if v.draw then
                v:draw()
            end
        end

    love.graphics.pop()


    mapeditor.world.mousepressed = false

end


mapeditor.LoadMap = function (self, name)

    self.mapname = name

    self.world.objects = {}

    local str = love.filesystem.read("maps/" .. name)
    self.mapdata = json.decode(str)

    for k,v in pairs(self.mapdata.mapdata) do
        local classname = v[1]
        if _G[classname] then
            local id = #self.world.objects + 1
            table.insert(self.world.objects, _G[classname]:new(v[2], id))
        end
    end

end


mapeditor.SaveTo = function (self, name)

    local obj = self.mapdata

    obj.mapdata = {}
    for k,v in pairs(self.world.objects) do
        if v.GetDataTable then
            table.insert(obj.mapdata, v:GetDataTable())
        end
    end

    love.filesystem.write("maps/" .. name, json.encode(obj) .. "\n")

end


mapeditor.SaveAs = function (self)

    local prompt = loveframes.Create("frame")
    prompt:SetState("mapeditor")
    prompt:SetName("Save As")
    prompt:SetWidth(200)
    prompt:SetHeight(135)
    prompt:Center()
    prompt:SetDockable(true)
    prompt:SetModal(true)
    prompt:MakeTop()

    local label = loveframes.Create("text", prompt)
    label:SetText("Enter a filename")
    label:CenterX()
    label:SetY(40)

    local input = loveframes.Create("textinput", prompt)
    input:SetPlaceholder("Filename")
    input:SetUnusable({"/", "\0"})
    input:SetWidth(180)
    input:CenterX()
    input:SetY(70)
    input.OnEnter = function ()

        local name = input:GetText()
        self:SaveTo(name)
        prompt:Remove()

    end

    local save = loveframes.Create("button", prompt)
    save:SetText("Save")
    save:SetWidth(85)
    save:SetX(10)
    save:SetY(100)
    save.OnClick = input.OnEnter

    local cancel = loveframes.Create("button", prompt)
    cancel:SetText("Cancel")
    cancel:SetWidth(85)
    cancel:SetX(105)
    cancel:SetY(100)
    cancel.OnClick = function ()
        prompt:Remove()
    end

end
