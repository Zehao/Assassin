#include "Hero.h"
#include "config.h"
#include "EntityLayer.h"
#include "MapLayer.h"

bool EntityLayer::init(){
	if (!Layer::init())
		return false;

	_hero = Hero::create(CONF("HERO_STATIC_TEXTURE"));
	_hero->setDirection(ENTITY_DIRECTION::RIGHT_DOWN);

	_hero->setPosition(WIN_SIZE.width / 2 + ORIGIN_POS.x, WIN_SIZE.height / 2 + ORIGIN_POS.y);

	_hero->runAnimation(ANIMATION_TYPE::HERO_STAND);
	this->addChild(_hero);


	return true;
}


void EntityLayer::setEntities (TMXObjectGroup* objects){
	this->_entities = objects;
	auto objs = _entities->getObjects();
	log("---------obj size-------\n%d", _entities->getObjects().size());
	for (int i = 0; i < objs.size(); i++){
		auto currentObj = objs[i].asValueMap();
		//log("%f,%f", currentObj.at("x").asFloat(), currentObj.at("y").asFloat());
		float x = currentObj.at("x").asFloat();
		float y = currentObj.at("y").asFloat();
		
	}

}
