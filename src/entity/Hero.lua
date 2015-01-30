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

function Hero:runWeaponAnimation()
    local animation = AnimationManager:getInstance():getForeverAnimation(ANIMATION_TYPE.WEAPON,self.direction)
    self.weapon:runAction(cc.Animate:create(animation))
end



function Hero:stateEnterRun()
    assert(self.entityState ~= ENTITY_STATE.STATE_DIE)
    

    local function endRun()
        self:stateEnterStand()
    end

    local move = cc.MoveTo:create(self.moveInfo.duration,self.moveInfo.targetPosition)
    
    
    
    self:stopActionByTag(ACTION_TAG.MOVE)
    self:stopActionByTag(ACTION_TAG.CHANGING)
    self:runAnimation(ANIMATION_TYPE.HERO_RUN)
    self.entityState = ENTITY_STATE.STATE_RUN
    local action = cc.Sequence:create(move,cc.CallFunc:create(endRun))
    action:setTag(ACTION_TAG.MOVE)
    self:runAction(action)

    return true
end

function Hero:stateEnterStand()
    assert(self.entityState ~= ENTITY_STATE.STATE_DIE)
    assert(self.entityState ~= ENTITY_STATE.STATE_FIGHT)
    if self.entityState == ENTITY_STATE.STATE_STAND then
        return true
    end
    self:stopActionByTag(ACTION_TAG.CHANGING)
    self.entityState = ENTITY_STATE.STATE_STAND
    self:runAnimation(ANIMATION_TYPE.HERO_STAND)
    return true
end

function Hero:stateEnterDie()
    self:stopActionByTag(ACTION_TAG.CHANGING)
    self.entityState = ENTITY_STATE.STATE_DIE
    self:removeFromParentAndCleanup()
    return true
end

function Hero:enterStateFight()
    self:stopActionByTag(ACTION_TAG.CHANGING)
    if self.entityState == ENTITY_STATE.STATE_FIGHT then
        return true
    end
    self.entityState = ENTITY_STATE.STATE_FIGHT
    self:runAnimation(ANIMATION_TYPE.HERO_ATTACK)
end



--外部来保证两点之间可以直线到达
function Hero:move(moveinfo)
    self.moveInfo = moveinfo
    self:stateEnterRun()
end