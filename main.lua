math.tau = math.pi * 2 -- harr harr

function love.load()

    if not love.filesystem.isDirectory("maps") then love.filesystem.createDirectory("maps") end

    class = require("middleclass")
    require("loveframes")
    require("json")
    require("polygon-shape")
    require("point-entity")
    require("static-debris")
    require("map-boundary")


    interface = {}
    
    require("mapeditor")

    interface.mousepressed = {}
    interface.mousereleased = {}

    --== Background stars ==--
        interface.background = {}
        interface.background.stars = {}
        for i = 1, 600 do
            table.insert(interface.background.stars, {
                x = love.math.random(0, love.graphics.getWidth()) -.5,
                y = love.math.random(0, love.graphics.getHeight()) -.5,
                color = {
                    love.math.random(200, 255),
                    love.math.random(200, 255),
                    love.math.random(200, 255),
                    love.math.random(1, 255)
                }
            })
        end
    --------------------------


    loveframes.SetState("mainmenu")


    --== Main menu ==--
        interface.mainmenu = {}

        interface.mainmenu.panel = loveframes.Create("panel")
        interface.mainmenu.panel:SetWidth(200)
        interface.mainmenu.panel:SetHeight(120)
        interface.mainmenu.panel:Center()
        interface.mainmenu.panel:SetState("mainmenu")

        interface.mainmenu.map = loveframes.Create("button", interface.mainmenu.panel)
        interface.mainmenu.map:SetPos(5, 5)
        interface.mainmenu.map:SetWidth(190)
        interface.mainmenu.map:SetText("Map Editor")
        interface.mainmenu.map.OnClick = function (self)
            loveframes.SetState("mapselect")
        end
    -------------------

    --== Map selection ==--
        interface.mapselect = {}

        interface.mapselect.panel = loveframes.Create("panel")
        interface.mapselect.panel:SetWidth(600)
        interface.mapselect.panel:SetHeight(400)
        interface.mapselect.panel:Center()
        interface.mapselect.panel:SetState("mapselect")

        interface.mapselect.list = loveframes.Create("columnlist", interface.mapselect.panel)
        interface.mapselect.list:SetPos(5, 5)
        interface.mapselect.list:SetSize(400, 390)
        interface.mapselect.list:AddColumn("Filename")
        interface.mapselect.list:AddColumn("Map name")
        interface.mapselect.list:AddColumn("Author")
        interface.mapselect.list.refresh = function (self)
            self:Clear()
            for k, v in ipairs(love.filesystem.getDirectoryItems("maps")) do
                local str = love.filesystem.read("maps/" .. v)
                local obj = json.decode(str)
                self:AddRow(v, obj.name, obj.author)
            end
        end
        interface.mapselect.list:refresh()

        interface.mapselect.create = loveframes.Create("button", interface.mapselect.panel)
        interface.mapselect.create:SetPos(410, 5)
        interface.mapselect.create:SetWidth(185)
        interface.mapselect.create:SetText("Create map")
        interface.mapselect.create.OnClick = function (self)
            local prompt = loveframes.Create("frame")
            prompt:SetState("mapselect")
            prompt:SetName("Create map")
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

                local data = {
                    name    = "Unnamed",
                    author  = "No-one",
                    mapdata = {}
                }
                love.filesystem.write("maps/" .. name, json.encode(data) .. "\n")
                prompt:Remove()
                interface.mapselect.list:refresh()
            end

            local create = loveframes.Create("button", prompt)
            create:SetText("Create")
            create:SetWidth(85)
            create:SetX(10)
            create:SetY(100)
            create.OnClick = input.OnEnter

            local cancel = loveframes.Create("button", prompt)
            cancel:SetText("Cancel")
            cancel:SetWidth(85)
            cancel:SetX(105)
            cancel:SetY(100)
            cancel.OnClick = function ()
                prompt:Remove()
            end
        end

        interface.mapselect.remove = loveframes.Create("button", interface.mapselect.panel)
        interface.mapselect.remove:SetPos(410, 340)
        interface.mapselect.remove:SetWidth(185)
        interface.mapselect.remove:SetText("Remove")
        interface.mapselect.remove.OnClick = function (self)
            if #interface.mapselect.list:GetSelectedRows() <= 0 then return end

            local mapname = interface.mapselect.list:GetSelectedRows()[1]:GetColumnData()[1]

            local prompt = loveframes.Create("frame")
            prompt:SetState("mapselect")
            prompt:SetName("Delete map")
            prompt:SetWidth(200)
            prompt:SetHeight(110)
            prompt:Center()
            prompt:SetDockable(true)
            prompt:SetModal(true)
            prompt:MakeTop()

            local label = loveframes.Create("text", prompt)
            label:SetText("Are you sure you want to delete " .. mapname .. "?")
            label:SetWidth(160)
            label:CenterX()
            label:SetY(35)

            local remove = loveframes.Create("button", prompt)
            remove:SetText("Remove")
            remove:SetWidth(85)
            remove:SetX(10)
            remove:SetY(75)
            remove.OnClick = function ()
                love.filesystem.remove("maps/" .. mapname)
                prompt:Remove()
                interface.mapselect.list:refresh()
            end

            local cancel = loveframes.Create("button", prompt)
            cancel:SetText("Cancel")
            cancel:SetWidth(85)
            cancel:SetX(105)
            cancel:SetY(75)
            cancel.OnClick = function ()
                prompt:Remove()
            end
        end

        interface.mapselect.edit = loveframes.Create("button", interface.mapselect.panel)
        interface.mapselect.edit:SetPos(410, 370)
        interface.mapselect.edit:SetWidth(185)
        interface.mapselect.edit:SetText("Edit")
        interface.mapselect.edit.OnClick = function (self)
            if #interface.mapselect.list:GetSelectedRows() <= 0 then return end

            local mapname = interface.mapselect.list:GetSelectedRows()[1]:GetColumnData()[1]

            loveframes.SetState("mapeditor")
            mapeditor:LoadMap(mapname)
        end
    -------------------

end

function love.update(dt)

    mousex, mousey = love.mouse.getPosition()
    loveframes.update(dt)

end

function love.draw()

    -- Stars
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    for k,v in pairs(interface.background.stars) do
        love.graphics.setColor(unpack(v.color))
        love.graphics.point(v.x, v.y)
    end


    for k,v in pairs(interface.mousepressed)  do interface.mousepressed[k]  = false end
    for k,v in pairs(interface.mousereleased) do interface.mousereleased[k] = false end

    loveframes.draw()

end

function love.keypressed(key, isrepeat)

    if key == "escape" then
        love.event.quit()
        return
    end

    loveframes.keypressed(key, isrepeat)

end

function love.keyreleased(key)

    loveframes.keyreleased(key)

end

function love.textinput(char)

    loveframes.textinput(char)

end

function love.mousepressed(x, y, but)

    interface.mousepressed[but] = true
    loveframes.mousepressed(x, y, but)

end
function love.mousereleased(x, y, but)

    interface.mousereleased[but] = true
    loveframes.mousereleased(x, y, but)

end
