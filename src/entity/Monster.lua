
require("entity.Entity")
require("ParamConfig")

Monster = class("Monster", function(filepath) return Entity.new(filepath) end )

Monster.__index = Monster

local currentMonster = {}


local function followAttack(dt)
    print("followAttack")
    local self = currentMonster
    if self.target == nil or self.isAttacked == false then return end
    print("followAttack"   )
    --若超过距离则返回到原位置
    if cc.pLengthSQ(cc.pSub(self.originalPos,cc.p(self:getPosition()))) > 90000 then
        print("return to original")
        local action = cc.MoveTo:create(2,self.originalPos)
        self:runAction(action)
        self:statEnterStand()
    else
        print("follow attack")
        if self.targetLastPos.x == self.target:getPosition() then return end
        print("real follow")
        local pos = self.targetLastPos
        local action = cc.MoveTo:create(0.6,pos)
        self:runAction(action)
        self.targetLastPos = cc.p(self.target:getPosition())
    end
end



function Monster:ctor()
    self.hp = CONF.MONSTER1_HP
    self.damage = CONF.MONSTER1_DAMAGE
    self.originalPos = nil
    self.scheduler = cc.Director:getInstance():getScheduler()
    self.isAttacked = false
    self.target = nil
    self:statEnterStand()
end


function Monster.create()
    return  Monster.new(CONF.MONSTER1_STATIC_TEXTURE)
end

function Monster:setTarget(hero)
    currentMonster= self
    self.target = hero 
    self.isAttacked = true
    self.targetLastPos = cc.p(hero:getPosition())
end

--站立或巡逻
function Monster:statEnterStand()
    if self.entityState == ENTITY_STATE.STATE_STAND then
        return true
    end
    
    self.entityState = ENTITY_STATE.STATE_STAND
    self.target = nil
    self.isAttacked = false
    if self.scheduleFollowAttack then self.scheduler:unscheduleScriptEntry(self.scheduleFollowAttack) end
    if self.scheduleAttackHero then self.scheduler:unscheduleScriptEntry(self.scheduleAttackHero) end
    --开始巡逻
    local function walk()
        self:walkAround()
    end

    self.scheduleWalk = self.scheduler:scheduleScriptFunc(walk,math.random(6,8),false)


end

function Monster:stateEnterFight()
    if self.entityState == ENTITY_STATE.STATE_FIGHT then
        return true
    end
    self.entityState = ENTITY_STATE.STATE_FIGHT
    
    self:stopAllActions()
    self.scheduler:unscheduleScriptEntry(self.scheduleWalk)
    self.scheduleFollowAttack = self.scheduler:scheduleScriptFunc(followAttack,0.5,false)
    
    local direction,moveinfo = self:getFocus()
    
    local deltaPoint = cc.pSub(cc.p(self.target:getPosition()),cc.p(self:getPosition()) )
    local moveinfo = cc.p(deltaPoint.x*0.5,deltaPoint.y*0.5)
    
    local animation = self:getAnimation(ANIMATION_TYPE.MONSTER,direction,-1)
    
    
    
    local moveAction 
--    if cc.rectIntersectsRect(self:getBoundingBox(),self.target:getBoundingBox()) == false then
--        
--    end
    moveAction = cc.MoveBy:create(0.1,moveinfo)
    self:runAction(moveAction)
    self:runAction(cc.Animate:create(animation))
    
    local function attackHero()
        self:attack(self.target)
        print("moveinfo:" , moveinfo.x,moveinfo.y)
        local move = cc.p(moveinfo.x*0.2,moveinfo.y*0.2)
        local attackAction = cc.MoveBy:create(0.05,move)
        self:runAction(cc.Sequence:create(attackAction,attackAction:reverse()))
    end
    
    self.scheduleAttackHero = self.scheduler:scheduleScriptFunc(attackHero,1.6,false)
end
 

function Monster:getFocus()
    local targetDirection = self.target:getDirection()
    local dis = CONF.HERO_ATTACK_DISTANCE-self:getContentSize().height
    print("dis:".. dis)
    if targetDirection == ENTITY_DIRECTION.DOWN  or targetDirection == ENTITY_DIRECTION.RIGHT_DOWN then
        return ENTITY_DIRECTION.LEFT_UP,cc.p(-dis,dis)
    elseif targetDirection == ENTITY_DIRECTION.UP or targetDirection == ENTITY_DIRECTION.LEFT_UP then
        return ENTITY_DIRECTION.RIGHT_DOWN,cc.p(dis,-dis)
    elseif targetDirection == ENTITY_DIRECTION.LEFT or targetDirection == ENTITY_DIRECTION.LEFT_DOWN then
        return ENTITY_DIRECTION.RIGHT_UP,cc.p(dis,dis)
    elseif targetDirection == ENTITY_DIRECTION.RIGHT or targetDirection == ENTITY_DIRECTION.RIGHT_UP then
        return ENTITY_DIRECTION.LEFT_DOWN,cc.p(-dis,-dis)
    end
    
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

