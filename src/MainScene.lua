require("layers/InfoLayer")
require("layers/MapLayer")
require("managers/AnimationManager")


g_hero=nil
currentMonster = {}




local MainScene = class("MainScene",function()
    return cc.Scene:create()
end)

function MainScene.create()
    local scene = MainScene.new()


    local infoLayer = InfoLayer:new()
    infoLayer:setName(CONF.INFO_LAYER_NAME)
    scene:addChild(infoLayer, LAYER_ZORDER.INFO)
    

    local mapLayer = MapLayer.new()
    mapLayer:setName(CONF.MAP_LAYER_NAME)
    scene:addChild(mapLayer,LAYER_ZORDER.MAP )
    
    mapLayer:setInfos(infoLayer)

    return scene
end


function MainScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function MainScene:playBgMusic()
    local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename("background.mp3") 
    cc.SimpleAudioEngine:getInstance():playMusic(bgMusicPath, true)
    local effectPath = cc.FileUtils:getInstance():fullPathForFilename("effect1.wav")
    cc.SimpleAudioEngine:getInstance():preloadEffect(effectPath)
end



return MainScene
