#include "MapLayer.h"
#include "config.h"
#include "Hero.h"


bool MapLayer::init(){

	if (!Layer::init())
		return false;

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

	_entityLayer = _map->getObjectGroup(CONF("MAP_TILE_ENTITY"));
	assert(_entityLayer != nullptr);

	//_map->setAnchorPoint(Vec2(0.5, 0.5));
	//CCLOG("%f,%f", _map->getPosition().x, _map->getPosition().y);
	//_map->setPosition(Vec2(_resWidth/2,_resHeight/2));
	this->addChild(_map);
	return true;
}



void MapLayer::setMapPosition(const Vec2& point){
	this->_map->setPosition(point);
}

bool MapLayer::isAccessible(const Vec2&  pointA, const Vec2& pointB){
	Vec2 v1 = point2Tile(pointA);
	Vec2 v2 = point2Tile(pointB);



	if (1){
		Value properties = _map->getPropertiesForGID(_accessLayer->getTileGIDAt(v2));
		CCLOG("acc property:%s", properties.asValueMap().at("acc").asString().c_str());
	}
	else{
		CCLOG("GID == 0 ");
	}
	
	return true;
}

const Vec2& MapLayer::point2Tile(const Vec2& point){
	
	int x = (int)(   ( ORIGIN_POS.x  + point.x)  / _tileSize.width);
	int y = (int)((_mapHeight - ORIGIN_POS.y - point.y) / _tileSize.height);
	return Vec2(x, y);
}