
#ifndef __ANIMATIONMANAGER_H__
#define __ANIMATIONMANAGER_H__
#include "cocos2d.h"

USING_NS_CC;

/**
	管理所有的动画，包括：角色，怪物，技能
	单例模式
*/
class AnimationManager : public Ref{

private:
	SpriteFrameCache* _frameCache;
	Animate* _hero_stand;
	Animate* _hero_run;
	Animate* _hero_attack;



private:
	AnimationManager(){};
	static AnimationManager* instance;
	virtual bool init();




public:
	
	AnimationManager* getInstance();


};




#endif