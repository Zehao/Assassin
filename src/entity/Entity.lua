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
    print(animation , animation_type , self.direction)
    self:runAction(cc.Animate:create(animation))
end