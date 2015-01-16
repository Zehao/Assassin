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

	_mapLayer = MapLayer::create();

	//_mapLayer->setAnchorPoint(Vec2(0.5, 0.5));
	//_mapLayer->setPosition(from_str<int>CONF("RESOLUTION_WIDTH") /2 , from_str<int>CONF("RESOLUTION_HEIGHT") /2 );

	this->addChild(_mapLayer, LAYER_ZORDER::LAYER_MAP);


	_infoLayer = InfoLayer::create();
	this->addChild(_infoLayer, LAYER_INFO);


	_entityLayer = EntityLayer::create();
	_entityLayer->setEntities(_mapLayer->getEntitesLayer());
	this->addChild(_entityLayer, LAYER_ENTITY);

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

	_needMove = false;

	

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
		_mapLayer->setPosition(_delta.targetPoint);
		_entityLayer->getHero()->stopAllActions();
		_entityLayer->getHero()->runAnimation(ANIMATION_TYPE::HERO_STAND);
		this->unscheduleUpdate();
		_needMove = false;
	}
	else{
		_mapLayer->setPosition(_delta.getNewPos());
		CCLOG("moving");
	}
	
	
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

bool MainScene::onTouchBegan(Touch *touch, Event *unused_event){
	CCLOG("ontouchbegan");

	//CCLOG("%f,%f", (touch->getLocation()).x, touch->getLocation().y);
	//CCLOG("%f,%f", (touch->getLocationInView()).x, touch->getLocationInView().y);
	//Vec2 v = Director::getInstance()->convertToGL(touch->getLocationInView());
	//CCLOG("%f,%f", v.x ,v.y);
	auto _hero = _entityLayer->getHero();
	auto touchPoint = touch->getLocation();
	auto heroPoint = _hero->getPosition();

	auto mapPos = _mapLayer->getPosition();

	CCLOG("%f,%f", touchPoint.x, touchPoint.y);

	auto p = _entityLayer->getHero()->getBoundingBox();
	
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


	CCLOG("_delta direction : %d", _delta.direction );

	auto _targetPos = mapPos + heroPoint - touchPoint;
	
	//_targetPos = _mapLayer->getAccessPoint(mapPos, _targetPos);

	Vec2 p1 = _mapLayer->convertToNodeSpace(mapPos);
	Vec2 p2 = _mapLayer->convertToNodeSpace(_targetPos);
	CCLOG("map point : %f, %f",p1.x,p1.y );
	CCLOG("map point : %f, %f", p2.x, p2.y);
	_delta.setPoint(mapPos, _targetPos);

	
	if (_needMove){
		_entityLayer->getHero()->setDirection(_delta.direction);
		_hero->stopAllActions();
		_hero->runAnimation(ANIMATION_TYPE::HERO_RUN);
		this->scheduleUpdate();
	}


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