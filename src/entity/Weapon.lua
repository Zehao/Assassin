Weapon=class("Weapon",function(filepath) return cc.Sprite:create(filepath) end)

Weapon.__index = Weapon



function Weapon.create()
    local wp = Weapon.new(CONF.WEAPON_STATIC)
    wp:setScale(1.8)
    return wp
end

function Weapon:runActions(direction)
    self:setVisible(true)
    local animation = AnimationManager:getInstance():getOnceAnimation(ANIMATION_TYPE.WEAPON,direction)
    local pos = cc.p(self:getPosition())
    local tarPos=nil
    local dis = 70
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

    local move = cc.MoveBy:create(0.3,tarPos)
    local fadeout = cc.FadeOut:create(0.3)
    local fadein = cc.FadeIn:create(0.1)

    local fade = cc.Sequence:create(fadeout,fadein,cc.DelayTime:create(0.3),
        cc.CallFunc:create(
        function() 
            self:stopAllActions() 
            self:setPosition(pos)
            
            self:setVisible(false)
        end
        )
     )

    local actions =  cc.Spawn:create(cc.Animate:create(animation),move,fade)
    
    
    --self:runAction(cc.Animate:create(animation))
    self:runAction(actions)
end
 
