local pMaxSpeed = 150
 
function createPlayer()
   
    player = {}
 
    player.spritesheet = love.graphics.newImage('gfx/sprites/mario_regular.png')
    player.spritesheet:setFilter('nearest', 'nearest')
    local grid = anim8.newGrid(39, 38,player.spritesheet:getWidth(),
    player.spritesheet:getHeight())
 
    player.animations = {
        ['run'] = anim8.newAnimation(grid('2-1', 1), 0.1),
        ['idle'] = anim8.newAnimation(grid(1, 1), 1),
        ['jump'] = anim8.newAnimation(grid(1, 2), 1)
    }
 
    player.speed = 0
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
end
 
function playerUpdate(dt)
    local px, py = player.body:getPosition()
 
    player.grounded = false
    world:rayCast(px, py, px, py + 20, checkPlayerGrounded)
 
    player.isMoving = false
 
    if love.keyboard.wasPressed('w') and player.grounded then
        player.body:applyLinearImpulse(0, -1000)
    end
 
    -- local dx, dy = player.body:getLinearVelocity()
 
    if love.keyboard.isDown('d') then
        player.speed = math.min(player.speed + dt * 300, pMaxSpeed)
        player.isMoving = true
        player.facing = 1
    elseif love.keyboard.isDown('a') then
        player.speed = math.max(player.speed - dt * 300, -pMaxSpeed)
        player.isMoving = true
        player.facing = -1
    end
 
    if player.isMoving == false then
        player.speed = player.speed * 0.85
        if player.speed < 2 and player.speed > -2 then
            player.speed = 0
        end
    end
 
    if px < 0 then
        player.speed = 0
        player.body:setX(1)
    end
 
    if px > 0 then
        player.body:setX(px + player.speed * dt)
    end
 
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
 
    player.animations['run']:update(dt)
end
 
function playerRender(px, py)
    -- Render de animaciones
    love.graphics.setColor(1,1,1)
    if player.grounded then
        if player.isMoving then
            player.animations['run']:draw(player.spritesheet, px, py, nil, player.facing, 1, 16, 9)
        else
            player.animations['idle']:draw(player.spritesheet, px, py, nil, player.facing, 1, 16, 9)
        end
    else
        player.animations['jump']:draw(player.spritesheet, px, py, nil, player.facing, 1, 16, 9)
    end
 
    love.graphics.setColor(0.5, 1, 0.5)
    love.graphics.polygon('line', player.body:getWorldPoints(player.shape:getPoints()))
 
    love.graphics.setColor(1,1,1)
    love.graphics.line(px, py, px, py + 20)
end
 
function checkPlayerGrounded(fixture, x, y, xn, yn, fraction)
    local fixture = fixture
 
    if fixture:getUserData() == 'Platform' then
        player.grounded = true
    else
        player.grounded = false
    end
 
    return 1
end