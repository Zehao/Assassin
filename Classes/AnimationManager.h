
#ifndef __ANIMATIONMANAGER_H__
#define __ANIMATIONMANAGER_H__
#include "cocos2d.h"
#include "types.h"

USING_NS_CC;

/**
	管理所有的动画，包括：角色，怪物，技能
	单例模式
*/

class AnimationManager : public Ref{
public:

private:
	SpriteFrameCache* _frameCache;
	Vector<Animate*> _hero_stand;  //8
	Vector<Animate*> _hero_run;     //8
	Vector<Animate*> _hero_attack; //4
	Vector<Animate*> _monster1;
	/*
	SpriteFrame* _hero_stand_frame;
	SpriteFrame* _hero_run_frame;
	SpriteFrame* _hero_attack_frame;
	*/
private:
	AnimationManager(){};
	static AnimationManager* instance;
	virtual bool init();

public:
	Animate* getAnimate(ANIMATION_TYPE animateType, ENTITY_DIRECTION direction);

	static AnimationManager* getInstance();
	


};




#endif