require("ParamConfig")
require("entity/Hero")
require("entity/Monster")
require("types/Types")
require("types/MoveInfo")

MapLayer = class("MapLayer",function() return cc.Layer:create() end)
MapLayer.__index = MapLayer
local WIN_SIZE = cc.Director:getInstance():getVisibleSize()


function MapLayer:ctor()
    self.map = cc.TMXTiledMap:create(CONF.MAP_TILE_PATH)
    assert(self.map,"null map")
    self.tileSize = self.map:getTileSize()
    
    self.accessLayer = self.map:getLayer(CONF.MAP_TILE_ACCESS)
    assert(self.accessLayer,"null layer")
    self.accessLayer:setVisible(false)
    
    self.bgLayer = self.map:getLayer(CONF.MAP_TILE_BG)
    assert(self.bgLayer,"null layer")
    self.bgLayer:setVisible(true)
    
    
    self.entityLayer = self.map:getObjectGroup(CONF.MAP_TILE_ENTITY)
    assert(self.entityLayer,"null layer")
    
    self:addChild(self.map,LAYER_ZORDER.MAP)
    
    
    self.monsters = {}
    self:setEntities()
    self.heroNeedMove = false
    self.moveInfo = MoveInfo.new()
    self:setViewPointCenter(cc.p(self.hero:getPosition()))
    self:registerTouchEvent()
end


function MapLayer:registerTouchEvent()
    local dispatcher = cc.Director:getInstance():getEventDispatcher()
    local listener = cc.EventListenerTouchOneByOne:create()
    
    
    --update per frame
    local update = function(delta)
        if self.heroNeedMove == false then
            return
        end
        if self.moveInfo:isDestination() then
            print("MOVED")
            self.hero:setPosition(self.moveInfo.targetPoint)
            self.hero:stopAllActions()
            self.hero:runAnimation(ANIMATION_TYPE.HERO_STAND)
            self:unscheduleUpdate()
            self.heroNeedMove = false
        else
            local pos =  self.moveInfo:getNewPos()
            print(string.format("CURRENT POSITION:%f,%f . TARGET POSITION:%f,%f " , pos.x , pos.y, self.moveInfo.targetPoint.x ,  self.moveInfo.targetPoint.y))
            if self:isAccessable(self.moveInfo:checkPoint()) then
                self.hero:setPosition(pos)
            else
                self.heroNeedMove = false
                self.hero:stopAllActions()
                self.hero:runAnimation(ANIMATION_TYPE.HERO_STAND)
                self:unscheduleUpdate()
            end
        end
        self:setViewPointCenter(cc.p(self.hero:getPosition()))
    end
    
    
    -- on touch began
    local function onTouchBegan(touch , event)
        local touchPoint = touch:getLocation()
        touchPoint = self:convertToNodeSpace(touchPoint)
        local heroPos = cc.p(self.hero:getPosition())
        
        local p = self.hero:getBoundingBox()
        self.heroNeedMove = true
        
        if touchPoint.x > p.x + p.width then
            if touchPoint.y > p.y+p.height then
                self.moveInfo.direction = ENTITY_DIRECTION.RIGHT_UP
            elseif touchPoint.y < p.y then
                 self.moveInfo.direction = ENTITY_DIRECTION.RIGHT_DOWN
            else
                 self.moveInfo.direction = ENTITY_DIRECTION.RIGHT
            end
        elseif touchPoint.x < p.x then
            if touchPoint.y > p.y+p.height then
                 self.moveInfo.direction = ENTITY_DIRECTION.LEFT_UP
            elseif touchPoint.y < p.y then
                 self.moveInfo.direction = ENTITY_DIRECTION.LEFT_DOWN
            else
                 self.moveInfo.direction = ENTITY_DIRECTION.LEFT
            end
        else
            if touchPoint.y > p.y+p.height then
                 self.moveInfo.direction = ENTITY_DIRECTION.UP
            elseif touchPoint.y < p.y then
                 self.moveInfo.direction = ENTITY_DIRECTION.DOWN
            else
                self.heroNeedMove = false
            end
        end
    
        if self.heroNeedMove then
            self.moveInfo:setPoint(heroPos, touchPoint)
            self.moveInfo.tileSize = self.tileSize
            self.hero:setDirection(self.moveInfo.direction)
            self.hero:stopAllActions()
            self.hero:runAnimation(ANIMATION_TYPE.HERO_RUN)
            self:scheduleUpdateWithPriorityLua(update, 0)  --schedule update 
        end
        return true
    end
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    --listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    --listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener,self)
end




function MapLayer:setEntities()
    
    local objs = self.entityLayer:getObjects()
    local dict = nil
    local len = table.maxn(objs)
    for i=0,len-1 do
        dict = objs[i+1]
        if dict == nil then
            break
        end
        
        local x = dict["x"]
        local y = dict["y"]
        local entityType = dict["type"]
        
        if entityType == "hero" then

            self.hero = Hero.create()
            self.hero:setScale(1.4)
            self.hero:runAnimation(ANIMATION_TYPE.HERO_STAND)
            self.hero:setPosition(x,y)
            self:addChild(self.hero , LAYER_ZORDER.ENTITY)
        elseif entityType == "m1" then
            local monster = Monster.create()
            monster:setPosition(x,y)
            monster:setScale(1.4)
            monster.direction = math.random(1,CONF.MONSTER1_DIRECTIONS)
            monster:runAnimation(ANIMATION_TYPE.MONSTER)
            table.insert(self.monsters,monster)
            self:addChild(monster,LAYER_ZORDER.ENTITY)
        else
            -- another monster
        end
    end 
    
end


function MapLayer:setViewPointCenter(point)
    --print(string.format("setViewPointCenter:%f,%f",point.x ,point.y))
    local resW =  CONF.RESOLUTION_WIDTH / 2
    local resH =  CONF.RESOLUTION_HEIGHT / 2
    local x = math.max(point.x , resW)
    local y = math.max(point.y , resH)
    
    x = math.min(x, CONF.MAP_WIDTH - resW )
    y = math.min(y , CONF.MAP_HEIGHT - resH)
    
    local centerOfView = cc.p(resW,resH)
    local actualPoint = cc.p(x,y)
    --print(string.format("Center:%f,%f,actual:%f,%f",resW,resH,x,y))
    self:setPosition(cc.pSub(centerOfView,actualPoint))
end





function MapLayer:isAccessable(point)
    local tile = self:point2Tile(point)
    local gid = self.accessLayer:getTileGIDAt(tile)
    print(string.format("current tile:%d,%d,gid:%d",tile.x,tile.y,gid))
    if gid ~= 0 then 
        return true
    end
    return false
end

function MapLayer:point2Tile(point)
    local x = math.floor(point.x / self.tileSize.width )
    local y = math.floor( (CONF.MAP_HEIGHT - point.y) / self.tileSize.height)
    return cc.p(x,y)
end