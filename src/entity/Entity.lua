require("types/Types")
require("ParamConfig")
require("managers/AnimationManager")
Entity = class("Entity",function(filepath)
    return cc.Sprite:create(filepath)
end)

Entity.__index = Entity


function Entity:ctor()
    self.direction = ENTITY_DIRECTION.RIGHT_DOWN
    self.isAlive = true
    self.isAttacking = false
    self.hp=0
    self.moveInfo = nil
    self.entitState = ENTITY_STATE.STATE_STAND
end


function Entity:attack(target)
    target.hp = target.hp - self.damage
end

function Entity:setDirection(direct)
    self.direction = direct
end

function Entity:stopAnimation()
    Entity:stopAllActions()
end

function Entity:runAnimation(animation_type)
    local animation = AnimationManager:getInstance():getAnimation(animation_type , self.direction)
    --print(animation , animation_type , self.direction)
    self:runAction(cc.Animate:create(animation))
end

function Entity:setHP(value)
    self.hp = value
end

function Entity:getHP()
	return self.hp
end
