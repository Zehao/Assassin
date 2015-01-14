
#ifndef __INFOLAYER_H__
#define __INFOLAYER_H__
#include "cocos2d.h"
#include "ui/CocosGUI.h"
#include "Entity.h"
#include "AnimationManager.h"
using namespace ui;
USING_NS_CC;

/*
信息层，血条，技能等
*/
class InfoLayer : public Layer{
private:
	LoadingBar* _heroHP;
	LoadingBar* _heroMP;
	LoadingBar* _monsterHP;
	Button* _heroSkill_1;
	Button* _heroSkill_2;

public:
	CREATE_FUNC(InfoLayer);
};

#endif