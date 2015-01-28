require("ParamConfig")
require("entity/Hero")
require("entity/Monster")
require("types/Types")

InfoLayer = class("InfoLayer",function() return cc.Layer:create() end)
InfoLayer.__index = InfoLayer


function InfoLayer:ctor()
    self.heroWidget = ccs.GUIReader:getInstance():widgetFromJsonFile(CONF.UI_HEAD_JSON)
    self.heroWidget:setPosition(0,CONF.RESOLUTION_HEIGHT-self.heroWidget:getCustomSize().height)
    local panel = self.heroWidget:getChildByName("infos")
    self.heroHP = panel:getChildByName("bar_hp")
    
    self.heroMP = panel:getChildByName("bar_mp")
    
    self.monsterWidget =  ccs.GUIReader:getInstance():widgetFromJsonFile(CONF.UI_MONSTER_JSON)
    self.monsterWidget:setPosition(CONF.RESOLUTION_WIDTH - self.monsterWidget:getCustomSize().width,CONF.RESOLUTION_HEIGHT-self.monsterWidget:getCustomSize().height)
    panel = self.monsterWidget:getChildByName("infos")
    self.monsterHP = panel:getChildByName("bar_hp")
    
    
    --初始不可见
    self.monsterWidget:setVisible(false)
    self.monster = nil
    self:addChild(self.heroWidget)
    self:addChild(self.monsterWidget)
    --self:spreadTouchEvent()
    
    --local scheduler = cc.Director:getInstance():getScheduler()
    
    local function update()
        if self.hero then
            self.heroHP:setPercent(self.hero.hp*100/CONF.HERO_HP)
            self.heroMP:setPercent(self.hero.mp*100/CONF.HERO_MP)
        end
        
        if self.monster then
            self.monsterHP:setPercent(self.monster.hp *100/ CONF.MONSTER1_HP)
        end
    end
    
    self:scheduleUpdateWithPriorityLua(update, 0)  
end



--function InfoLayer:spreadTouchEvent()
--    local dispatcher = cc.Director:getInstance():getEventDispatcher()
--    local listener = cc.EventListenerTouchOneByOne:create()
--    listener:setSwallowTouches(true)
--    local function onTouchBegan(touch , event)
--        print("InfoLayer:ontouch began")
--        local hp =self.heroHP:getPercent()-8
--        if hp < 0 then hp = 0 end
--        self.heroHP:setPercent(hp)
--        
--        return false
--    end
--    
--    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
--    dispatcher:addEventListenerWithSceneGraphPriority(listener,self)
--    
--end

function InfoLayer:setMonsterWidgetVisibility(v)
    self.monsterWidget:setVisible(v)
end



function InfoLayer:setMonster(monster)
    self.monster = monster
end

function InfoLayer:setHero(h)
    self.hero = h
end


function InfoLayer:removeMonster()
	self.monster = nil
end