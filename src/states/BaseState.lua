function createState()
    local state = {}
    state.init = function(self) end
    state.enter = function(self) end
    state.exit = function(self) end
    state.update = function(self,dt) end
    state.render = function(self) end

    return state
end