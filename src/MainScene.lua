require("layers/InfoLayer")
require("layers/MapLayer")
require("managers/AnimationManager")


local MainScene = class("MainScene",function()
    return cc.Scene:create()
end)

function MainScene.create()
    local scene = MainScene.new()
    
    local mapLayer = MapLayer.new()
    scene:addChild(mapLayer,LAYER_ZORDER.MAP )
    --local infoLayer = InfoLayer:new()
    --scene:addChild(infoLayer, LAYER_ZORDER.INFO)

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
