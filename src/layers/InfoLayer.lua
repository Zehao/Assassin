require("ParamConfig")
require("entity/Hero")
require("entity/Monster")
require("types/Types")

InfoLayer = class("InfoLayer",function() return cc.Layer:create() end)
InfoLayer.__index = InfoLayer


function InfoLayer:ctor()
end

