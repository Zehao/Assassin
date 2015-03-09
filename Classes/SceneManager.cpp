#include "SceneManager.h"
#include "MenuScene.h"
#include "HelpScene.h"
#include "MainScene.h"

SceneManager* SceneManager::instance = nullptr;


SceneManager* SceneManager::getInstance(){

	if (instance == nullptr){
		instance = new SceneManager();
		if ( instance && instance->init() ){
			instance->autorelease();
			instance->retain();
		}
		else{
			CC_SAFE_DELETE(instance);
		}
	}
	return instance;
	
}

bool SceneManager::init(){
	return true;

}

void SceneManager::changeScene(SCENE_TYPE scene, bool isforward){
	Scene *p = nullptr;
	switch (scene)
	{
	case SCENE_MENU:
		p = MenuScene::createScene();
	case SCENE_WIN:
		break;
	case SCENE_FAIL:
		break;
	case SCENE_TOLLGATE:
		p = MainScene::createScene();
		break;
	case SCENE_MENU_HELP:
		p = HelpScene::createScene();
		break;
	default:
		break;
	}

	if (p == nullptr){
		return;
	}

	auto director = Director::getInstance();
	auto current = director->getRunningScene();

	if (current == nullptr){
		director->runWithScene(p);
	}
	else if (isforward){
		director->replaceScene(TransitionMoveInR::create(0.5f, p));
	}
	else
	{
		director->replaceScene(TransitionMoveInL::create(0.5f, p));
	}
	
}