function homeScreen()
    state = createState()

    -- Load
    state.enter = function(self)
        self.title = {
            x = 0,
            y = love.graphics.getHeight() / 2,
            limit = love.graphics.getWidth()
            
        }
    end

    -- Update
    state.update = function(self,dt)
        if (love.keyboard.wasPressed('return')) then
            gStateMachine:change('Play')
        end
    end

    -- Draw
    state.render = function(self)
        love.graphics.clear(0.5,0.7,0.6)
        love.graphics.printf("Pantalla de título", self.title.x, self.title.y, self.title.limit, "center")
    end

    return state
end