function playState()
    playState = createState()
 
    playState.enter = function(self)
        world = love.physics.newWorld(0, 700, false)
        world:setCallbacks(comienzaContacto, terminaContacto, preSolve)
 
        createPlayer()
       
        createLevel()
    end
 
    playState.update = function(self, dt)
        world:update(dt)
        gameMap:update(dt)
 
        playerUpdate(dt)
    end
 
    playState.render = function(self)
        local px, py = player.body:getPosition()
 
        -- Camara
        love.graphics.push()
        love.graphics.applyTransform(
            love.math.newTransform(0, 0, nil, 5, 5, px - 128, py - 72)
        )
 
        levelRender()
 
        playerRender(px, py)
 
        love.graphics.pop()
 
        -- Debug
        love.graphics.setColor(1,1,1)
        love.graphics.setNewFont(40)
        love.graphics.print(tostring(player.grounded), 50, 50)
    end
 
    return playState
end
 
-- Administración global de colisiones
function comienzaContacto(a, b, coll)
    local xn, yn = coll:getNormal()
    if a:getUserData() == 'Player' and b:getUserData() == 'Suelo' then
        console = xn
    end
end