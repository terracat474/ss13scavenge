function love.load()
    cursor_idle = love.mouse.newCursor("cursor_idle.png", 16, 16 )
    love.mouse.setCursor(cursor_idle)
    items = {}
    createItem()
    setupVGUI()
    mouse = {
        x = 0,
        y = 0,
        width = 32,
        height = 32
    }
    ffont = love.graphics.newFont("fixedsys.ttf")
end

function setupVGUI()
    ---------------------------------------
    -------------              ------------
    -------------   rectangle  ------------
    -------------              ------------
    ---------------------------------------
    vgui = {}
    vgui.Rectangle = {}
    local rect = vgui.Rectangle
    rect.string = "rect"
    rect.Collisions = {
        x = 0,
        y = 0,
        width = 100,
        height = 50
    }
    rect.parent = nil
    local col = rect.Collisions
    rect.mode = "fill"
    rect.SetPos = function(x, y) --this one is written as rect.SetPos(x,y) when you use that
        col.x = x   --instead of rect:SetPos(x,y)
        col.y = y   --whatever.
    end
    rect.GetPos = function()
        return col.x, col.y
    end
    rect.SetSize = function(width, height)
        col.width = width
        col.height = height
    end
    rect.Draw = function()
        local prnt = rect.parent
        if prnt == nil then
            love.graphics.rectangle( rect.mode, col.x, col.y, col.width, col.height)
        else
            local pcol = pcol.Collisions
            love.graphics.rectangle( rect.mode, col.x + pcol.x, col.y+pcol.y, col.width, col.height)
        end
    end
    rect.SetParent = function(vguielement)
        rect.parent = vguielement
    end
    rect.GetCollisions = function()
        return col
    end
    ---------------------------------------
    -------------              ------------
    -------------     text     ------------
    -------------              ------------
    ---------------------------------------
    vgui.Text = {}
    local text = vgui.Text
    text.font = ffont
    text.parent = nil
    text.color = {255,255,255,255} --white by default
    text.str = ""
    text.x = 0
    text.y = 0
    text.SetText = function(string)
        text.str = string
    end
    text.SetPos = function(x, y)
        text.x = x
        text.y = y
    end
    text.GetPos = function()
        return text.x, text.y
    end
    text.SetParent = function(parent)
        text.parent = parent
    end
    text.SetFont = function(ff)
        text.font = ff
    end
    text.SetColor = function(tbl)
        text.color = tbl
    end
    text.Draw = function()
        local prant = text.parent
        if text.parent == nil then
            love.graphics.print({text.color, text.str}, text.font, text.x, text.y)
        else
            local pacol = prant.Collisions
            love.graphics.print({text.color, text.str}, text.font, (text.x + pacol.x), (text.y + pacol.y))
        end
    end
end

function vguiCreate(string, parent)
    if string == "rect" then
        local rect = vgui.Rectangle
        rect.SetParent(parent)
        return rect
    elseif string == "text" then
        local txt = vgui.Text
        txt.SetParent(parent)
        return txt
    end
end

function love.update()
    mouse.x = love.mouse.getX()
    mouse.y = love.mouse.getY()
    down = love.mouse.isDown(1)
    for k,v in ipairs(items) do
        if v.Grabbed then
            local col = v.Collisions
            col.x = mouse.x - (col.width/2)
            col.y = mouse.y - (col.height/2)
            v.ImageToDraw = v.ImageHovered
        end
    end
end

function drawItemInfo(item)
    local col = item.Collisions
    local bar = vguiCreate("rect")
    local rcol = bar.GetCollisions()
    bar.SetPos(col.x + (col.width/2) - (rcol.width/2), col.y + 20 - rcol.height)
    bar:Draw()
    --love.graphics.print({{255,0,0,255}, "Hello World!"}, ffont, col.x - (col.width/2), col.y - (col.height/2))
    local name = vguiCreate("text", bar)
    name:Draw()
    name.SetText(item.Name)
    name.SetPos(rcol.width/2, 5)
    name.SetColor({255,0,0,255})
end

function itemGrab(item, num)
    if num == 1 then
        item.Grabbed = true
        local col = item.Collisions
        col.x = mouse.x - (col.width/2)
        col.y = mouse.y - (col.height/2)
        playSound(item.PickupSound)
    else
        item.Grabbed = false
        playSound(item.DropSound)
    end
end

function playSound(sound)
    love.audio.play( sound )
end

function love.draw()
    for k, v in ipairs(items) do
        local col = v.Collisions
        love.graphics.draw(v.ImageToDraw, col.x, col.y, 0, 5, 5)
        if checkCollision(v.Collisions, mouse) and v.Grabbed then
            v.ImageToDraw = v.ImageHovered
        elseif checkCollision(v.Collisions, mouse) and v.Grabbed == false then
            drawItemInfo(v)
            v.ImageToDraw = v.ImageHovered
        else
            v.ImageToDraw = v.Image
        end
    end
end

function love.mousepressed(x,y,button)
    for k,v in ipairs(items) do
        if checkCollision(v.Collisions, mouse) and v.Grabbed == false then
            itemGrab(v, 1)
            v.ImageToDraw = v.ImageHovered
        end
    end 
end

function love.mousereleased(x,y,button)
    for k, v in ipairs(items) do
        if v.Grabbed then
            v.Grabbed = false
            playSound(v.DropSound)
            v.ImageToDraw = v.Image
        end
    end
end

function checkCollision(a, b)
    local a_left = a.x
    local a_right = a.x + a.width
    local a_top = a.y
    local a_bottom = a.y + a.height

    local b_left = b.x
    local b_right = b.x + b.width
    local b_top = b.y
    local b_bottom = b.y + b.height

    if  a_right > b_left
    and a_left < b_right
    and a_bottom > b_top
    and a_top < b_bottom then
        return true
    else
        return false
    end
end

function createItem()
    local item = {}
    item.Image = love.graphics.newImage("crowbar.png")
    item.ImageHovered = love.graphics.newImage("crowbar_outline.png")
    item.ImageToDraw = item.Image
    item.Name = "Crowbar"
    item.Desc = "A staple item."
    item.PosX = 100
    item.PosY = 100
    item.Collisions = {
        x = item.PosX,
        y = item.PosY,
        width = 32*5,
        height = 32*5
    }
    item.Grabbed = false
    item.IsColliding = false
    item.PickupSound = love.audio.newSource( "crowbar_pickup.ogg", "static" )
    item.DropSound = love.audio.newSource( "crowbar_drop.ogg", "static" )
    table.insert(items, item)
end

function generateStation()
    local type = {
        "safe",
        "mild",
        "dangerous"
    }
    rand = math.random(1, #type)
end
