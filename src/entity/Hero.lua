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
    self.fullHp = self.hp
    self.fullMp = self.mp
    self.hpBar = nil
    self.mpBar = nil
    self.damage = CONF.HERO_DAMAGE
    -- need to init
    self.weapon = Weapon.create()
    
    --need to be done for weapon
    self.weapon:setPosition(cc.p(self:getContentSize().width/2.0,self:getContentSize().height/2.0))
    self.weapon.pos = cc.p(self:getContentSize().width/2.0,self:getContentSize().height/2.0)
    self.weapon:setVisible(false)
    self:addChild(self.weapon )
    local dispatcher =  cc.Director:getInstance():getEventDispatcher()
    local listener = cc.EventListenerKeyboard:create()
    
    
    local function onKeyPressed(keycode , event)
        
        if keycode == cc.KeyCode.KEY_A then
            print("A Pressed")
        elseif keycode == cc.KeyCode.KEY_F then
            print("F Pressed")
        end
    end
    
    local function onKeyReleased(keycode , event)
        if keycode == cc.KeyCode.KEY_A then
            print("A Released")
            self:enterStateFight()
        elseif keycode == cc.KeyCode.KEY_F then
            print("F Released")
        end
    end
    
    listener:registerScriptHandler(onKeyPressed , cc.Handler.EVENT_KEYBOARD_PRESSED)
    listener:registerScriptHandler(onKeyReleased , cc.Handler.EVENT_KEYBOARD_RELEASED)

    dispatcher:addEventListenerWithSceneGraphPriority(listener,self)
    
    
end

function Hero.create()
    return Hero.new(CONF.HERO_STATIC_TEXTURE)
end
 

function Hero:setSkillSprite(sprite)
    self.skill = sprite
end

function Hero:stateEnterRun()
    assert(self.entityState ~= ENTITY_STATE.STATE_DIE)
    

    local function endRun()
        self:stateEnterStand()
    end

    local move = cc.MoveTo:create(self.moveInfo.duration,self.moveInfo.targetPosition)
    
    
    
    self:stopActionByTag(ACTION_TAG.MOVE)
    self:stopActionByTag(ACTION_TAG.CHANGING)
    local animation = self:getAnimation(ANIMATION_TYPE.HERO_RUN,self.direction,-1)
    local animate = cc.Animate:create(animation)
    animate:setTag(ACTION_TAG.CHANGING)
    self:runAction(animate)
    
    self.entityState = ENTITY_STATE.STATE_RUN
    local action = cc.Sequence:create(move,cc.CallFunc:create(endRun))
    action:setTag(ACTION_TAG.MOVE)
    self:runAction(action)

    return true
end

function Hero:stateEnterStand()
    assert(self.entityState ~= ENTITY_STATE.STATE_DIE)
    --assert(self.entityState ~= ENTITY_STATE.STATE_FIGHT)
    if self.entityState == ENTITY_STATE.STATE_STAND then
        return true
    end
    self:stopActionByTag(ACTION_TAG.CHANGING)
    self.entityState = ENTITY_STATE.STATE_STAND
    self:stopActionByTag(ACTION_TAG.MOVE)
    self:stopActionByTag(ACTION_TAG.CHANGING)
    
    local animation = self:getAnimation(ANIMATION_TYPE.HERO_STAND,self.direction,-1)
    local animate = cc.Animate:create(animation)
    animate:setTag(ACTION_TAG.CHANGING)
    self:runAction(animate)
    
    return true
end

function Hero:stateEnterDie()
    self:stopActionByTag(ACTION_TAG.CHANGING)
    self.entityState = ENTITY_STATE.STATE_DIE
    
    
    self:removeFromParentAndCleanup()
    
    return true
end

function Hero:enterStateFight()
    if self.entityState == ENTITY_STATE.STATE_FIGHT then
        return true
    end
    self.entityState = ENTITY_STATE.STATE_FIGHT
    
    self:stopActionByTag(ACTION_TAG.CHANGING)
    self:stopActionByTag(ACTION_TAG.MOVE)
    self.weapon:stopAllActions()

    --self.skill
    local endFight = function()
        
        self:stateEnterStand()
        self.skill:setColor(cc.c3b(255,255,255))
    end
    
    
    
    
    --self:runAnimationOnce(ANIMATION_TYPE.HERO_ATTACK)
    
    print("attack direction:", self.direction)
    local animation = self:getAnimation(ANIMATION_TYPE.HERO_ATTACK,self.direction,1)
    local actions = cc.Sequence:create(cc.Animate:create(animation))
    local attackDelay = cc.Sequence:create(cc.DelayTime:create(1.0),cc.CallFunc:create(endFight))
    actions:setTag(ACTION_TAG.CHANGING)
    self:runAction(actions)
    self:runAction(attackDelay)
    self.weapon:setVisible(true)
    self.skill:setColor(cc.c3b(128,128,128))
    self.weapon:runActions(self.direction)

    self.mp = self.mp-20
    self.mpBar:setPercent(self.mp *100/ self.fullMp)

    
    local target = self:getParent():getAttackMonster(self:getPosition(),self.direction)
    if target then 
        self.target = target 
        self.target:setTarget(self)
        self.target:stateEnterFight()
        self:attack(target)
    end
end



--外部来保证两点之间可以直线到达
function Hero:move(moveinfo)
    self.moveInfo = moveinfo
    self:stateEnterRun()
end