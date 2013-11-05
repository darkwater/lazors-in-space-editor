math.tau = math.pi * 2 -- harr harr

function love.load()

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


    loveframes.SetState("mainmenu")


    --== Main Menu ==--
        interface.mainmenu = {}

        interface.mainmenu.background = loveframes.Create("panel")
        interface.mainmenu.background:SetState("mainmenu")
        interface.mainmenu.background.stars = {}
        for i = 1, 100 do
            table.insert(interface.mainmenu.background.stars, {
                x = love.math.random(0, love.graphics.getWidth()) -.5,
                y = love.math.random(0, love.graphics.getHeight() / 2) -.5,
                color = {
                    love.math.random(200, 255),
                    love.math.random(200, 255),
                    love.math.random(200, 255)
                }
            })
        end
        interface.mainmenu.background.Draw = function (self)
            local width = love.graphics.getWidth()
            local height = love.graphics.getHeight()

            for k,v in pairs(self.stars) do
                love.graphics.setColor(unpack(v.color))
                love.graphics.point(v.x, v.y)
            end

            love.graphics.setColor(58, 58, 58)
            love.graphics.polygon("fill",   0 , height / 2,
                                          100 , height / 2 - 100,
                                        width , height / 2 - 100,
                                        width , height ,
                                            0 , height )

            love.graphics.polygon("fill",  width - 100 , height / 2 - 100,
                                                 width , height / 2 - 200,
                                                 width , height / 2 - 100 )

            love.graphics.setColor(100, 100, 100)
            love.graphics.push()
            love.graphics.translate(-.5, -.5)
                love.graphics.line(     0 , height / 2,
                                      100 , height / 2 - 100,
                              width - 100 , height / 2 - 100,
                                    width , height / 2 - 200 )
            love.graphics.pop()
        end

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
            loveframes.SetState("leveleditor-one")
            table.insert(world.objects, StaticDebris:new())
        end
    -------------------
end

function love.update(dt)
    mousex, mousey = love.mouse.getPosition()


    for k,v in pairs(world.objects) do
        if v.update then
            v:update()
        end
    end

    loveframes.update(dt)
end

function love.draw()
    for k,v in pairs(world.objects) do
        if v.draw then
            v:draw()
        end
    end


    for k,v in pairs(editor.mousepressed)  do editor.mousepressed[k]  = false end
    for k,v in pairs(editor.mousereleased) do editor.mousereleased[k] = false end

    loveframes.draw()
end

function love.keypressed(key, unicode)
    if key == "escape" then
        love.event.quit()
        return
    end
    
    loveframes.keypressed(key, unicode)
end

function love.keyreleased(key)
    if key == "escape" then
        love.event.quit()
        return
    end

    loveframes.keyreleased(key)
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
