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


	/*此层的键盘事件, Layer已经有EventListener的_keyboardListener
	 * @see Layer::setKeyboardEnabled
	*/
	this->setKeyboardEnabled(true);

	this->setTouchEnabled(true);

	EventListenerTouchOneByOne* eventListener = EventListenerTouchOneByOne::create();
	eventListener->onTouchBegan = CC_CALLBACK_2(EntityLayer::onTouchBegan, this);
	eventListener->onTouchMoved = CC_CALLBACK_2(EntityLayer::onTouchMoved, this);
	eventListener->onTouchCancelled = CC_CALLBACK_2(EntityLayer::onTouchCancelled, this);
	eventListener->onTouchEnded = CC_CALLBACK_2(EntityLayer::onTouchEnded, this);

	_eventDispatcher->addEventListenerWithSceneGraphPriority(eventListener, this);


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


void EntityLayer::onKeyPressed(EventKeyboard::KeyCode keyCode, Event* event){
	typedef EventKeyboard::KeyCode CODE;

	
	switch (keyCode){
	case CODE::KEY_UP_ARROW:
		break;
	case CODE::KEY_DOWN_ARROW:
		break;
	case CODE::KEY_LEFT_ARROW:
		break;
	case CODE::KEY_RIGHT_ARROW:
		break;
	case CODE::KEY_F:
		break;
	case CODE::KEY_R:
		break;
	default:
		break;
	}

}

void EntityLayer::onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event){
	typedef EventKeyboard::KeyCode CODE;



	switch (keyCode){
	case CODE::KEY_UP_ARROW:
		break;
	case CODE::KEY_DOWN_ARROW:
		break;
	case CODE::KEY_LEFT_ARROW:
		break;
	case CODE::KEY_RIGHT_ARROW:
		break;
	case CODE::KEY_F:
		break;
	case CODE::KEY_R:
		CCLOG("R");
		break;
	default:
		break;
	}
}

bool EntityLayer::onTouchBegan(Touch *touch, Event *unused_event){
	CCLOG("ontouchbegan");

	return true;
}

void EntityLayer::onTouchMoved(Touch *touch, Event *unused_event){

}

void EntityLayer::onTouchEnded(Touch *touch, Event *unused_event){

}

void EntityLayer::onTouchCancelled(Touch *touch, Event *unused_event){

}