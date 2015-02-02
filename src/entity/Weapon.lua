Weapon=class("Weapon",function(filepath) return cc.Sprite:create(filepath) end)

Weapon.__index = Weapon



function Weapon.create()
    local wp = Weapon.new(CONF.WEAPON_STATIC)
    return wp
end

function Weapon:runActions(direction)
    local animation = AnimationManager:getInstance():getForeverAnimation(ANIMATION_TYPE.WEAPON,direction)
    local pos = cc.p(self:getPosition())
    local tarPos=nil
    local dis = 25
    if direction == ENTITY_DIRECTION.LEFT_DOWN then
        tarPos = cc.p(-dis,-dis)
    elseif direction == ENTITY_DIRECTION.LEFT then
        tarPos = cc.p(-dis,0)
    elseif direction == ENTITY_DIRECTION.DOWN then
        tarPos = cc.p(0,-dis)
    elseif direction == ENTITY_DIRECTION.RIGHT_DOWN then
        tarPos = cc.p(dis,-dis)
    elseif direction == ENTITY_DIRECTION.RIGHT then
        tarPos = cc.p(dis,0)
    elseif direction == ENTITY_DIRECTION.RIGHT_UP then
        tarPos = cc.p(dis,dis)
    elseif direction == ENTITY_DIRECTION.UP then
        tarPos = cc.p(0,dis)
    elseif direction == ENTITY_DIRECTION.LEFT_UP then
        tarPos = cc.p(-dis,dis)
    else
        print("error" , direction)
    end

    local move = cc.MoveBy:create(1.0,tarPos)
    local fadeout = cc.FadeOut:create(0.8)
    local fadein = cc.FadeIn:create(0.2)

    local fade = cc.Sequence:create(fadeout,fadein,
        cc.CallFunc:create(
        function() 
            self:stopAllActions() 
            --self:setVisible(true)
            self:setPosition(pos)
        end
        )
     )

    local actions =  cc.Spawn:create(move,fade)

    self:runAction(actions)
end
 
