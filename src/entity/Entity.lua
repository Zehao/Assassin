require("types/Types")
require("ParamConfig")
require("layers/PopLayer")
require("managers/AnimationManager")
Entity = class("Entity",function(filepath)
    return cc.Sprite:create(filepath)
end)

Entity.__index = Entity


function g_endGame()
    local layer = cc.Director:getInstance():getRunningScene()
    local pop = PopLayer.new()
    layer:addChild(pop,1000)
end



function Entity:ctor()
    self.direction = ENTITY_DIRECTION.RIGHT_DOWN
    self.isAlive = true
    self.hp=0
    self.moveInfo = nil
    self.entityState = nil
    self:setScale(1.5)

end

function Entity:stateEnterRun()
end

function Entity:stateEnterStand()
end

function Entity:stateEnterDie()
end

function Entity:stateEnterFight()
    
end

function Entity:changeState(state)
end

function Entity:attack(target)

    target.hp = target.hp - self.damage

    target.hpBar:setPercent(target.hp *100/ target.fullHp)
    
    target:runAction(cc.Blink:create(0.3,2))
    if target.hp <=0 then
        target.hp = 0
        --self:stopAllActions()
        if target == g_hero then
            g_endGame()
        end
        target:stateEnterDie()
    end
--    local function attackInterval(delta)
--        print("hero attack interval")
--        target.hp = target.hp - self.damage
--        if target.hp <= 0 then 
--            target.hp = 0 
--            target.isAlive = false
--            self:getParent():removeEntity(target)
--            self.isAttacking = false
--            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
--            
--        end
--        
--    end
--    self.scheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(attackInterval,2,false)

end

function Entity:isAttacked()
end

function Entity:setDirection(direct)
    self.direction = direct
end

function Entity:getDirection()
    return self.direction
end

function Entity:stopAnimations()
    Entity:stopAllActions()
end


function Entity:runAnimationOnce(animation_type)
    local animation = AnimationManager:getInstance():getOnceAnimation(animation_type , self.direction)
    --print(animation , animation_type , self.direction)
    local animate = cc.Animate:create(animation)
    animate:setTag(ACTION_TAG.CHANGING)
    self:runAction(animate)
end

function Entity:getAnimation(animation_type, direction,loops)
    return AnimationManager:getInstance():getAnimation(animation_type,direction ,loops)
end

function Entity:getAnimation_M2(animation_type, direction,loops)
    return AnimationManager:getInstance():getAnimation_M2(animation_type,direction ,loops)
end



--function Entity:runAnimation(animation_type)
--    local animation = AnimationManager:getInstance():getForeverAnimation(animation_type , self.direction)
--    --print(animation , animation_type , self.direction)
--    local animate = cc.Animate:create(animation)
--    animate:setTag(ACTION_TAG.CHANGING)
--    self:runAction(animate)
--end

function Entity:setHP(value)
    self.hp = value
end

function Entity:getHP()
	return self.hp
end
