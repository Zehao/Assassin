
require("entity.Entity")
require("ParamConfig")

Monster = class("Monster", function(filepath) return Entity.new(filepath) end )

Monster.__index = Monster



function Monster:ctor()
    self.hp = CONF.MONSTER1_HP
    self.fullHp = self.hp
    self.damage = CONF.MONSTER1_DAMAGE
    self.originalPos = nil
    self.originalDirection = nil
    self.scheduler = cc.Director:getInstance():getScheduler()
    self.isAttacked = false
    self.monsterHPBar=nil
    self.target = nil
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


--站立
function Monster:stateEnterStand()
    if self.entityState == ENTITY_STATE.STATE_STAND then
        return true
    end
    self:stopAllActions()
    self.entityState = ENTITY_STATE.STATE_STAND
    
    local animation = self:getAnimation(ANIMATION_TYPE.MONSTER,self.direction,-1)
    local animate = cc.Animate:create(animation)
    animate:setTag(ACTION_TAG.CHANGING)
    self:runAction(animate)
end

--行走巡逻
function Monster:stateEnterWalkAround()
    if self.entityState == ENTITY_STATE.STATE_RUN then
        self:stateEnterStand()
    end
    
    self.entityState = ENTITY_STATE.STATE_RUN
    self.target = nil
    self.isAttacked = false

    if  self.scheduleWalk then self.scheduler: unscheduleScriptEntry(self.scheduleWalk) end
    self:walkAround()
    local function walk()
        print("walk")
        self:stateEnterWalkAround()
    end
    self.scheduleWalk = self.scheduler:scheduleScriptFunc(walk,math.random(11,13),false)
end



--进入打斗
--[[
修改状态，停止前面所有动画，停止走动定时器，移动到英雄旁边，
启动followattack定时器和attack定时器

]]
function Monster:stateEnterFight()
    if self.entityState == ENTITY_STATE.STATE_FIGHT then
        return true
    end
    self.entityState = ENTITY_STATE.STATE_FIGHT
    
    self:stopAllActions()
    self.scheduler:unscheduleScriptEntry(self.scheduleWalk)
    self.scheduleFollowAttack = self.scheduler:scheduleScriptFunc(Monster.followAttack,0.4,false)
    
    local direction,moveinfo = self:getFocus()
    self.direction = direction
    
    local deltaPoint = cc.pSub(cc.p(self.target:getPosition()),cc.p(self:getPosition()) )
    local moveinfo = cc.p(deltaPoint.x*0.4,deltaPoint.y*0.4)
    
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
        local move = cc.p(moveinfo.x*0.2,moveinfo.y*0.2)
        local attackAction = cc.MoveBy:create(0.05,move)
        self:runAction(cc.Sequence:create(attackAction,attackAction:reverse()))
    end
    
    self.scheduleAttackHero = self.scheduler:scheduleScriptFunc(attackHero,1.6,false)
end
 
 
 function Monster:stateEnterDie()
 
    self:stopAllActions()
    
    
    if  self.scheduleWalk then self.scheduler: unscheduleScriptEntry(self.scheduleWalk) end
    if self.scheduleFollowAttack then self.scheduler:unscheduleScriptEntry(self.scheduleFollowAttack) end
    if self.scheduleAttackHero then self.scheduler:unscheduleScriptEntry(self.scheduleAttackHero) end
    
    
    local seq = cc.Sequence:create(cc.Blink:create(0.8,4),cc.CallFunc:create( function() self:getParent():removeEntity(self) end ))
    self:runAction(seq)
    
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



function Monster:distance2hero(hero)
    return cc.pGetDistance(cc.p(self:getPosition()),cc.p(hero:getPosition()))

end

--行走
function Monster:walkAround()
    --先保存原始位置
    local tarPos=nil
    local dis = 150
    
    local direction = self.direction
    local reverseDirection = nil
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
    --反向
    local animationReverse = self:getAnimation(ANIMATION_TYPE.MONSTER,reverseDirection,-1)
    
    --向前
--    local animationForward = self:getAnimation(ANIMATION_TYPE.MONSTER,self.direction,-1)
--    local animate = cc.Animate:create(animationForward)
--    animate:setTag(ACTION_TAG.CHANGING)
--    self:runAction(animate)

    local move1 = cc.MoveBy:create(math.random()+2,tarPos)  --2sec to 3sec
    move1:setTag(ACTION_TAG.MOVE)
    
    local move2 = move1:reverse()
    move2:setTag(ACTION_TAG.MOVE)
    
    local animate2 = cc.Animate:create(animationReverse)
    animate2:setTag(ACTION_TAG.CHANGING)
    
    
    local function callbackfunc(node,tab)
        --node:stopAllActions()
        --node:runAction(animate2)
        node:stopActionByTag(ACTION_TAG.CHANGING)
    end

    --self:runAction(actionStart)

    self:runAction(cc.Sequence:create(
        cc.DelayTime:create(2),
        move1,
        cc.DelayTime:create(2),
        cc.CallFunc:create(callbackfunc),
        --cc.DelayTime:create(0.1),
        cc.Spawn:create(animate2,move2)
     ));

end

--跟踪攻击
function Monster.followAttack(dt)
    local self = currentMonster
    if self.target == nil or self.isAttacked == false then return end
    --若超过距离则返回到原位置
    if cc.pLengthSQ(cc.pSub(self.originalPos,cc.p(self:getPosition()))) > 90000 then
        print("return to original")
        if self.scheduleFollowAttack then self.scheduler:unscheduleScriptEntry(self.scheduleFollowAttack) end
        if self.scheduleAttackHero then self.scheduler:unscheduleScriptEntry(self.scheduleAttackHero) end
        
        local function callback(node,tab)
            node:stopAllActions()
            self.direction = self.originalDirection
        	node:stateEnterStand()
        	node:stateEnterWalkAround()
        end
        --反方向回
        local reverseDirection = nil
        if self.direction == ENTITY_DIRECTION.LEFT_DOWN then
            reverseDirection = ENTITY_DIRECTION.RIGHT_UP
        elseif self.direction == ENTITY_DIRECTION.RIGHT_DOWN then
            reverseDirection = ENTITY_DIRECTION.LEFT_UP
        elseif self.direction == ENTITY_DIRECTION.RIGHT_UP then
            reverseDirection = ENTITY_DIRECTION.LEFT_DOWN
        elseif self.direction == ENTITY_DIRECTION.LEFT_UP then
            reverseDirection = ENTITY_DIRECTION.RIGHT_DOWN
        else
            print("error" , direction)
        end
        self:stopActionByTag(ACTION_TAG.CHANGING)
        
        local animate = cc.Animate:create(self:getAnimation(ANIMATION_TYPE.MONSTER,reverseDirection,-1))
        self:runAction(animate)
        local action = cc.MoveTo:create(2,self.originalPos)
        self:runAction(cc.Sequence:create(action,cc.CallFunc:create(callback)))

    else
        if self.targetLastPos.x == self.target:getPosition() then return end
        print("real follow")
        local hero_last_pos = self.targetLastPos
        local hero_current_pos = cc.p(self.target:getPosition())
        local pos = cc.pAdd(cc.p(self:getPosition()),cc.pSub(hero_current_pos,hero_last_pos))
        
        local action = cc.MoveTo:create(0.5,pos)
        self:runAction(action)
        self.targetLastPos = cc.p(self.target:getPosition())
    end
end


