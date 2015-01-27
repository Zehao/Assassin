Weapon=class("Weapon",function(filepath) return cc.Sprite:create(filepath) end)

Weapon.__index = Weapon



function Weapon.create()
    local wp = Weapon.new(CONF.WEAPON_STATIC)
    return wp
end

function Weapon:runAnimation(parameters)
	
end