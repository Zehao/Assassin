require("ParamConfig")
require("entity/Hero")
require("entity/Monster")
require("types/Types")

MapLayer = class("MapLayer",function() cc.layer:create() end)
MapLayer.__index = MapLayer

function MapLayer:ctor()
    self.map = cc.TMXTiledMap:create(CONF.MAP_TILE_PATH)
    assert(self.map,"null map")
    self.tileSize = self.map:getTileSize()
    self.resHeight = CONF.RESOLUTION_HEIGHT
    self.resWidth = CONF.RESOLUTION_WIDTH
    
    self.accessLayer = self.map:getLayer(CONF.MAP_TILE_ACCESS)
    assert(self.accessLayer,"null layer")
    self.accessLayer:setVisible(false)
    
    self.bgLayer = self.map:getLayer(CONF.MAP_TILE_BG)
    assert(self.bgLayer,"null layer")
    self.bgLayer:setVisible(true)
    
    
    self.entityLayer = map:getObjectGroup(CONF.MAP_TILE_ENTITY)
    assert(self.entityLayer,"null layer")
    
    self:addChild(map,LAYER_ZORDER.MAP)
    
    
    self.monsters = {}
    self:setEntities()
    
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
            self:addChild(hero , LAYER_ZORDER.ENTITY)
        elseif entityType == "m1" then
            local monster = Monster.create()
            monster:setPosition(x,y)
            monster:setScale(1.4)
            --need run animation
            self.monsters:insert(monster)
            self:addChild(Monster)
        else
            -- another monster
        end
    end 
    
end


