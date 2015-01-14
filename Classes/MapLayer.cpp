#include "MapLayer.h"
#include "config.h"
#include "Hero.h"


bool MapLayer::init(){

	if (!Layer::init())
		return false;

	_map = TMXTiledMap::create(CONF("MAP_TILE_PATH"));
	assert(_map != nullptr);

	_accessLayer = _map->getLayer(CONF("MAP_TILE_ACCESS"));

	_bgLayer = _map->getLayer(CONF("MAP_TILE_BG"));

	_entityLayer = _map->getObjectGroup(CONF("MAP_TILE_ENTITY"));
	this->addChild(_map);
}

