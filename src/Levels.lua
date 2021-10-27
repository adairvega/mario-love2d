function createLevel()
    gameMap = sti('maps/level1.lua')

    local spawnPoint = gameMap.layers['SpawnPoint'].objects[1]

    player.body:setPosition(spawnPoint.x, spawnPoint.y)
 
    platforms = {}
 
    for i, obj in pairs(gameMap.layers['Plataformas'].objects) do
       
        local platform = createPlatform(obj.x, obj.y, obj.width, obj.height, 'Platform')
 
        table.insert(platforms, platform)
    end

    slopes = {}

    local pendiente = gameMap.layers['Pendientes'].objects[1]
    
    local points = {}

    for i, v in pairs(pendiente.polygon) do
        table.insert(points, v.x)
        table.insert(points, v.y)
    end

    slope = createSlope(points)
end

 
function levelRender()
    gameMap:drawLayer(gameMap.layers['Capa de patrones 1'])

    slope:draw()
end
 
function createPlatform(x, y, width, height, userData)
    local platform = {}
 
    platform.body = love.physics.newBody(world, x + width / 2,
    y + height / 2, 'static')
    platform.shape = love.physics.newRectangleShape(width, height)
    platform.fixture = love.physics.newFixture(platform.body, platform.shape)
    platform.fixture:setUserData(userData)
 
    platform.draw = function(self)
        love.graphics.setColor(1,1,1)
        love.graphics.polygon('line', self.body:getWorldPoints(self.shape:getPoints()))
    end
 
    return platform
end


function createSlope(points)
    local slope = {}

    slope.body = love.physics.newBody(world, 0, 0, 'static')
    slope.shape = love.physics.newPolygonShape(points)
    slope.fixture = love.physics.newFixture(slope.body, slope.shape)

    slope.draw = function(self)
        love.graphics.setColor(1,1,1)
        love.graphics.polygon('line', points)
    end

    return slope
end