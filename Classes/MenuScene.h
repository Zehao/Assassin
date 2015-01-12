

#ifndef __MENU_SCENE_H__
#define __MENU_SCENE_H__

#include "cocos2d.h"

class MenuScene : public cocos2d::Layer
{
public:
	static cocos2d::Scene* createScene();

	virtual bool init();

	// a selector callback
	void menuHelp(cocos2d::Ref* pSender);
	void menuQuit(cocos2d::Ref* pSender);
	void menuNewGame(cocos2d::Ref* pSender);
	void menuSettings(cocos2d::Ref* pSender);


	CREATE_FUNC(MenuScene);
};

#endif
