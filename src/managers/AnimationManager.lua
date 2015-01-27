
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
    self:initHero(spriteFrameCache)
    self:initWeapons(spriteFrameCache)
    self:initMonsters(spriteFrameCache)
end


function AnimationManager:initWeapons(spriteFrameCache)
    for i = 0 ,  CONF.WEAPON_DIRECTIONS-1 do
        local frames={}
        for j = 0 , CONF.WEAPON_FRAME_NUM-1 do
            local frame = spriteFrameCache:getSpriteFrame(string.format("%s%02d%03d.png",CONF.WEAPON_PREFIX,i,j))
            if frame then
                table.insert(frames,frame)
            end
        end
        local animation = cc.Animation:createWithSpriteFrames(frames,0.08,-1)
        animation:retain()
        self.weapon[#self.weapon + 1] = animation
    end
end


function AnimationManager:initHero(spriteFrameCache)
    --hero attack
    for i = 0 ,  CONF.HERO_ATTACK_DIRECTIONS-1 do
        local frames={}
        for j = 0 , CONF.HERO_ATTACK_FRAME_NUM-1 do
            local frame = spriteFrameCache:getSpriteFrame(string.format("%s%02d%03d.png",CONF.HERO_ATTACK_PREFIX,i,j))
            if frame then
                table.insert(frames,frame)
            end
        end
        local animation = cc.Animation:createWithSpriteFrames(frames,0.08,-1)
        animation:retain()
        self.hero_attack[#self.hero_attack + 1] = animation
    end

    --hero run
    for i = 0 ,  CONF.HERO_RUN_DIRECTIONS-1 do
        local frames={}
        for j = 0 , CONF.HERO_RUN_FRAME_NUM-1 do
            local frame = spriteFrameCache:getSpriteFrame(string.format("%s%02d%03d.png",CONF.HERO_RUN_PREFIX,i,j))
            if frame then
                table.insert(frames,frame)
            end
        end
        local animation = cc.Animation:createWithSpriteFrames(frames,0.08,-1)
        animation:retain()
        self.hero_run[#self.hero_run + 1 ] = animation
    end

    --hero stand
    for i = 0 ,  CONF.HERO_STOP_DIRECTIONS-1 do
        local frames={}
        for j = 0 , CONF.HERO_STOP_FRAME_NUM-1 do
            local frame = spriteFrameCache:getSpriteFrame(string.format("%s%02d%03d.png",CONF.HERO_STOP_PREFIX,i,j))
            if frame then
                table.insert(frames,frame)
            end
        end
        local animation = cc.Animation:createWithSpriteFrames(frames,0.1,-1)
        animation:retain()
        self.hero_stand[#self.hero_stand+1] = animation
    end
end


function AnimationManager:initMonsters(spriteFrameCache)
    -- monster1
    for i = 0 ,  CONF.MONSTER1_DIRECTIONS-1 do
        local frames={}
        for j = 0 , CONF.MONSTER1_FRAME_NUM-1 do
            local frame = spriteFrameCache:getSpriteFrame(string.format("%s%02d%03d.png",CONF.MONSTER1_PREFIX,i,j))
            if frame then
                table.insert(frames,frame)
            end
        end
        local animation = cc.Animation:createWithSpriteFrames(frames,0.1,-1)
        animation:retain()
        self.monster1[#self.monster1+1 ] =animation
    end

end


function AnimationManager:getAnimation(animateType , direction)
    if animateType == ANIMATION_TYPE.HERO_RUN then
        return self.hero_run[direction]
    elseif animateType == ANIMATION_TYPE.HERO_STAND then
        return self.hero_stand[direction]
    elseif animateType == ANIMATION_TYPE.HERO_ATTACK then
        return self.hero_attack[direction]
    elseif animateType == ANIMATION_TYPE.MONSTER then
        return self.monster1[direction]
        
    else
        return self.weapon[direction]
    end
    return nil
end
