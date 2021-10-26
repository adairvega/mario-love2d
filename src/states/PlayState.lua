function playState()
    state = createState()

    -- Load
    state.enter = function(self)
        -- Xgravity, Ygravity, Sleep
        world = love.physics.newWorld(0, 700, true)
        world:setCallbacks(comienzaContacto, terminaContacto, preSolve)

        gameMap = sti('maps/level1.lua')

        -- Scale
        --love.physics.setMeter(scale)
        suelo = {}

        local plataforma = gameMap.layers['Plataformas'].objects[1]


        suelo.body = love.physics.newBody(world,plataforma.x + plataforma.width / 2, plataforma.y + plataforma.height /2, 'static')
        suelo.shape = love.physics.newRectangleShape(plataforma.width, plataforma.height)
        suelo.fixture = love.physics.newFixture(suelo.body, suelo.shape)
        suelo.fixture:setUserData('Suelo')

        -- objeto a
        player = {}

        player.spritesheet = love.graphics.newImage('gfx/sprites/mario_regular.png')
        player.spritesheet:setFilter('nearest', 'nearest')
        local grid = anim8.newGrid(39, 38, player.spritesheet:getWidth(), player.spritesheet:getHeight())

        player.animations = {
            ['run'] = anim8.newAnimation(grid('2-1', 1), 0.1),
            ['idle'] = anim8.newAnimation(grid('1-1', 1), 1),
            ['jump'] = anim8.newAnimation(grid(1, 2), 1),
        }

        player.facing = 1
        player.isMoving = false
        player.grounded = false

         -- Colisionador jugador
        -- este objeto se creó primero, entonces es el "objeto a"
        player.body = love.physics.newBody(world, 10, 0, 'dynamic')
        player.shape = love.physics.newRectangleShape(14, 20)
        player.fixture = love.physics.newFixture(player.body, player.shape)
        player.fixture:setUserData('Player')
        player.body:setFixedRotation(true)
        player.body:setMass(3)
        player.fixture:setFriction(2)

        -- objeto b
        cajita = {}
        cajita.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2,'dynamic')
        cajita.shape = love.physics.newRectangleShape(70, 70)
        cajita.fixture = love.physics.newFixture(cajita.body, cajita.shape)
        cajita.fixture:setUserData('Suelo')
    end

    -- Update
    state.update = function(self, dt)
        world:update(dt)
        gameMap:update(dt)

        local px, py = player.body:getPosition()

        player.grounded = false
        world:rayCast(px, py, px, py + 20, checkPlayerGrounded)

        player.isMoving = false

        if love.keyboard.wasPressed('z') and player.grounded then
            player.body:applyLinearImpulse(0, -1000)
        end

        local dx, dy = player.body:getLinearVelocity()
        
        if love.keyboard.isDown('d') then
            player.isMoving = true
            player.facing = 1
            player.body:setLinearVelocity(150, dy)
        end
        
        if love.keyboard.isDown('q') then
            player.isMoving = true
            player.facing = -1
            player.body:setLinearVelocity(-150, dy)
        end
        
        if love.keyboard.wasPressed('escape') then
            love.event.quit()
        end

        player.animations['run']:update(dt)
    end

    -- Draw
    state.render = function(self)
        local px, py = player.body:getPosition()

        -- Camara
        love.graphics.push()
        love.graphics.applyTransform(
            love.math.newTransform(0, 0, nil, 5, 5, px - 128, py - 72)
        )

        gameMap:drawLayer(gameMap.layers['Capa de patrones 1'])

        -- love.graphics.setColor(0.5, 0.5, 0.5)
        -- love.graphics.polygon('fill', suelo.body:getWorldPoints(suelo.shape:getPoints()))
 
        love.graphics.setColor(0.5, 1, 0.5)
        love.graphics.polygon('line', player.body:getWorldPoints(player.shape:getPoints()))
 
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.polygon('fill', cajita.body:getWorldPoints(cajita.shape:getPoints()))


        love.graphics.setColor(1,1,1)
        love.graphics.line(px, py, px, py + 20)

        -- Render de animaciones
        if player.grounded then
            if player.isMoving then
                player.animations['run']:draw(player.spritesheet, px, py, nil, player.facing, 1, 16, 9)
            else
                player.animations['idle']:draw(player.spritesheet, px, py, nil, player.facing, 1, 16, 9)
            end
        else
            player.animations['jump']:draw(player.spritesheet, px, py, nil, player.facing, 1, 16, 9)
        end

        love.graphics.pop()

        -- Debug
        love.graphics.setColor(1,1,1)
        love.graphics.setNewFont(40)
        love.graphics.print(tostring(player.grounded), 50, 50)

    end

    return state
end

-- Administración global de colisiones
function comienzaContacto(a, b, coll)
    local xn, yn = coll:getNormal()
    if a:getUserData() == 'Player' and b:getUserData() == 'Suelo' then
        console = xn
    end
end


function checkPlayerGrounded(fixture, x, y, xn, yn, fraction)
    local fixture = fixture

    if fixture:getUserData() == 'Suelo' then
        player.grounded = true
    else
        player.grounded = false
    end

    return 1
end