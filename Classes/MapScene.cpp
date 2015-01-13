#include "MapScene.h"
#include "config.h"

bool MapLayer::init(){
	
	if (!CCLayer::init())
		return false;

	_map = TMXTiledMap::create(MAP_TILE_PATH);
	assert(_map != nullptr);

	_accessLayer = _map->getLayer(MAP_TILE_ACCESS);

	_bgLayer = _map->getLayer(MAP_TILE_BG);
	this->addChild(_map);
}

Scene* MapScene::createScene(){
	Scene *scene = Scene::create();
	Layer* layer = MapScene::create();
	scene->addChild(layer);
	return scene;
}

bool MapScene::init(){
	if (!CCLayer::init())
		return false;
	_mapLayer = MapLayer::create();
	this->addChild(_mapLayer);
}