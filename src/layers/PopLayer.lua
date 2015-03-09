require("ParamConfig")
require("types/Types")
PopLayer = class("PopLayer",function() return cc.Layer:create() end)
PopLayer.__index = PopLayer


function PopLayer:ctor()
    self.widget = ccs.GUIReader:getInstance():widgetFromJsonFile(CONF.POP_JSON)
    self.widget:setPosition(cc.p(CONF.FRAME_WIDTH/2-100,CONF.FRAME_HEIGHT/2-50))
    
    self.okbutton = self.widget:getChildByName("box_Panel"):getChildByName("OKButton")
    self:addChild(self.widget)
    
    local function callback()
        cc.Director:getInstance():endToLua()
    end
    self.okbutton:addTouchEventListener(callback)
    --self.okbutton:registerControlEventHandler(callback,cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
    
end
