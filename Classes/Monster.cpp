#include "Monster.h"
#include "config.h"
#include "Hero.h"


Monster::Monster(){
	_hp = from_str<int>CONF("MONSTER1_HP");
	_damage = from_str<int>CONF("MONSTER1_DAMAGE");
	_direction = (ENTITY_DIRECTION)(rand()%4);
	this->initWithFile(CONF("MONSTER1_STATIC_TEXTURE"));
	_isAlive = true;
}


bool Monster::init(){
	if (!Entity::init())
		return false;

}