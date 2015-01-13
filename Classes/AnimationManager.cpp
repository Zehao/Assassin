
#include "config.h"
#include "AnimationManager.h"



AnimationManager* AnimationManager::instance = nullptr;

AnimationManager* AnimationManager::getInstance(){

	if (instance == nullptr){
		instance = new AnimationManager();
		if (instance && instance->init()){
			instance->autorelease();
			instance->retain();
		}
		else{
			CC_SAFE_DELETE(instance);
		}
	}
	return instance;

}

bool AnimationManager::init(){


	return true;

}
