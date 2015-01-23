require("types/Types")
require("ParamConfig")

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

