math.tau = math.pi * 2 -- harr harr

function love.load()

    if not love.filesystem.isDirectory("maps") then love.filesystem.createDirectory("maps") end

    class = require("middleclass")
    require("loveframes")
    require("polygon-shape")
    require("static-debris")

    world = {}
    world.objects = {}

    world.zoom = 1
    world.zoomtarget = 1

    editor = {}
    editor.mousepressed = {}
    editor.mousereleased = {}

    interface = {}

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

        interface.mainmenu.level = loveframes.Create("button", interface.mainmenu.panel)
        interface.mainmenu.level:SetPos(5, 5)
        interface.mainmenu.level:SetWidth(190)
        interface.mainmenu.level:SetText("Level Editor")
        interface.mainmenu.level.OnClick = function (self)
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
        interface.mapselect.list:AddColumn("Author")
        interface.mapselect.list:AddColumn("Map name")

        for k, v in ipairs(love.filesystem.getDirectoryItems("maps")) do
            interface.mapselect.list:AddRow(v, "..", "....")
        end

        interface.mapselect.level = loveframes.Create("button", interface.mapselect.panel)
        interface.mapselect.level:SetPos(410, 5)
        interface.mapselect.level:SetWidth(185)
        interface.mapselect.level:SetText("Create map")
        interface.mapselect.level.OnClick = function (self)
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
            input:SetWidth(180)
            input:CenterX()
            input:SetY(70)

            local create = loveframes.Create("button", prompt)
            create:SetText("Create")
            create:SetWidth(85)
            create:SetX(10)
            create:SetY(100)
            create.OnClick = function ()

                prompt:Remove()
            end

            local cancel = loveframes.Create("button", prompt)
            cancel:SetText("Cancel")
            cancel:SetWidth(85)
            cancel:SetX(105)
            cancel:SetY(100)
            cancel.OnClick = function ()
                prompt:Remove()
            end
        end

        interface.mapselect.level = loveframes.Create("button", interface.mapselect.panel)
        interface.mapselect.level:SetPos(410, 370)
        interface.mapselect.level:SetWidth(185)
        interface.mapselect.level:SetText("Edit")
        interface.mapselect.level.OnClick = function (self)
            loveframes.SetState("leveleditor")
            table.insert(world.objects, StaticDebris:new())
        end
    -------------------
end

function love.update(dt)
    mousex, mousey = love.mouse.getPosition()


    -- World objects
    for k,v in pairs(world.objects) do
        if v.update then
            v:update()
        end
    end

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


    -- World objects
    for k,v in pairs(world.objects) do
        if v.draw then
            v:draw()
        end
    end


    for k,v in pairs(editor.mousepressed)  do editor.mousepressed[k]  = false end
    for k,v in pairs(editor.mousereleased) do editor.mousereleased[k] = false end

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
    editor.mousepressed[but] = true

    if but == "wu" then
        world.zoomtarget = world.zoomtarget * 1.05
    elseif but == "wd" then
        world.zoomtarget = world.zoomtarget * 0.95
    end

    loveframes.mousepressed(x, y, but)
end
function love.mousereleased(x, y, but)
    editor.mousereleased[but] = true

    loveframes.mousereleased(x, y, but)
end
