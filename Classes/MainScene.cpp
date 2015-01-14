#include "MainScene.h"


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


	return true;
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

	auto touchPoint = touch->getLocation();
	auto heroPoint = _entityLayer->getHero()->getPosition();
	CCLOG("%f,%f", touchPoint.x, touchPoint.y);
	CCLOG("%f,%f", heroPoint.x, heroPoint.y);
	_mapLayer->isAccessible(heroPoint, touchPoint);
	return true;
}

void MainScene::onTouchMoved(Touch *touch, Event *unused_event){

}

void MainScene::onTouchEnded(Touch *touch, Event *unused_event){

}

void MainScene::onTouchCancelled(Touch *touch, Event *unused_event){

}