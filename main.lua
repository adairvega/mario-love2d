WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

anim8 = require 'lib/anim8/anim8'
sti = require 'lib/Simple-Tiled-Implementation/sti'

require 'src/Player'
require 'src/Levels'

require 'src/StateMachine'
require 'src/states/BaseState'
require 'src/states/HomeScreen'
require 'src/states/PlayState'
require 'src/states/GameOver'

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    gStateMachine = createStateMachine()
    gStateMachine:init({
        ['HomeScreen'] = homeScreen(),
        ['Play'] = playState(),
        ['GameOver'] = gameOver()
    })

    gStateMachine:change('HomeScreen')

    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if (love.keyboard.keysPressed[key]) then
        return true
    else
        return false
    end
end

function love.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    gStateMachine:render()
end