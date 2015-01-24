require("ParamConfig")
require("entity/Hero")
require("entity/Monster")
require("types/Types")

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
    self:setViewPointCenter(self.hero:getPosition())
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
            -- need run animation
            self.hero:setPosition(x,y)
            self:addChild(self.hero , LAYER_ZORDER.ENTITY)
        elseif entityType == "m1" then
            local monster = Monster.create()
            monster:setPosition(x,y)
            monster:setScale(1.4)
            --need run animation
            table.insert(self.monsters,monster)
            self:addChild(monster,LAYER_ZORDER.ENTITY)
        else
            -- another monster
        end
    end 
    
end


function MapLayer:setViewPointCenter(px,py)

    local resW =  CONF.RESOLUTION_WIDTH / 2
    local resH =  CONF.RESOLUTION_WIDTH / 2
    local x = math.max(px , resW)
    local y = math.max(py , resH)
    
    x = math.min(x, CONF.MAP_WIDTH - resW )
    y = math.min(x , CONF.MAP_HEIGHT - resH)
    
    local centerOfView = cc.p(resW,resH)
    local actualPoint = cc.p(x,y)
    self:setPosition(cc.pSub(centerOfView,actualPoint))
end





function MapLayer:isAccessable(point)
    local tile = self:point2Tile(point)
    local gid = self.accessLayer:getTileGidAt(tile)
    if gid then 
        return true
    end
    return false
end

function MapLayer:point2Tile(point)
    local originPos = cc.Director:getInstance():getVisibleOrigin()
    local x = math.floor( (originPos.x + point.x) / self.tileSize.width )
    local y = math.floor( (originPos.y + point.y) / self.tileSize.height)
    return cc.p(x,y)
end