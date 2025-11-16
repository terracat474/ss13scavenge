function setupChar()
    char = {}
    char.Image = love.graphics.newImage("char.png")
    char.x = 0
    char.y = 0
    char.tile = 0
    char.width = 20
    char.height = 11
    char.speed = 100
    char.Draw = function()
        love.graphics.draw(char.Image, char.x, char.y)
    end
    char.FindTile = function()
        return findTile(char.x, char.y)
    end
end