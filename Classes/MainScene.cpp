#include "MainScene.h"
#include "config.h"


Scene* MainScene::createScene(){
	Scene *scene = Scene::create();
	Layer* layer = MainScene::create();
	scene->addChild(layer);
	return scene;
}


/*
	��������ʼ����
	���ر�����ͼ
	����Ӣ�ۺ͹�
	����Ѫ����������Ϣ
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



