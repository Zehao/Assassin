#include "Entity.h"


Entity::Entity(){
	_hp = 0;
	_isAlive = true;
}

bool Entity::init(){
	return true;
}


void Entity::attack(Entity* target, int damage){
	target->_hp -= damage;
	target->_isAlive = target->_hp <= 0 ? false : true;
}