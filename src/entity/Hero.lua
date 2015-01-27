require("entity/Entity")
require("ParamConfig")


Hero = class("Hero",function(filepath)
    return Entity.new(filepath)
end)

Hero.__index = Hero


function Hero:ctor()
    self.hp = CONF.HERO_HP
    self.mp = CONF.HERO_MP
    self.damage = CONF.HERO_DAMAGE
    -- need to init
    self.weapon = nil
end

function Hero.create()
    return Hero.new(CONF.HERO_STATIC_TEXTURE)
end

function Hero:runWeaponAnimation()
    local animation = AnimationManager:getInstance():getAnimation(ANIMATION_TYPE.WEAPON,self.direction)
    self.weapon:runAction(cc.Animate:create(animation))
end