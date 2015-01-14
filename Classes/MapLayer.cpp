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

	_accessLayer = _map->getLayer(CONF("MAP_TILE_ACCESS"));
	_bgLayer = _map->getLayer(CONF("MAP_TILE_BG"));

	_entityLayer = _map->getObjectGroup(CONF("MAP_TILE_ENTITY"));
	this->addChild(_map);
	return true;
}



bool MapLayer::isAccessible(const Vec2&  pointA, const Vec2& pointB){
	Vec2 v1 = point2Tile(pointA);
	Vec2 v2 = point2Tile(pointB);
	CCLOG("pointA tile:%f,%f", v1.x, v1.y);
	CCLOG("pointB tile:%f,%f", v2.x, v2.y);
	//auto v = _bgLayer->getTileGIDAt(v1);
	CCLOG("tile gid:%d,%d", _bgLayer->getTileGIDAt(v1), _bgLayer->getTileGIDAt(v2));
	return true;
}

const Vec2& MapLayer::point2Tile(const Vec2& point){
	int x = (int)(point.x / _tileSize.width);
	int y = _resHeight - (int)(point.y / _tileSize.height);
	if (x > 0) x -= 1;
	if (y > 0) y -= 1;
	return Vec2(x, y);
}