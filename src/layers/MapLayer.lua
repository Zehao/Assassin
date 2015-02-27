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
    self.infoLayer=nil
    self:setViewPointCenter(cc.p(self.hero:getPosition()))
    self:registerTouchEvent()
    
    
    
    local function scheduleFight()
        
        
--        local faceMonster = self:meetMonster()
--        if faceMonster then 
--            --print(faceMonster:getPosition())
--            self.hero:stateEnterStand()
--        end        
    end

    --每帧刷新视角
    local function scheduleViewPoint(delta)
        self:setViewPointCenter(cc.p(self.hero:getPosition()))
    end

    
    local scheduler = cc.Director:getInstance():getScheduler()
    
    --local viewFrequency = 1/60.0
    --self.scheduleViewpointID = scheduler:scheduleScriptFunc(scheduleViewPoint,viewFrequency,false)
    self:scheduleUpdateWithPriorityLua(scheduleViewPoint, 0)  
    
    local fightViewFrequency = 1/10.0
    self.schequleFightID = scheduler:scheduleScriptFunc(scheduleFight,fightViewFrequency,false)
    
end




function MapLayer:meetMonster()
    local heroPos = cc.p(self.hero:getPosition())
    local rect = self.hero:getBoundingBox()
    for i = 1,#self.monsters do
        --if cc.rectContainsPoint(self.monsters[i]:getBoundingBox(),heroPos) then
        if cc.rectIntersectsRect(rect,self.monsters[i]:getBoundingBox()) then
            return self.monsters[i]
        end
    end
    return nil
end


--注册touch事件
function MapLayer:registerTouchEvent()
    local dispatcher = cc.Director:getInstance():getEventDispatcher()
    local listener = cc.EventListenerTouchOneByOne:create()

    -- on touch began
    local function onTouchBegan(touch , event)
        local touchPoint = touch:getLocation()
        touchPoint = self:convertToNodeSpace(touchPoint)
        local heroPos = cc.p(self.hero:getPosition())
        local moveInfo = MoveInfo.new()
        local p = self.hero:getBoundingBox()
        local heroNeedMove = true
        
        if touchPoint.x > p.x + p.width then
            if touchPoint.y > p.y+p.height then
                moveInfo.direction = ENTITY_DIRECTION.RIGHT_UP
            elseif touchPoint.y < p.y then
                 moveInfo.direction = ENTITY_DIRECTION.RIGHT_DOWN
            else
                 moveInfo.direction = ENTITY_DIRECTION.RIGHT
            end
        elseif touchPoint.x < p.x then
            if touchPoint.y > p.y+p.height then
                 moveInfo.direction = ENTITY_DIRECTION.LEFT_UP
            elseif touchPoint.y < p.y then
                 moveInfo.direction = ENTITY_DIRECTION.LEFT_DOWN
            else
                 moveInfo.direction = ENTITY_DIRECTION.LEFT
            end
        else
            if touchPoint.y > p.y+p.height then
                 moveInfo.direction = ENTITY_DIRECTION.UP
            elseif touchPoint.y < p.y then
                 moveInfo.direction = ENTITY_DIRECTION.DOWN
            else
                heroNeedMove = false
            end
        end
    
        if heroNeedMove then
            moveInfo:setPoint(heroPos, self:getMoveTargetPoint(heroPos,touchPoint))
            self.hero:setDirection(moveInfo.direction)
            self.hero:move(moveInfo)
        end
        return true
    end

    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    --listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    --listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    dispatcher:addEventListenerWithSceneGraphPriority(listener,self)
end



--设置英雄和怪物
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
            --self.hero:runAnimation(ANIMATION_TYPE.HERO_STAND)
            
            self.hero:setPosition(x,y)
            self.hero:stateEnterStand()
            self:addChild(self.hero , LAYER_ZORDER.ENTITY)
        elseif entityType == "m1" then
            local monster = Monster.create()
            monster:setPosition(x,y)
            monster.direction = math.random(1,CONF.MONSTER1_DIRECTIONS)
            monster:walkAround()
            table.insert(self.monsters,monster)
            self:addChild(monster,LAYER_ZORDER.ENTITY)
        else
            -- another monster
        end
    end 
    
end


function MapLayer:removeEntity(entity)
    for i =1,#self.monsters do
        if entity == self.monsters[i] then
            table.remove(self.monsters,i)
            self:removeChild(entity,true)
            return true
        end
    end
    return false
end

--设置视点
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


--set target point when touched
function MapLayer:getMoveTargetPoint(cur,tar)
    local curPosition = cc.p(cur.x,cur.y)
    local delta = CONF.MAP_TILESIZE / 2.0
    local theta = math.atan(math.abs((tar.y - cur.y) / (tar.x - cur.x) ) )

    local deltaX,deltaY = delta * math.cos(theta) , delta * math.sin(theta)
    if tar.x < cur.x then deltaX = - deltaX  end
    if tar.y < cur.y then deltaY = - deltaY  end
    
    local function isClose()
        local d1 = ( curPosition.x - tar.x)*( curPosition.x - tar.x)
        local d2 = ( curPosition.y - tar.y)*( curPosition.y - tar.y)
        if (d1 + d2) < delta*delta then
            return true
        end
        return false
    end
    
    
    while true do
        if isClose() then
            curPosition.x ,curPosition.y = tar.x,tar.y
            break
        end
        if self:isAccessable(cc.p(curPosition.x + deltaX,curPosition.y + deltaY ))== false then
            break
        end
        curPosition.x , curPosition.y  = curPosition.x + deltaX,curPosition.y + deltaY 
    end
    return curPosition
end

function MapLayer:isAccessable(point)
    local tile = self:point2Tile(point)
    local gid = self.accessLayer:getTileGIDAt(tile)
    --print(string.format("current tile:%d,%d,gid:%d",tile.x,tile.y,gid))
    
    if gid == 0 then
        return false
    end
    
    for i = 1,#self.monsters do
        if cc.rectContainsPoint(self.monsters[i]:getBoundingBox(),point) then
            return false
        end
    end
    
    return true
end


function MapLayer:point2Tile(point)
    local x = math.floor(point.x / CONF.MAP_TILESIZE )
    local y = math.floor( (CONF.MAP_HEIGHT - point.y) / CONF.MAP_TILESIZE )
    return cc.p(x,y)
end


function MapLayer:setInfos(InfoLayer)
	self.infoLayer = InfoLayer
    self.infoLayer:setHero(self.hero)
end


function MapLayer:getAttackMonster(heroPos,attackDirection)
    --Rect(float x, float y, float width, float height)
	local distance = CONF.HERO_ATTACK_DISTANCE
	local rects={}
	local startRect = self.hero:getBoundingBox()
	rects[#rects+1 ] = startRect
	local midRect,endRect
	local midDis = distance/2
	if attackDirection == ENTITY_DIRECTION.DOWN then
        midRect = cc.rect(startRect.x,startRect.y-midDis,startRect.width,startRect.height)
        endRect = cc.rect(startRect.x,startRect.y-distance,startRect.width,startRect.height)
    elseif attackDirection == ENTITY_DIRECTION.UP then
        midRect = cc.rect(startRect.x,startRect.y+midDis,startRect.width,startRect.height)
        endRect = cc.rect(startRect.x,startRect.y+distance,startRect.width,startRect.height)
    elseif attackDirection == ENTITY_DIRECTION.LEFT then
        midRect = cc.rect(startRect.x-midDis,startRect.y,startRect.width,startRect.height)
        endRect = cc.rect(startRect.x-distance,startRect.y,startRect.width,startRect.height)
    elseif attackDirection == ENTITY_DIRECTION.RIGHT then
        midRect = cc.rect(startRect.x+midDis,startRect.y,startRect.width,startRect.height)
        endRect = cc.rect(startRect.x+distance,startRect.y,startRect.width,startRect.height)
    elseif attackDirection == ENTITY_DIRECTION.RIGHT_DOWN then
        midRect = cc.rect(startRect.x+midDis,startRect.y-midDis,startRect.width,startRect.height)
        endRect = cc.rect(startRect.x+distance,startRect.y-distance,startRect.width,startRect.height)
    elseif attackDirection == ENTITY_DIRECTION.LEFT_DOWN then
        midRect = cc.rect(startRect.x-midDis,startRect.y-midDis,startRect.width,startRect.height)
        endRect = cc.rect(startRect.x-distance,startRect.y-distance,startRect.width,startRect.height)
    elseif attackDirection == ENTITY_DIRECTION.LEFT_UP then
        midRect = cc.rect(startRect.x-midDis,startRect.y+midDis,startRect.width,startRect.height)
        endRect = cc.rect(startRect.x-distance,startRect.y+distance,startRect.width,startRect.height)
    elseif attackDirection == ENTITY_DIRECTION.RIGHT_UP then
        midRect = cc.rect(startRect.x+midDis,startRect.y+midDis,startRect.width,startRect.height)
        endRect = cc.rect(startRect.x+distance,startRect.y+distance,startRect.width,startRect.height)
	end
	
    rects[#rects+1 ] = midRect
    rects[#rects+1 ] = endRect
    local monster
    for i=1,#self.monsters do
        local isIntersect
        for j = 1,#rects do
            if cc.rectIntersectsRect(rects[j],self.monsters[i]:getBoundingBox()) then
                monster = self.monsters[i]
                isIntersect = true
                break
            end
        end
        if isIntersect then 
            break 
        end
    end
    
    print("target:" , monster)
    return monster
end

