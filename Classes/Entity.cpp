#include "Entity.h"
#include "AnimationManager.h"

bool Entity::init(){
	this->_direction = ENTITY_DIRECTION::RIGHT_DOWN;
	_hp = 0;
	_isAlive = true;

	return true;
}


void Entity::attack(Entity* target){
	target->_hp -= _damage;
	target->_isAlive = target->_hp <= 0 ? false : true;
}


void Entity::setDirection(ENTITY_DIRECTION direction){
	this->_direction = direction;
}


void Entity::runAnimation(ANIMATION_TYPE type){
	this->runAction(AnimationManager::getInstance()->getAnimate(type, this->_direction));
}


Entity*  Entity::create(const string& file){
	Entity* entity = new Entity();
	if (entity && entity->initWithFile(file)){
		entity->autorelease();
		return entity;
	}
	CC_SAFE_DELETE(entity);
	return nullptr;
}

void Entity::stopAnimation(){
	this->stopAllActions();
}