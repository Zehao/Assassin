require("entity/Entity")
require("ParamConfig")
require("entity/Weapon")

Hero = class("Hero",function(filepath)
    return Entity.new(filepath)
end)

Hero.__index = Hero


function Hero:ctor()
    self.hp = CONF.HERO_HP
    self.mp = CONF.HERO_MP
    self.damage = CONF.HERO_DAMAGE
    -- need to init
    self.weapon = Weapon.create()
    
    --need to be done for weapon
    self.weapon:setPosition(cc.p(30,25))
    self:addChild(self.weapon )
end

function Hero.create()
    return Hero.new(CONF.HERO_STATIC_TEXTURE)
end

function Hero:runWeaponAnimation()
    local animation = AnimationManager:getInstance():getAnimation(ANIMATION_TYPE.WEAPON,self.direction)
    self.weapon:runAction(cc.Animate:create(animation))
end


--外部来保证两点之间可以直线到达
function Hero:move(moveinfo)
    self.moveInfo = moveinfo
    self:stopAllActions()
    local move = cc.MoveTo:create(moveinfo.duration,moveinfo.targetPosition)
    local run =  cc.Animate:create(AnimationManager:getInstance():getAnimation(ANIMATION_TYPE.HERO_RUN , self.direction))

    local stop = function()
        self:stopAllActions()
        self:runAnimation(ANIMATION_TYPE.HERO_STAND)
    end

    local actions = cc.Spawn:create(run, cc.Sequence:create(move,cc.CallFunc:create(stop)) )
    self:runAction(actions)
end