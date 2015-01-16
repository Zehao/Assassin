
#include "config.h"
#include "Hero.h"


Hero::Hero(){
	_hp = from_str<int>CONF("HERO_HP");
	_mp = from_str<int>CONF("HERO_MP");
	_damage  = from_str<int>CONF("HERO_DAMAGE");
	_direction = ENTITY_DIRECTION::RIGHT_DOWN;
	this->initWithFile(CONF("HERO_STATIC_TEXTURE"));
	_isAlive = true;
}

Hero::Hero(const string& texturePath, int hp, int mp, bool isAlive, int damage, ENTITY_DIRECTION direction){
	_hp = hp;
	_mp = mp;
	_damage = damage;
	_direction = direction;
	this->initWithFile(texturePath);
	_isAlive = isAlive;
	_mp = 0;
}

bool Hero::init(){
	if (!Entity::init())
		return false;
	
}