#include "MainScene.h"


Scene* MainScene::createScene(){
	Scene *scene = Scene::create();
	Layer* layer = MainScene::create();
	scene->addChild(layer);
	return scene;
}


/*
	��������ʼ����

	���ر�����ͼ
	����Ѫ����������Ϣ
	����Ӣ�ۺ͹�

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




}