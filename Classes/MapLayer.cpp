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
	_bgLayer->setVisible(true);

	_entityLayer = _map->getObjectGroup(CONF("MAP_TILE_ENTITY"));
	assert(_entityLayer != nullptr);

	this->addChild(_map);
	return true;
}



void MapLayer::setMapPosition(const Vec2& point){
	this->_map->setPosition(point);
}

/*
	pointA 起点
	pointB 目标点
	返回应该到达的点
*/
Vec2 MapLayer::getAccessPoint(const Vec2&  pointA, const Vec2& pointB){

	float _delta = _tileSize.width / 2;

	float _len = sqrt((pointA.x - pointB.x)*(pointA.x - pointB.x) + (pointA.y - pointB.y)*(pointA.y - pointB.y));
	double theta = atan(fabs((pointB.y - pointA.y) / (pointB.x - pointA.x)));

	float deltaX = _delta*cos(theta);
	if (pointB.x < pointA.x)
		deltaX = -deltaX;
	float deltaY = _delta*sin(theta);
	if (pointB.y < pointA.y)
		deltaY = -deltaY;
	float dis = 0; 
	Vec2 curPoint(pointA);
	while (_accessLayer->getTileGIDAt(point2Tile(curPoint)) && dis <_len)
	{
		curPoint.x += deltaX;
		curPoint.y += deltaY;
		//Value properties = _map->getPropertiesForGID(tmp);
		//properties.asValueMap().at("acc").asString() == ""
		dis += _delta;
	}
 
	return curPoint;
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
}