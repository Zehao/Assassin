State =
{
        StateRun = {
            onEnter = function()   end,
        },
    
        StateStand = {
            onEnter = function()   end,
        },
        StateAttack = {
            onEnter = function()   end,
        },
        StateDie = {
            onEnter = function()   end,
        },

}


FSM = class("FSM")

FSM.__index = FSM

function FSM.create(...)
	local fsm = FSM.new(...)
	return fsm
end

function FSM:ctor(...)
    self.state = State.StateStand
	self.entity = ...
end

function FSM:changeState(newState)
    
end