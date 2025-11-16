function setupGrid(scrH, scrW)
    map = {}
    local xtiles = scrW/32
    local ytiles = scrH/32
    for i = 1, xtiles do
        for p = 1, ytiles do -- do not touch this. I don't understand what it does, yet it does.
            local thing = {
                x = i*32,
                y = p*32,
                width = 32, --for collisions
                height = 32,
                objsWalls = {},
                objsTiles = {}, -- FLOOR TILES THEY ARE FLOOR TILES
            }
            table.insert(map, thing)
        end
    end
end

function findTile(x,y) --use x and y to find where to put shit, it will automatically be put on the tile
    local newx = math.floor(x/32)
    local newy = math.floor(y/32)
    for k,v in ipairs(map) do
        if v.x == newx*32 and v.y == newy*32 then
            return k
        end
    end
end

function createObject(x, y)
    local obj = {}
    obj.Tile = findTile(x,y)
    obj.width = 32
    obj.height = 32
    obj.Solid = true --impassable
    obj.Image = love.graphics.newImage("wall32.png")
    local tile = map[obj.Tile]
    table.insert(tile.objsWalls, obj)
end

function createTile(x,y)
    local obj = {}
    obj.Tile = findTile(x,y)
    obj.width = 32
    obj.height = 32
    obj.Solid = false --passable, idk if i should keep it bcuz it's in a different Tile table
    obj.Image = love.graphics.newImage("floortile.png")
    local tile = map[obj.Tile]
    table.insert(tile.objsTiles, obj)
end

function createRoom(x, y, width, height, entrnum) --width and height self-explanatory, entr(ance) num(bers) is amount of entrances
    local entrancesCreated = false  -- x and y is for where the top right wall block will be
    local entrancesAm = 0
    for i = 1, width do
        local c = i - 1
        if entrancesCreated == false then
            local rd = love.math.random(1, 100)
            if rd > 70 and i ~= 1 or rd > 70 and i ~= width then
                entrancesAm = entrancesAm + 1
                if entrancesAm == entrnum then
                    entrancesCreated = true
                end
            else
                createObject(x-(c*32), y)
            end
        else
            createObject(x-(c*32), y)
        end
    end
    for i = 1, height do
        local c = i - 1
        if entrancesCreated == false then
            local rd = love.math.random(1, 100)
            if rd > 70 and i ~= 1 or rd > 70 and i ~= width then --feels like there could be a better way to make this than nesting loops.
                entrancesAm = entrancesAm + 1
                if entrancesAm == entrnum then
                    entrancesCreated = true
                end
            else
                createObject(x, y-(c*32))
            end
        else
            createObject(x, y-(c*32))
        end
    end
    for i = 2, height do
        local c = i - 1
        if entrancesCreated == false then
            local rd = love.math.random(1, 100)
            if rd > 70 and i ~= height or rd > 70 and i ~= width then
                entrancesAm = entrancesAm + 1
                if entrancesAm == entrnum then
                    entrancesCreated = true
                end
            else
                createObject(x - (width*32), y-(c*32))
            end
        else
            createObject(x - ((width - 1)*32), y-(c*32))
        end
    end
    for i = 2, width - 1 do
        local c = i - 1
        createObject(x-(c*32), y - ((height - 1)*32))
    end
end

function createCorridor(x,y,width,height) -- corridors are drawn by top left corner
    for i = 1, height do
        for p = 1, width do
            createTile(x+(p*32), y+((i-1)*32))
        end
    end
end

function generateMap() --15:01 16.11, this will be a long one
    local corridors = 0
end