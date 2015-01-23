
require("entity.Entity")
require("ParamConfig")

Monster = class("Monster", function(filepath) return Entity.new(filepath) end )

Monster.__index = Monster


function Monster:ctor()
    self.hp = CONF.MONSTER1_HP
    self.damage = CONF.MONSTER1_DAMAGE
end


function Monster.create()
	local monster = Monster.new(CONF.MONSTER1_STATIC_TEXTURE)
	return monster
end

