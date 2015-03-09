
/*
场景管理器
管理不同的场景，方便场景间切换。
*/

#include "cocos2d.h"

USING_NS_CC;

//场景枚举
enum SCENE_TYPE{
	SCENE_MENU,        //开始菜单
	SCENE_TOLLGATE,    //关卡
	SCENE_MENU_HELP, 
	SCENE_MENU_SETTINGS,
	SCENE_WIN,            //胜利
	SCENE_FAIL            //失败
	
};

class SceneManager : public Ref{

public:
	static SceneManager* getInstance();
	virtual bool init();
	void changeScene(SCENE_TYPE scene , bool isforward = true);

private:
	static SceneManager* instance;
};