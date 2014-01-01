Trigger = class("Trigger", PolygonShape)

function Trigger:initialize(data, id)
    PolygonShape.initialize(self, data)
    self.name = "Trigger"
    self.canconvex = false

    data = data or {}
    self.id = data.id or ""
    self.solid = true

    self.objectid = id
end


function Trigger:update(dt)
    PolygonShape.update(self, dt)
end


function Trigger:draw()
    PolygonShape.draw(self)
end


function Trigger:GetDataTable()
    if self.creating then return end

    local p = {}

    for k,v in pairs(self.points) do
        table.insert(p, v.x)
        table.insert(p, v.y)
    end

    return { "Trigger", {
        points = p,
        solid = self.solid,
        id = self.id
    } }
end


function Trigger:ContextMenu()
    local menu = PropertiesMenu:new(mousex, mousey, 125, 150)

    local idinput = loveframes.Create("textinput", menu.panel)
    idinput:SetPos(5, 5)
    idinput:SetWidth(115)
    idinput:SetPlaceholder("Identifier")
    idinput:SetText(self.id)
    idinput.OnEnter = function ()
        self.id = idinput:GetText()
    end


    local solidcheck = loveframes.Create("checkbox", menu.panel)
    solidcheck:SetX(5)
    solidcheck:SetY(35)
    solidcheck:SetChecked(self.solid)
    solidcheck.OnChanged = function ()
        self.solid = solidcheck:GetChecked()
    end

    local solidlabel = loveframes.Create("text", menu.panel) -- TODO: Checkbox:SetText() doesn't work??
    solidlabel:SetX(35)
    solidlabel:SetY(36)
    solidlabel:SetText("Solid trigger")
end


function Trigger:remove()
    mapeditor.world.objects[self.objectid] = nil
    self = nil
end
