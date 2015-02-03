
require("entity.Entity")
require("ParamConfig")

Monster = class("Monster", function(filepath) return Entity.new(filepath) end )

Monster.__index = Monster


function Monster:ctor()
    self.hp = CONF.MONSTER1_HP
    self.damage = CONF.MONSTER1_DAMAGE
    self.originalPos = nil
    self.scheduler = cc.Director:getInstance():getScheduler()
    
    local function walk()
        self:walkAround()
    end
    
    self.scheduler:scheduleScriptFunc(walk,math.random(6,8),false)
end


function Monster.create()
    return  Monster.new(CONF.MONSTER1_STATIC_TEXTURE)
end

function Monster:setTarget(hero)
    self.target = hero 
end



function Monster:walkAround()

    --先保存原始位置
    self.originalPos = cc.p(self:getPosition())
	local animationForward = self:getAnimation(ANIMATION_TYPE.MONSTER,self.direction,6)
	local direction = self.direction
    local reverseDirection = nil
    local tarPos=nil
    local dis = 150
    if direction == ENTITY_DIRECTION.LEFT_DOWN then
        tarPos = cc.p(-dis,-dis)
        reverseDirection = ENTITY_DIRECTION.RIGHT_UP
    elseif direction == ENTITY_DIRECTION.RIGHT_DOWN then
        tarPos = cc.p(dis,-dis)
        reverseDirection = ENTITY_DIRECTION.LEFT_UP
    elseif direction == ENTITY_DIRECTION.RIGHT_UP then
        tarPos = cc.p(dis,dis)
        reverseDirection = ENTITY_DIRECTION.LEFT_DOWN
    elseif direction == ENTITY_DIRECTION.LEFT_UP then
        tarPos = cc.p(-dis,dis)
        reverseDirection = ENTITY_DIRECTION.RIGHT_DOWN
    else
        print("error" , direction)
    end
    
    
    
    local animationReverse = self:getAnimation(ANIMATION_TYPE.MONSTER,reverseDirection,20)
    
    local move1 = cc.MoveBy:create(2.5,tarPos)
    move1:setTag(ACTION_TAG.MOVE)
    local animate1 = cc.Animate:create(animationForward)
    animate1:setTag(ACTION_TAG.CHANGING)
    
    local move2 = move1:reverse()
    move2:setTag(ACTION_TAG.MOVE)
    local animate2 = cc.Animate:create(animationReverse)
    animate2:setTag(ACTION_TAG.CHANGING)
    
    
    
    
    
    
    
    local actions = cc.Sequence:create(
        cc.Spawn:create(move1,animate1),
        --cc.DelayTime:create(0.01),
        cc.Spawn:create(move2,animate2)
    )
    self:runAction(actions)

end



function Monster:distance2hero(hero)
    return cc.pGetDistance(cc.p(self:getPosition()),cc.p(hero:getPosition()))
    
end

