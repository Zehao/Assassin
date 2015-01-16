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


/************************************************************************/
/*坑，多个对象不能 同时 共享同一个Animate对象                                                          
/************************************************************************/
void Entity::runAnimation(ANIMATION_TYPE type){
	Animation* animation = AnimationManager::getInstance()->getAnimate(type, this->_direction)->getAnimation();

	this->runAction(Animate::create(animation));
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