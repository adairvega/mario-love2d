function createStateMachine()
    local stateMachine = {}

    stateMachine.init = function(self,states)
        self.current = {
            enter = function(self) end,
            exit = function(self) end,
            update = function(self) end,
            render = function(self) end
        }
        self.states = states or {}
    end

    stateMachine.change = function(self,stateName,enterParams)
        self.current:exit()
        self.current = self.states[stateName]
        self.current:enter(enterParams)
    end

    stateMachine.update = function(self, dt)
        self.current:update(dt)
    end

    stateMachine.render = function(self)
        self.current:render()
    end

    return stateMachine
end