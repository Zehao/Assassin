
AnimationManager = class("AnimationManager")

--单例模式，动画管理器
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
        
        self.weapon = {}
        self.monster1 = {}
        self.monster2_attack={}
        self.monster2_run={}
        self.monster2_stand={}
        self:initAnimationManager()
     end
     return self.instance
end




function AnimationManager:initAnimationManager()
    local spriteFrameCache = cc.SpriteFrameCache:getInstance()
    spriteFrameCache:addSpriteFrames(CONF.HERO_ATTACK_PLIST,CONF.HERO_ATTACK_PNG)
    spriteFrameCache:addSpriteFrames(CONF.HERO_RUN_PLIST,CONF.HERO_RUN_PNG)
    spriteFrameCache:addSpriteFrames(CONF.HERO_STOP_PLIST,CONF.HERO_STOP_PNG)
    spriteFrameCache:addSpriteFrames(CONF.MONSTER1_PLIST,CONF.MONSTER1_PNG)
    spriteFrameCache:addSpriteFrames(CONF.WEAPON_PLIST,CONF.WEAPON_PNG)
    
    spriteFrameCache:addSpriteFrames(CONF.MONSTER2_ATTACK_PLIST,CONF.MONSTER2_ATTACK_PNG)
    spriteFrameCache:addSpriteFrames(CONF.MONSTER2_RUN_PLIST,CONF.MONSTER2_RUN_PNG)
    spriteFrameCache:addSpriteFrames(CONF.MONSTER2_STOP_PLIST,CONF.MONSTER2_STOP_PNG)
    
    self:initHero(spriteFrameCache)
    self:initWeapons(spriteFrameCache)
    self:initMonsters(spriteFrameCache)
    self:initMonsters2(spriteFrameCache)

end


function AnimationManager:initWeapons(spriteFrameCache)
    for i = 0 ,  CONF.WEAPON_DIRECTIONS-1 do
        local frames={}
        for j = 0 , CONF.WEAPON_FRAME_NUM-1 do
            --print(string.format("%s%02d%03d.png",CONF.WEAPON_PREFIX,i,j))
            local frame = spriteFrameCache:getSpriteFrame(string.format("%s%02d%03d.png",CONF.WEAPON_PREFIX,i,j))
            if frame then
                frames[#frames+1] = frame
            end
        end
        --animation = cc.Animation:createWithSpriteFrames(frames,0.08,-1)
        --animation:retain()
        self.weapon[#self.weapon + 1] = frames
    end
end


function AnimationManager:initHero(spriteFrameCache)
    --hero attack
    for i = 0 ,  CONF.HERO_ATTACK_DIRECTIONS-1 do
        local frames={}
        for j = 0 , CONF.HERO_ATTACK_FRAME_NUM-1 do
            local frame = spriteFrameCache:getSpriteFrame(string.format("%s%02d%03d.png",CONF.HERO_ATTACK_PREFIX,i,j))
            if frame then
                frames[#frames+1] = frame
            end
        end
        self.hero_attack[#self.hero_attack + 1] = frames
    end

    --hero run
    for i = 0 ,  CONF.HERO_RUN_DIRECTIONS-1 do
        local frames={}
        for j = 0 , CONF.HERO_RUN_FRAME_NUM-1 do
            local frame = spriteFrameCache:getSpriteFrame(string.format("%s%02d%03d.png",CONF.HERO_RUN_PREFIX,i,j))
            if frame then
                frames[#frames+1] = frame
            end
        end
        --animation = cc.Animation:createWithSpriteFrames(frames,0.08,-1)
        self.hero_run[#self.hero_run + 1 ] = frames
    end

    --hero stand
    for i = 0 ,  CONF.HERO_STOP_DIRECTIONS-1 do
        local frames={}
        for j = 0 , CONF.HERO_STOP_FRAME_NUM-1 do
            local frame = spriteFrameCache:getSpriteFrame(string.format("%s%02d%03d.png",CONF.HERO_STOP_PREFIX,i,j))
            if frame then
                frames[#frames+1] = frame
            end
        end
        --animation = cc.Animation:createWithSpriteFrames(frames,0.1,-1)
        --animation:retain()
        self.hero_stand[#self.hero_stand+1] = frames
    end
end


function AnimationManager:initMonsters(spriteFrameCache)
    -- monster1
    for i = 0 ,  CONF.MONSTER1_DIRECTIONS-1 do
        local frames={}
        for j = 0 , CONF.MONSTER1_FRAME_NUM-1 do
            local frame = spriteFrameCache:getSpriteFrame(string.format("%s%02d%03d.png",CONF.MONSTER1_PREFIX,i,j))
            if frame then
                frames[#frames+1] = frame
            end
        end
        --animation = cc.Animation:createWithSpriteFrames(frames,0.1,-1)
        --animation:retain()
        
        self.monster1[#self.monster1+1 ] =frames
    end

end


function AnimationManager:initMonsters2(spriteFrameCache)
    --monster attack
    for i = 0 ,  CONF.MONSTER2_ATTACK_DIRECTIONS-1 do
        local frames={}
        for j = 0 , CONF.MONSTER2_ATTACK_FRAME_NUM-1 do
            local frame = spriteFrameCache:getSpriteFrame(string.format("%s%02d%03d.png",CONF.MONSTER2_ATTACK_PREFIX,i,j))
            if frame then
                frames[#frames+1] = frame
            end
        end
        self.monster2_attack[#self.monster2_attack + 1] = frames
    end

    --monster2 run
    for i = 0 ,  CONF.MONSTER2_RUN_DIRECTIONS-1 do
        local frames={}
        for j = 0 , CONF.MONSTER2_RUN_FRAME_NUM-1 do
            local frame = spriteFrameCache:getSpriteFrame(string.format("%s%02d%03d.png",CONF.MONSTER2_RUN_PREFIX,i,j))
            if frame then
                frames[#frames+1] = frame
            end
        end
        --animation = cc.Animation:createWithSpriteFrames(frames,0.08,-1)
        self.monster2_run[#self.monster2_run + 1 ] = frames
    end

    --monster2 stand
    for i = 0 ,  CONF.MONSTER2_STOP_DIRECTIONS-1 do
        local frames={}
        for j = 0 , CONF.MONSTER2_STOP_FRAME_NUM-1 do
            local frame = spriteFrameCache:getSpriteFrame(string.format("%s%02d%03d.png",CONF.MONSTER2_STOP_PREFIX,i,j))
            if frame then
                frames[#frames+1] = frame
            end
        end
        --animation = cc.Animation:createWithSpriteFrames(frames,0.1,-1)
        --animation:retain()
        self.monster2_stand[#self.monster2_stand+1] = frames
    end
end

function AnimationManager:getOnceAnimation(animateType , direction)
    
    return self:getAnimation(animateType,direction,1)
end

function AnimationManager:getForeverAnimation(animateType , direction)

    return self:getAnimation(animateType,direction,-1)
end


function AnimationManager:getAnimation(animateType , direction,loops)
    local frames
    local freq=0.08
    
    if animateType == ANIMATION_TYPE.HERO_RUN then
        frames = self.hero_run[direction]
    elseif animateType == ANIMATION_TYPE.HERO_STAND then
        freq = 0.1
        frames =  self.hero_stand[direction]
    elseif animateType == ANIMATION_TYPE.HERO_ATTACK then
        --print("direction:" , direction , "total" , #self.hero_attack)
        if direction > 4 then direction = math.floor(direction/2) end
        frames =  self.hero_attack[direction]
    elseif animateType == ANIMATION_TYPE.MONSTER then
        frames =  self.monster1[direction]
    else
        frames =  self.weapon[direction]
    end
    
    return cc.Animation:createWithSpriteFrames(frames,freq,loops)
end



function AnimationManager:getAnimation_M2(animateType , direction,loops)
    local frames
    local freq=0.08

    if animateType == ANIMATION_TYPE.M2_RUN then
        frames = self.monster2_run[direction]
    elseif animateType == ANIMATION_TYPE.M2_STAND then
        frames = self.monster2_stand[direction]
        freq = 0.1
    else
        frames = self.monster2_attack[direction]
    end

    return cc.Animation:createWithSpriteFrames(frames,freq,loops)

end
