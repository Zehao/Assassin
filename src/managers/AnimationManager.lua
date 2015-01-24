
AnimationManager = {}


function AnimationManager:new(o)
    o = o or {}
    setmetatable(o,self)
	self.__index = self
	return o
end

function AnimationManager:getInstance()
    if self.instance == nil then
        self.instance = self:new()
        self.hero_attack = {}
        self.hero_run = {}
        self.hero_stand = {}
        self.monster1 = {}
        self:initAnimationManager()
     end
     return self.instance
end


function AnimationManager:initAnimationManager()
    local spriteFrameCache = cc.SpriteFrameCache:getInstance()
    spriteFrameCache:addSpriteFramesWithFile(CONF.HERO_ATTACK_PLIST,CONF.HERO_ATTACK_PNG)
    spriteFrameCache:addSpriteFramesWithFile(CONF.HERO_RUN_PLIST,CONF.HERO_RUN_PNG)
    spriteFrameCache:addSpriteFramesWithFile(CONF.HERO_STOP_PLIST,CONF.HERO_STOP_PNG)
    spriteFrameCache:addSpriteFramesWithFile(CONF.MONSTER1_PLIST,CONF.MONSTER1_PNG)
    --hero attack
    for i = 0 ,  CONF.HERO_ATTACK_DIRECTIONS-1 do
        local frames={}
        for j = 0 , CONF.HERO_ATTACK_FRAME_NUM-1 do
            local frame = spriteFrameCache:getSpriteFrameByName(string.format("%s%02d%03d.png",CONF.HERO_ATTACK_PREFIX,i,j))
            if frame then
                frames:insert(frame)
            end
        end
        self.hero_attack:insert(cc.Animate:create(cc.Animation:createWithSpriteFrames(frames,0.08,-1)))
    end
    
    --hero run
    for i = 0 ,  CONF.HERO_RUN_DIRECTIONS-1 do
        local frames={}
        for j = 0 , CONF.HERO_RUN_FRAME_NUM-1 do
            local frame = spriteFrameCache:getSpriteFrameByName(string.format("%s%02d%03d.png",CONF.HERO_RUN_PREFIX,i,j))
            if frame then
                frames:insert(frame)
            end
        end
        self.hero_run:insert(cc.Animate:create(cc.Animation:createWithSpriteFrames(frames,0.08,-1)))
    end
    
    --hero stand
    for i = 0 ,  CONF.HERO_STOP_DIRECTIONS-1 do
        local frames={}
        for j = 0 , CONF.HERO_STOP_FRAME_NUM-1 do
            local frame = spriteFrameCache:getSpriteFrameByName(string.format("%s%02d%03d.png",CONF.HERO_STOP_PREFIX,i,j))
            if frame then
                frames:insert(frame)
            end
        end
        self.hero_stand:insert(cc.Animate:create(cc.Animation:createWithSpriteFrames(frames,0.1,-1)))
    end
    
    -- monster1
    for i = 0 ,  CONF.MONSTER1_DIRECTIONS-1 do
        local frames={}
        for j = 0 , CONF.MONSTER1_FRAME_NUM-1 do
            local frame = spriteFrameCache:getSpriteFrameByName(string.format("%s%02d%03d.png",CONF.MONSTER1_PREFIX,i,j))
            if frame then
                frames:insert(frame)
            end
        end
        self.monster1:insert(cc.Animate:create(cc.Animation:createWithSpriteFrames(frames,0.1,-1)))
    end
    
end


function AnimationManager:getAnimate(animateType , direction)
    if animateType == ANIMATION_TYPE.HERO_RUN then
        return self.hero_run[direction]
    elseif animateType == ANIMATION_TYPE.HERO_STAND then
        return self.hero_stand[direction]
    elseif animationType == ANIMATION_TYPE.HERO_ATTACK then
        return self.hero_attack
    elseif animationType == ANIMATION_TYPE.MONSTER then
        return self.monster1[direction]
    end
    return nil
end
