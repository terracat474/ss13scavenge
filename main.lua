function love.load()
    scrH = love.graphics.getHeight()
    scrW = love.graphics.getWidth()
    require "character"
    require "world"
    setupChar()
    setupGrid(scrH, scrW)
    ffont = love.graphics.newFont("fixedsys.ttf")
    createRoom(300, 300, 5, 5, 1)
    createCorridor(500,500,10,3)
    --createCorridor(0, 0, scrW/32, scrH/32)
end

function love.update(dt)
    local oldX, oldY = char.x, char.y

    if love.keyboard.isDown("a", "left") then
        char.x = char.x - char.speed * dt
    end
    if love.keyboard.isDown("d", "right") then
        char.x = char.x + char.speed * dt
    end
    if love.keyboard.isDown("w", "up") then --all this code is for character movement. I don't think I should keep it here, but IDGAF.
        char.y = char.y - char.speed * dt
    end
    if love.keyboard.isDown("s", "down") then
        char.y = char.y + char.speed * dt
    end

    for i, v in ipairs(map) do
        local walls = v.objsWalls
        if walls[1] ~= nil then
            local obj = walls[1]
            if obj.Solid and checkCollision(char, v) then
                char.x, char.y = oldX, oldY
                break
            end
        end
    end
end

function love.draw()
    for k, v in ipairs(map) do
        local tiles = v.objsTiles --tiles go first, otherwise they would overlap with walls
        if tiles[1] ~= nil then
            local fixthistoo = tiles[1] --this feels hacky
            love.graphics.draw(fixthistoo.Image, v.x, v.y)
        end
        local walls = v.objsWalls
        if walls[1] ~= nil then
            local fixlater = walls[1] -- this too. Whatever.
            love.graphics.draw(fixlater.Image, v.x, v.y)
        end
    end
    local debug = love.graphics.newText(ffont, char.FindTile())
    love.graphics.draw(debug, 100, 100)
    char.Draw() --ALWAYS draw char last
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