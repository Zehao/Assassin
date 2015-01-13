#include "MapScene.h"
#include "config.h"
#include "Hero.h"

bool MapLayer::init(){
	
	if (!Layer::init())
		return false;

	_map = TMXTiledMap::create(MAP_TILE_PATH);
	assert(_map != nullptr);

	_accessLayer = _map->getLayer(MAP_TILE_ACCESS);

	_bgLayer = _map->getLayer(MAP_TILE_BG);
	this->addChild(_map);
}




bool EntityLayer::init(){
	if (!Layer::init())
		return false;
	_hero = Hero::cre
	this->addChild(_hero);
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
	this->addChild(_mapLayer, LAYER_ZORDER::LAYER_MAP);

	_infoLayer = InfoLayer::create();
	this->addChild(_infoLayer, LAYER_INFO);


	_entityLayer = EntityLayer::create();
	this->addChild(_entityLayer, LAYER_ENTITY);
}