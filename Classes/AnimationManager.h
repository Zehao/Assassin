
#ifndef __ANIMATIONMANAGER_H__
#define __ANIMATIONMANAGER_H__
#include "cocos2d.h"

USING_NS_CC;

/**
	�������еĶ�������������ɫ���������
	����ģʽ
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