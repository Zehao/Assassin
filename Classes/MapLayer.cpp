#include "MapLayer.h"
#include "config.h"
#include "Hero.h"


bool MapLayer::init(){

	if (!Layer::init())
		return false;


	/************************************************************************/
	/* map init                                                                     */
	/************************************************************************/

	_map = TMXTiledMap::create(CONF("MAP_TILE_PATH"));
	assert(_map != nullptr);

	_tileSize = _map->getTileSize();
	_resHeight = from_str<int>CONF("RESOLUTION_HEIGHT");
	_resWidth = from_str<int>CONF("RESOLUTION_WIDTH");
	_mapHeight = from_str<int>CONF("MAP_HEIGHT");
	_mapWidth = from_str<int>CONF("MAP_WIDTH");

	_accessLayer = _map->getLayer(CONF("MAP_TILE_ACCESS"));
	assert(_accessLayer != nullptr);
	_accessLayer->setVisible(false);
	
	_bgLayer = _map->getLayer(CONF("MAP_TILE_BG"));
	
	assert(_bgLayer != nullptr);
	_bgLayer->setVisible(true);

	_entityLayer = _map->getObjectGroup(CONF("MAP_TILE_ENTITY"));
	assert(_entityLayer != nullptr);

	this->addChild(_map, LAYER_BG);

	/************************************************************************/
	/* hero init                                                                     */
	/************************************************************************/
	this->setEntities();


	/************************************************************************/
	/* register touch and keyboard events.                                          */
	/************************************************************************/


	/*此层的键盘事件, Layer已经有EventListener的_keyboardListener
	* @see Layer::setKeyboardEnabled
	*/
	this->setKeyboardEnabled(true);
	this->setTouchEnabled(true);

	EventListenerTouchOneByOne* eventListener = EventListenerTouchOneByOne::create();
	eventListener->onTouchBegan = CC_CALLBACK_2(MapLayer::onTouchBegan, this);
	eventListener->onTouchMoved = CC_CALLBACK_2(MapLayer::onTouchMoved, this);
	eventListener->onTouchCancelled = CC_CALLBACK_2(MapLayer::onTouchCancelled, this);
	eventListener->onTouchEnded = CC_CALLBACK_2(MapLayer::onTouchEnded, this);
	_eventDispatcher->addEventListenerWithSceneGraphPriority(eventListener, this);

	_needMove = false;

	this->setViewpointCenter(_hero->getPosition());

	return true;



	return true;
}


void MapLayer::update(float delta){
	if (_needMove == false)
		return;
	CCLOG("CUR POSITION:%f,%f", _delta.curPosition.x, _delta.curPosition.y);
	CCLOG("TAR POSITION:%f,%f", _delta.targetPoint.x, _delta.targetPoint.y);
	if (_delta.isDestination())
	{
		CCLOG("moved");
		_hero->setPosition(_delta.targetPoint);
		_hero->stopAllActions();
		_hero->runAnimation(ANIMATION_TYPE::HERO_STAND);
		this->unscheduleUpdate();
		_needMove = false;
	}
	else{
		auto tp = _delta.getNewPos();
		if (isAccessable(_delta.checkPoint()))
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

bool MapLayer:: isAccessable(const Vec2& point){
	auto tile = point2Tile(point);
	auto gid = _accessLayer->getTileGIDAt(tile);
	if (!gid)
		return false;
	return true;
}

const Vec2& MapLayer::point2Tile(const Vec2& point){
	
	int x = (int)(   ( ORIGIN_POS.x  + point.x)  / _tileSize.width);
	int y = (int)((_mapHeight - ORIGIN_POS.y - point.y) / _tileSize.height);
	return Vec2(x, y);
}

ACCESS_TYPE MapLayer::getAccessType(const Vec2& point){
	auto tile = point2Tile(point);
	auto gid = _accessLayer->getTileGIDAt(tile);
	if (gid == 0)
		return ACCESS_TYPE::ACC_BLOCK;
	Value properties = _map->getPropertiesForGID(gid);
	auto accStr = properties.asValueMap().at("acc").asString();
	if (accStr.compare("1") == 0){
		return ACCESS_TYPE::ACC_FULL;
	}
	else if (accStr.compare("2") == 0)
	{
		return ACCESS_TYPE::ACC_HALF;
	}

	//need to be done
	return ACCESS_TYPE::ACC_MONSTER;
	
}




void MapLayer::setEntities(){
	auto objs = _entityLayer->getObjects();
	log("MapLayer::setEntities()---------obj size-------\n%d", _entityLayer->getObjects().size());
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

}


void MapLayer::onKeyPressed(EventKeyboard::KeyCode keyCode, Event* event){
	typedef EventKeyboard::KeyCode CODE;

	switch (keyCode){
	case CODE::KEY_F:
		break;
	case CODE::KEY_R:
		break;
	default:
		break;
	}

}

void MapLayer::onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event){
	typedef EventKeyboard::KeyCode CODE;

	switch (keyCode){
	case CODE::KEY_F:
		break;
	case CODE::KEY_R:
		CCLOG("R");
		break;
	default:
		break;
	}
}



void MapLayer::setViewpointCenter(const Vec2& point){

	double x = std::max(point.x, (float)_resWidth / 2);
	double y = std::max(point.y, (float)_resHeight / 2);
	x = std::min(x, (float)_mapWidth - _resWidth / 2.0);
	y = std::min(y, (float)_mapHeight - _resHeight / 2.0);

	Vec2 centerOfView = Vec2(_resWidth / 2, _resHeight / 2);

	Vec2 actualPoint(x, y);
	this->setPosition(centerOfView - actualPoint);
}


bool MapLayer::onTouchBegan(Touch *touch, Event *unused_event){
	CCLOG("------------------MapLayer::onTouchBegan------------------");

	auto touchPoint = touch->getLocation();
	touchPoint = convertToNodeSpace(touchPoint);
	auto heroPoint = _hero->getPosition();
	CCLOG("touch point: %f,%f", touchPoint.x, touchPoint.y);

	auto p = _hero->getBoundingBox();

	_needMove = true;
	if (touchPoint.x > p.getMaxX()){
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

	if (_needMove){
		_delta.setPoint(_hero->getPosition(), touchPoint);
		_delta.tileSize = _tileSize;
		_hero->setDirection(_delta.direction);
		_hero->stopAllActions();
		_hero->runAnimation(ANIMATION_TYPE::HERO_RUN);
		this->scheduleUpdate();
	}
	return true;
}

void MapLayer::onTouchMoved(Touch *touch, Event *unused_event){
}
void MapLayer::onTouchEnded(Touch *touch, Event *unused_event){
}
void MapLayer::onTouchCancelled(Touch *touch, Event *unused_event){
}