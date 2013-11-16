PropertiesMenu = class("PropertiesMenu")

local openmenu = nil

function PropertiesMenu:initialize(x, y, w, h)

    if openmenu then
        openmenu:close()
    end

    self.panel = loveframes.Create("panel")
    self.panel:SetState("mapeditor")
    self.panel:SetPos(x, y)
    self.panel:SetWidth(w)
    self.panel:SetHeight(h)
    self.panel.Update = function (dt)
        if interface.mousepressed["l"] then

            local item = loveframes.hoverobject
            local close_panel = true

            while item do
                if item == self.panel then
                    close_panel = false
                end
                item = item.parent
            end

            if close_panel then
                self:close()
            end

        end
    end

    self.closebutton = loveframes.Create("button", self.panel)
    self.closebutton:SetPos(5, h - 30)
    self.closebutton:SetWidth(w - 10)
    self.closebutton:SetText("Close")
    self.closebutton.OnClick = function ()
        self:close()
    end


    openmenu = self
end


function PropertiesMenu:close()
    self.panel:Remove()
    openmenu = nil
end
