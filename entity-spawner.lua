EntitySpawner = class("EntitySpawner", PointEntity)

function EntitySpawner:initialize(data)
    PointEntity.initialize(self, data)

    data = data or {}
    self.type = data.type or ""
    self.interval = data.interval or {1,12}
    self.amount = data.amount or {1,4}
end


function EntitySpawner:update(dt)
    PointEntity.update(self, dt)

    if self.hovering and interface.mousepressed["r"] then
        self:ContextMenu()
    end
end


function EntitySpawner:draw()
    PointEntity.draw(self)

    love.graphics.print(self.type, self.x - 10, self.y - 30)
end


function EntitySpawner:GetDataTable()
    if self.creating then return end

    return { "EntitySpawner", {
        x = self.x,
        y = self.y,
        type = self.type,
        data = {},
        interval = self.interval,
        amount = self.amount
    } }
end


function EntitySpawner:ContextMenu()
    local menu = PropertiesMenu:new(mousex, mousey, 125, 150)

    local typeinput = loveframes.Create("textinput", menu.panel)
    typeinput:SetPos(5, 5)
    typeinput:SetWidth(115)
    typeinput:SetPlaceholder("Entity type")
    typeinput:SetText(self.type)
    typeinput.OnEnter = function ()
        self.type = typeinput:GetText()
    end


    local intervalmin = loveframes.Create("numberbox", menu.panel)
    intervalmin:SetPos(5, 40)
    intervalmin:SetWidth(55)
    intervalmin:SetValue(self.interval[1])
    intervalmin.OnValueChanged = function ()
        self.interval[1] = intervalmin:GetValue()
    end

    local intervalmax = loveframes.Create("numberbox", menu.panel)
    intervalmax:SetPos(65, 40)
    intervalmax:SetWidth(55)
    intervalmax:SetValue(self.interval[2])
    intervalmax.OnValueChanged = function ()
        self.interval[2] = intervalmax:GetValue()
    end


    local amountmin = loveframes.Create("numberbox", menu.panel)
    amountmin:SetPos(5, 70)
    amountmin:SetWidth(55)
    amountmin:SetValue(self.amount[1])
    amountmin.OnValueChanged = function ()
        self.amount[1] = amountmin:GetValue()
    end

    local amountmax = loveframes.Create("numberbox", menu.panel)
    amountmax:SetPos(65, 70)
    amountmax:SetWidth(55)
    amountmax:SetValue(self.amount[2])
    amountmax.OnValueChanged = function ()
        self.amount[2] = amountmax:GetValue()
    end
end
