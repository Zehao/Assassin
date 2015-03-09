#include "Hero.h"
#include "config.h"
#include "EntityLayer.h"
#include "MapLayer.h"

bool EntityLayer::init(){
	if (!Layer::init())
		return false;

	_hero = Hero::create(CONF("HERO_STATIC_TEXTURE"));
	_hero->setDirection(ENTITY_DIRECTION::RIGHT_DOWN);

	_hero->setPosition(WIN_SIZE.width / 2 + ORIGIN_POS.x, WIN_SIZE.height / 2 + ORIGIN_POS.y + 250 );
	_hero->setScale(1.4);

	_hero->runAnimation(ANIMATION_TYPE::HERO_STAND);
	this->addChild(_hero);


	return true;
}


void EntityLayer::setEntities (TMXObjectGroup* objects){

}
