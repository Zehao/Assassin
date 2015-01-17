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
	加载英雄和怪
	加载血条，技能信息
*/

bool MainScene::init(){

	if (!CCLayer::init())
		return false;

	_map = MapLayer::create();

	this->addChild(_map, LAYER_ZORDER::LAYER_MAP);

	//Info
	_infoLayer = InfoLayer::create();
	this->addChild(_infoLayer, LAYER_INFO);
	
	return true;
}



