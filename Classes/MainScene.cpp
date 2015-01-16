#include "MainScene.h"
#include "config.h"


Scene* MainScene::createScene(){
	Scene *scene = Scene::create();
	Layer* layer = MainScene::create();
	scene->addChild(layer);
	return scene;
}


/*
	主场景初始化：

	加载背景地图
	加载血条，技能信息
	加载英雄和怪

*/

bool MainScene::init(){

	if (!CCLayer::init())
		return false;

	_map = MapLayer::create();

	this->addChild(_map, LAYER_ZORDER::LAYER_MAP);

	//Info
	_infoLayer = InfoLayer::create();
	this->addChild(_infoLayer, LAYER_INFO);

	//Entities
	setEntities(_map->_entityLayer);

	/*此层的键盘事件, Layer已经有EventListener的_keyboardListener
	* @see Layer::setKeyboardEnabled
	*/
	this->setKeyboardEnabled(true);
	this->setTouchEnabled(true);

	EventListenerTouchOneByOne* eventListener = EventListenerTouchOneByOne::create();
	eventListener->onTouchBegan = CC_CALLBACK_2(MainScene::onTouchBegan, this);
	eventListener->onTouchMoved = CC_CALLBACK_2(MainScene::onTouchMoved, this);
	eventListener->onTouchCancelled = CC_CALLBACK_2(MainScene::onTouchCancelled, this);
	eventListener->onTouchEnded = CC_CALLBACK_2(MainScene::onTouchEnded, this);
	_eventDispatcher->addEventListenerWithSceneGraphPriority(eventListener, this);

	_needMove = false;

	this->setViewpointCenter(_hero->getPosition());

	return true;
}




void MainScene::update(float delta){
	if (_needMove == false)
		return;
	CCLOG("CUR POSITION:%f,%f", _delta.curPosition.x, _delta.curPosition.y);
	CCLOG("TAR POSITION:%f,%f", _delta.targetPoint.x, _delta.targetPoint.y);
	if (_delta.isDestination())
	{
		CCLOG("moved");
		_hero ->setPosition(_delta.targetPoint);
		_hero->stopAllActions();
		_hero->runAnimation(ANIMATION_TYPE::HERO_STAND);
		this->unscheduleUpdate();
		_needMove = false;
	}
	else{
		auto tp = _delta.getNewPos();
		if (_map->isAccessable(_delta.checkPoint()))
			_hero->setPosition(tp);
		else{
			_needMove = false;
			_hero->stopAllActions();
			_hero->runAnimation(ANIMATION_TYPE::HERO_STAND);
		}
			
		CCLOG("moving");
	}
	setViewpointCenter(_hero->getPosition());
	
}

void MainScene::onKeyPressed(EventKeyboard::KeyCode keyCode, Event* event){
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

void MainScene::onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event){
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



void MainScene::setViewpointCenter(const Vec2& point){
	
	double x = std::max(point.x, (float)_map->_resWidth / 2);
	double y = std::max(point.y, (float)_map->_resHeight / 2);
	x = std::min(x, (float)_map->_mapWidth - _map->_resWidth / 2.0);
	y = std::min(y, (float)_map->_mapHeight - _map->_resHeight / 2.0);

	Vec2 centerOfView = Vec2(_map->_resWidth / 2, _map->_resHeight / 2);
	
	Vec2 actualPoint(x, y);
	this->setPosition(centerOfView - actualPoint);
}

void MainScene:: setEntities(TMXObjectGroup* layer){
	auto objs = layer->getObjects();
	log("---------obj size-------\n%d", layer->getObjects().size());
	for (int i = 0; i < objs.size(); i++){
		auto currentObj = objs[i].asValueMap();
		
		float x = currentObj.at("x").asFloat();
		float y = currentObj.at("y").asFloat();
		auto heroKey = currentObj.at(string("type")).asString();
		if (heroKey == "hero")
		{
			_hero = new Hero();
			_hero->setScale(1.4);
			_hero->runAnimation(ANIMATION_TYPE::HERO_STAND);
			_hero->setPosition(x, y);
			this->addChild(_hero, LAYER_ENTITY);
		}
		else if (heroKey == "m1")
		{
			auto monster = new Monster();
			monster->setPosition(x, y);
			monster->setScale(1.4);
			monster->runAnimation(ANIMATION_TYPE::MONSTER);
			this->addChild(monster, LAYER_ENTITY);
			_monsters.pushBack(monster);
		}
		else{
			//monster2
		}
		//log("%f,%f", currentObj.at("x").asFloat(), currentObj.at("y").asFloat());


	}
	CCLOG("");

}


bool MainScene::onTouchBegan(Touch *touch, Event *unused_event){
	CCLOG("------------------on touch began------------------");

	auto touchPoint = touch->getLocation();
	touchPoint = convertToNodeSpace(touchPoint);
	auto heroPoint = _hero->getPosition();
	CCLOG("touch point: %f,%f", touchPoint.x, touchPoint.y);

	auto p = _hero->getBoundingBox();

	_needMove = true;
	if (touchPoint.x > p.getMaxX() ){
		if (touchPoint.y > p.getMaxY())
			_delta.direction = ENTITY_DIRECTION::RIGHT_UP;
		else if (touchPoint.y < p.getMinY())
			_delta.direction = ENTITY_DIRECTION::RIGHT_DOWN;
		else
			_delta.direction = ENTITY_DIRECTION::RIGHT;
	}
	else if (touchPoint.x <p.getMinX())
	{
		if (touchPoint.y > p.getMaxY())
			_delta.direction = ENTITY_DIRECTION::LEFT_UP;
		else if (touchPoint.y < p.getMinY())
			_delta.direction = ENTITY_DIRECTION::LEFT_DOWN;
		else
			_delta.direction = ENTITY_DIRECTION::LEFT;
	}
	else{
		if (touchPoint.y > p.getMaxY())
			_delta.direction = ENTITY_DIRECTION::UP;
		else if (touchPoint.y < p.getMinY())
			_delta.direction = ENTITY_DIRECTION::DOWN;
		else
			_needMove = false;
	}

	
	CCLOG("touch point converted:%f,%f", touchPoint.x, touchPoint.y);

	if (_needMove){
		_delta.setPoint(_hero->getPosition(), touchPoint);
		_delta.tileSize = _map->_tileSize;
		_hero->setDirection(_delta.direction);
		_hero->stopAllActions();
		_hero->runAnimation(ANIMATION_TYPE::HERO_RUN);
		this->scheduleUpdate();
	}

	//

	//auto diff = touchPoint - _hero->getPosition();
	//
	////_targetPos = _mapLayer->getAccessPoint(mapPos, _targetPos);

	//Vec2 p1 = _mapLayer->convertToNodeSpace(mapPos);
	//Vec2 p2 = _mapLayer->convertToNodeSpace(_targetPos);
	//CCLOG("map point : %f, %f",p1.x,p1.y );
	//CCLOG("map point : %f, %f", p2.x, p2.y);
	//_delta.setPoint(mapPos, _targetPos);

	//
	//if (_needMove){
	//	_entityLayer->getHero()->setDirection(_delta.direction);
	//	_hero->stopAllActions();
	//	_hero->runAnimation(ANIMATION_TYPE::HERO_RUN);
	//	this->scheduleUpdate();
	//}


	//int centX = from_str<int>CONF("RESOLUTION_HEIGHT") / 2;
	//int centy = from_str<int>CONF("RESOLUTION_WIDTH") / 2;
	//_mapLayer->setPosition(centX - touchPoint.x, centy - touchPoint.y);


	return true;
}

void MainScene::onTouchMoved(Touch *touch, Event *unused_event){
}

void MainScene::onTouchEnded(Touch *touch, Event *unused_event){

}

void MainScene::onTouchCancelled(Touch *touch, Event *unused_event){

}