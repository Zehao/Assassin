
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


Animate* AnimationManager::getAnimate(ANIMATION_TYPE animateType, ENTITY_DIRECTION  direction){
	int direct = (int)direction;
	switch (animateType)
	{
	case ANIMATION_TYPE::HERO_RUN:  //8
		return _hero_run.at(direct);
		break;
	case ANIMATION_TYPE::HERO_STAND:  //8 
		return _hero_stand.at(direct);
		break;
	case ANIMATION_TYPE::HERO_ATTACK:  //4
		assert(direct < 4);
		return _hero_attack.at(direct);
		break;
	default:
		break;
	}
}

bool AnimationManager::init(){

	_frameCache = SpriteFrameCache::getInstance();
	_frameCache->addSpriteFramesWithFile(CONF("HERO_ATTACK_PLIST"), CONF("HERO_ATTACK_PNG"));
	_frameCache->addSpriteFramesWithFile(CONF("HERO_RUN_PLIST"), CONF("HERO_RUN_PNG"));
	_frameCache->addSpriteFramesWithFile(CONF("HERO_STOP_PLIST"), CONF("HERO_STOP_PNG"));

	for (int k = 0; k < from_str<int>(CONF("HERO_ATTACK_DIRECTIONS") ); k++){
		Vector<SpriteFrame*> frames;
		for (int i = 0; i <  from_str<int>(CONF("HERO_ATTACK_FRAME_NUM")); i++){
			auto frame = _frameCache->getSpriteFrameByName(StringUtils::format("%s%02d%03d.png", CONF("HERO_ATTACK_PREFIX").c_str(), k, i));
			//log("%s", StringUtils::format("%s%02d%03d.png", CONF("HERO_ATTACK_PREFIX").c_str(), k, i).c_str());
			if (frame)
				frames.pushBack(frame);
		}
		
		_hero_attack.pushBack( Animate::create(Animation::createWithSpriteFrames(frames, 0.08, -1) ) );
	}


	for (int k = 0; k < from_str<int>(CONF("HERO_RUN_DIRECTIONS")); k++){
		Vector<SpriteFrame*> frames;
		for (int i = 0; i < from_str<int>(CONF("HERO_RUN_FRAME_NUM")); i++){
			auto frame = _frameCache->getSpriteFrameByName(StringUtils::format("%s%02d%03d.png", CONF("HERO_RUN_PREFIX").c_str(), k, i) );
			if (frame)
				frames.pushBack(frame);
		}
		_hero_run.pushBack(Animate::create(Animation::createWithSpriteFrames(frames, 0.08, -1)));
	}

	for (int k = 0; k < from_str<int>(CONF("HERO_STOP_DIRECTIONS")) ; k++){
		Vector<SpriteFrame*> frames;
		for (int i = 0; i < from_str<int>(CONF("HERO_STOP_FRAME_NUM")) ; i++){
			auto frame = _frameCache->getSpriteFrameByName(StringUtils::format("%s%02d%03d.png", CONF("HERO_STOP_PREFIX").c_str(), k, i) );
			if (frame)
				frames.pushBack(frame);
		}
		_hero_stand.pushBack(Animate::create(Animation::createWithSpriteFrames(frames, 0.1, -1)));
	}

	return true;

}
