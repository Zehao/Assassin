
require("entity.Entity")
require("ParamConfig")

Monster2 = class("Monster2", function(filepath) return Entity.new(filepath) end )

Monster2.__index = Monster2

function Monster2:ctor()
    self.hp = CONF.MONSTER2_HP
    self.fullHp = self.hp
    self.damage = CONF.MONSTER2_DAMAGE
    self.originalPos = nil
    self.originalDirection = nil
    self.scheduler = cc.Director:getInstance():getScheduler()
    self.isAttacked = false
    self.target = nil
end


function Monster2.create()
    return  Monster2.new(CONF.MONSTER2_STATIC_TEXTURE)
end

function Monster2:setTarget(hero)
    currentMonster= self
    self.target = hero 
    self.isAttacked = true
    self.targetLastPos = cc.p(hero:getPosition())
end


--站立
function Monster2:stateEnterStand()
    if self.entityState == ENTITY_STATE.STATE_STAND then
        return true
    end
    print("enter stand")
    --self:stopAllActions()
    self:stopActionByTag(ACTION_TAG.CHANGING)
    --self:stopActionByTag(ACTION_TAG.CHANGING)
    self.entityState = ENTITY_STATE.STATE_STAND

    local animation = self:getAnimation_M2(ANIMATION_TYPE.M2_STAND,self.direction,-1)
    local animate = cc.Animate:create(animation)
    animate:setTag(ACTION_TAG.CHANGING)
    self:runAction(animate)
end

--行走巡逻
function Monster2:stateEnterWalkAround()
    if self.entityState == ENTITY_STATE.STATE_RUN then
        self:stateEnterStand()
    end

    self.entityState = ENTITY_STATE.STATE_RUN
    self.target = nil
    self.isAttacked = false

    if  self.scheduleWalk then self.scheduler: unscheduleScriptEntry(self.scheduleWalk) end
    self:walkAround()
    local function walk()
        --print("walk")
        self:stateEnterWalkAround()
    end
    self.scheduleWalk = self.scheduler:scheduleScriptFunc(walk,math.random(10,13),false)
end



--进入打斗
--[[
修改状态，停止前面所有动画，停止走动定时器，移动到英雄旁边，
启动followattack定时器和attack定时器

]]
function Monster2:stateEnterFight()
    if self.entityState == ENTITY_STATE.STATE_FIGHT then
        return true
    end
    self.entityState = ENTITY_STATE.STATE_FIGHT

    self:stopAllActions()
    self.scheduler:unscheduleScriptEntry(self.scheduleWalk)
    self.scheduleFollowAttack = self.scheduler:scheduleScriptFunc(Monster2.followAttack,0.2,false)

    local direction,moveinfo = self:getFocus()
    self.direction = direction

    local deltaPoint = cc.pSub(cc.p(self.target:getPosition()),cc.p(self:getPosition()) )

    

    local moveAction 
    local moveinfo =cc.p(0,0)

    local rect = self:getBoundingBox()
    
    local cur_rect = cc.rect(rect.x,rect.y,rect.width,rect.height)
    
    while true do
        if cc.rectIntersectsRect(cur_rect,self.target:getBoundingBox()) == false then
            print(cur_rect.x,cur_rect.y,cur_rect.width,cur_rect.height)
            --moveinfo = cc.p(moveinfo.x+deltaPoint.x*0.1,moveinfo.y + deltaPoint.y*0.1)
            cur_rect.x = cur_rect.x + deltaPoint.x*0.05
            cur_rect.y = cur_rect.y + deltaPoint.y*0.05
        else 
            break
        end
    end
    moveAction = cc.MoveTo:create(0.2,cc.p(cur_rect.x+ cur_rect.width/2,cur_rect.y+cur_rect.height/2))
    self:runAction(moveAction)
    
    local animation = self:getAnimation_M2(ANIMATION_TYPE.M2_ATTACK,direction,-1)

    self:runAction(cc.Animate:create(animation))

    local function attackHero()
        self:attack(self.target)
        local move = cc.p(moveinfo.x*0.2,moveinfo.y*0.2)
        local attackAction = cc.MoveBy:create(0.05,move)
        self:runAction(cc.Sequence:create(attackAction,attackAction:reverse()))
    end

    self.scheduleAttackHero = self.scheduler:scheduleScriptFunc(attackHero,1.6,false)
end


function Monster2:stateEnterDie()

    self:stopAllActions()


    if  self.scheduleWalk then self.scheduler: unscheduleScriptEntry(self.scheduleWalk) end
    if self.scheduleFollowAttack then self.scheduler:unscheduleScriptEntry(self.scheduleFollowAttack) end
    if self.scheduleAttackHero then self.scheduler:unscheduleScriptEntry(self.scheduleAttackHero) end


    local seq = cc.Sequence:create(cc.Blink:create(0.8,4),cc.CallFunc:create( function() self:getParent():removeEntity(self) end ))
    self:runAction(seq)

end

function Monster2:getFocus()
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



function Monster2:distance2hero(hero)
    return cc.pGetDistance(cc.p(self:getPosition()),cc.p(hero:getPosition()))

end

--行走
function Monster2:walkAround()
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
    local animationReverse = self:getAnimation_M2(ANIMATION_TYPE.M2_RUN,reverseDirection,-1)

    local move1 = cc.MoveBy:create(math.random()+2,tarPos)  --2sec to 3sec
    move1:setTag(ACTION_TAG.MOVE)
    
    local function callfunc_forward(node,tab)
        self:stopActionByTag(ACTION_TAG.CHANGING)
        local animation = self:getAnimation_M2(ANIMATION_TYPE.M2_RUN,self.direction,-1)
        local animate = cc.Animate:create(animation)
        animate:setTag(ACTION_TAG.CHANGING)
        self:runAction(animate)
    end
    
    local move_forward = cc.Spawn:create(cc.Sequence:create(move1,cc.CallFunc:create(function() self:stateEnterStand() end)),cc.CallFunc:create(callfunc_forward))


    local move2 = move1:reverse()
    move2:setTag(ACTION_TAG.MOVE)
    
    local function callfunc_backward(node,tab)
        print("start go back")
        self:stopActionByTag(ACTION_TAG.CHANGING)
        local animation = self:getAnimation_M2(ANIMATION_TYPE.M2_RUN,reverseDirection,-1)
        local animate = cc.Animate:create(animation)
        animate:setTag(ACTION_TAG.CHANGING)
        self:runAction(animate)
    end
    
    local function endwalk(node,tab)
        self:stopAllActions()
        self:stopActionByTag(ACTION_TAG.CHANGING)
        --self:stopActionByTag(ACTION_TAG.CHANGING)
        local animation = self:getAnimation_M2(ANIMATION_TYPE.M2_STAND,reverseDirection,-1)
        local animate = cc.Animate:create(animation)
        animate:setTag(ACTION_TAG.CHANGING)
        self:runAction(animate)
    end
    
    local move_backward = cc.Spawn:create(cc.Sequence:create(move2,cc.CallFunc:create(endwalk)),cc.CallFunc:create(callfunc_backward))
    

    local function callbackfunc(node,tab)
        --node:stopAllActions()
        --node:runAction(animate2)
        node:stopActionByTag(ACTION_TAG.CHANGING)
    end

    --self:runAction(actionStart)

    self:runAction(cc.Sequence:create(
        cc.DelayTime:create(2),
        move_forward,
        cc.DelayTime:create(2),
        move_backward
        --cc.DelayTime:create(0.1),
    ));

end

--跟踪攻击
function Monster2.followAttack(dt)
    local self = currentMonster
    if self.target == nil or self.isAttacked == false then return end
    --若超过距离则返回到原位置
    if cc.pLengthSQ(cc.pSub(self.originalPos,cc.p(self:getPosition()))) > 90000 then
        print("return to original")
        if self.scheduleFollowAttack then self.scheduler:unscheduleScriptEntry(self.scheduleFollowAttack) end
        if self.scheduleAttackHero then self.scheduler:unscheduleScriptEntry(self.scheduleAttackHero) end

        local function callback(node,tab)
            self:stopAllActions()
            self.direction = self.originalDirection
            self.entityState = nil
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
        --self:stopActionByTag(ACTION_TAG.CHANGING)
        print("direction:" , self.direction , "reverse:" , reverseDirection)
        self:stopAllActions()

        local animate = cc.Animate:create(self:getAnimation_M2(ANIMATION_TYPE.M2_RUN,reverseDirection,-1))
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


