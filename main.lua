math.tau = math.pi * 2 -- harr harr

function love.load()

    if not love.filesystem.isDirectory("maps") then love.filesystem.createDirectory("maps") end

    class = require("middleclass")
    require("loveframes")
    require("json")
    require("util")
    require("properties-menu")


    time = 0


    interface = {}
    
    require("mapeditor")

    interface.mousepressed = {}
    interface.mousereleased = {}

    --== Background stars ==--

        interface.background = {}

        for i = 1, 2000 do

            table.insert(interface.background,
            {
                x = math.random(0, 1000) / 1000,
                y = math.random(0, 1000) / 1000,
                r = math.random(220, 255),
                g = math.random(220, 255),
                b = math.random(220, 255),
                a = math.random(50, 100)
            })

        end

        for i = 1, 50 do

            table.insert(interface.background,
            {
                x = math.random(0, 1000) / 1000,
                y = math.random(0, 1000) / 1000,
                r = math.random(230, 255),
                g = math.random(230, 255),
                b = math.random(230, 255),
                a = math.random(150, 200)
            })

        end

    --------------------------


    loveframes.SetState("mainmenu")


    --== Main menu ==--

        interface.mainmenu = {}

        interface.mainmenu.panel = loveframes.Create("panel")
        interface.mainmenu.panel:SetWidth(600)
        interface.mainmenu.panel:SetHeight(400)
        interface.mainmenu.panel:Center()
        interface.mainmenu.panel:SetState("mainmenu")

        --== Maplist ==--

            interface.mainmenu.packs = loveframes.Create("columnlist", interface.mainmenu.panel)
            interface.mainmenu.packs:SetPos(5, 5)
            interface.mainmenu.packs:SetSize(400, 390)
            interface.mainmenu.packs:AddColumn("Name")
            interface.mainmenu.packs:AddColumn("Title")
            interface.mainmenu.packs:AddColumn("Author")
            interface.mainmenu.packs:AddColumn("Has logic")
            interface.mainmenu.packs.Refresh = function (self)
                self:Clear()
                for k, v in ipairs(love.filesystem.getDirectoryItems("maps")) do
                    if v:sub(-4, -1) == ".map" then

                        local name = v:sub(1, -5)

                        local str = love.filesystem.read("maps/" .. name .. ".map")
                        local obj = json.decode(str)
                        local logic = love.filesystem.exists("maps/" ..name  .. ".lua")

                        self:AddRow(name, obj.name, obj.author, logic and "Yes" or "")    

                    end
                end
            end
            interface.mainmenu.packs:Refresh()

        -----------------


        --== Create map ==--

            interface.mainmenu.create = loveframes.Create("button", interface.mainmenu.panel)
            interface.mainmenu.create:SetPos(410, 5)
            interface.mainmenu.create:SetWidth(185)
            interface.mainmenu.create:SetText("Create map")
            interface.mainmenu.create.OnClick = function (self)

                local prompt = loveframes.Create("frame")
                prompt:SetState("mainmenu")
                prompt:SetName("Create new content pack")
                prompt:SetWidth(200)
                prompt:SetHeight(135)
                prompt:Center()
                prompt:SetDockable(true)
                prompt:SetModal(true)
                prompt:MakeTop()

                local label = loveframes.Create("text", prompt)
                label:SetText("Enter a name")
                label:CenterX()
                label:SetY(40)

                local input = loveframes.Create("textinput", prompt)
                input:SetPlaceholderText("Map name")
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
                    love.filesystem.write("maps/" .. name .. ".map", json.encode(data) .. "\n")
                    prompt:Remove()
                    interface.mainmenu.packs:Refresh()

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

        --------------------


        --== Refresh maplist ==--

            interface.mainmenu.refresh = loveframes.Create("button", interface.mainmenu.panel)
            interface.mainmenu.refresh:SetPos(410, 270)
            interface.mainmenu.refresh:SetWidth(185)
            interface.mainmenu.refresh:SetText("Refresh list")
            interface.mainmenu.refresh.OnClick = function (self)

                interface.mainmenu.packs:Refresh()

            end

        --------------------

        --== Remove map ==--

            interface.mainmenu.remove = loveframes.Create("button", interface.mainmenu.panel)
            interface.mainmenu.remove:SetPos(410, 300)
            interface.mainmenu.remove:SetWidth(185)
            interface.mainmenu.remove:SetText("Remove")
            interface.mainmenu.remove.OnClick = function (self)

                if #interface.mainmenu.packs:GetSelectedRows() <= 0 then return end

                local mapname = interface.mainmenu.packs:GetSelectedRows()[1]:GetColumnData()[1]

                local prompt = loveframes.Create("frame")
                prompt:SetState("mainmenu")
                prompt:SetName("Delete map")
                prompt:SetWidth(200)
                prompt:SetHeight(110)
                prompt:Center()
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
                    interface.mainmenu.packs:Refresh()
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

        --------------------

        --== Edit map ==--

            interface.mainmenu.edit = loveframes.Create("button", interface.mainmenu.panel)
            interface.mainmenu.edit:SetPos(410, 330)
            interface.mainmenu.edit:SetWidth(185)
            interface.mainmenu.edit:SetText("Edit")
            interface.mainmenu.edit.OnClick = function (self)
                if #interface.mainmenu.packs:GetSelectedRows() <= 0 then return end

                local mapname = interface.mainmenu.packs:GetSelectedRows()[1]:GetColumnData()[1] .. ".map"

                loveframes.SetState("mapeditor")
                mapeditor:LoadMap(mapname)
            end

        ------------------


        --== Quit ==--

            interface.mainmenu.quit = loveframes.Create("button", interface.mainmenu.panel)
            interface.mainmenu.quit:SetPos(410, 370)
            interface.mainmenu.quit:SetWidth(185)
            interface.mainmenu.quit:SetText("Quit")
            interface.mainmenu.quit.OnClick = function (self)

                love.event.quit()

            end

        ------------------

    -------------------


    --== Map selection ==--

        interface.mapselect = {}

        interface.mapselect.panel = loveframes.Create("panel")
        interface.mapselect.panel:SetWidth(600)
        interface.mapselect.panel:SetHeight(400)
        interface.mapselect.panel:Center()
        interface.mapselect.panel:SetState("mapselect")

        --== Maplist ==--

            interface.mapselect.list = loveframes.Create("columnlist", interface.mapselect.panel)
            interface.mapselect.list:SetPos(5, 5)
            interface.mapselect.list:SetSize(400, 390)
            interface.mapselect.list:AddColumn("Map name")
            interface.mapselect.list:AddColumn("Title")
            interface.mapselect.list:AddColumn("Author")
            interface.mapselect.list:AddColumn("Has logic")
            interface.mapselect.list.Refresh = function (self)
                self:Clear()
                for k, v in ipairs(love.filesystem.getDirectoryItems("maps")) do
                    if v:sub(-4, -1) == ".map" then

                        local name = v:sub(1, -5)

                        local str = love.filesystem.read("maps/" .. name .. ".map")
                        local obj = json.decode(str)
                        local logic = love.filesystem.exists("maps/" ..name  .. ".lua")

                        self:AddRow(name, obj.name, obj.author, logic and "Yes" or "")    

                    end
                end
            end
            interface.mapselect.list:Refresh()

        -----------------


        --== Create map ==--

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
                label:SetText("Enter a name")
                label:CenterX()
                label:SetY(40)

                local input = loveframes.Create("textinput", prompt)
                input:SetPlaceholderText("Map name")
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
                    love.filesystem.write("maps/" .. name .. ".map", json.encode(data) .. "\n")
                    prompt:Remove()
                    interface.mapselect.list:Refresh()

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

        --------------------


        --== Refresh maplist ==--

            interface.mapselect.refresh = loveframes.Create("button", interface.mapselect.panel)
            interface.mapselect.refresh:SetPos(410, 270)
            interface.mapselect.refresh:SetWidth(185)
            interface.mapselect.refresh:SetText("Refresh list")
            interface.mapselect.refresh.OnClick = function (self)

                interface.mapselect.list:Refresh()

            end

        --------------------

        --== Remove map ==--

            interface.mapselect.remove = loveframes.Create("button", interface.mapselect.panel)
            interface.mapselect.remove:SetPos(410, 300)
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
                    interface.mapselect.list:Refresh()
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

        --------------------

        --== Edit map ==--

            interface.mapselect.edit = loveframes.Create("button", interface.mapselect.panel)
            interface.mapselect.edit:SetPos(410, 330)
            interface.mapselect.edit:SetWidth(185)
            interface.mapselect.edit:SetText("Edit")
            interface.mapselect.edit.OnClick = function (self)
                if #interface.mapselect.list:GetSelectedRows() <= 0 then return end

                local mapname = interface.mapselect.list:GetSelectedRows()[1]:GetColumnData()[1] .. ".map"

                loveframes.SetState("mapeditor")
                mapeditor:LoadMap(mapname)
            end

        ------------------


        --== Back ==--

            interface.mapselect.back = loveframes.Create("button", interface.mapselect.panel)
            interface.mapselect.back:SetPos(410, 370)
            interface.mapselect.back:SetWidth(185)
            interface.mapselect.back:SetText("Back")
            interface.mapselect.back.OnClick = function (self)

                loveframes.SetState("mainmenu")

            end

        ------------------

    -------------------

end

function love.update(dt)

    time = time + dt

    for k,v in pairs(interface.background) do

        v.x = (v.x - dt / 500) % 1

    end

    mousex, mousey = love.mouse.getPosition()
    loveframes.update(dt)

end

function love.draw()

    -- Stars
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    love.graphics.setPointSize(1)
    for k,v in pairs(interface.background) do

        love.graphics.setColor(v.r, v.g, v.b, v.a + math.sin(v.r + time * 4) * 30)
        love.graphics.point(math.floor(v.x * width), math.floor(v.y * height))

    end


    for k,v in pairs(interface.mousepressed)  do interface.mousepressed[k]  = false end
    for k,v in pairs(interface.mousereleased) do interface.mousereleased[k] = false end

    loveframes.draw()

    love.graphics.print(mapeditor.world.hoverobject and mapeditor.world.hoverobject.name or "", 10, love.graphics.getHeight() - 20)

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
