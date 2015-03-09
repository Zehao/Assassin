
/*
����������
����ͬ�ĳ��������㳡�����л���
*/

#include "cocos2d.h"

USING_NS_CC;

//����ö��
enum SCENE_TYPE{
	SCENE_MENU,        //��ʼ�˵�
	SCENE_TOLLGATE,    //�ؿ�
	SCENE_MENU_HELP, 
	SCENE_MENU_SETTINGS,
	SCENE_WIN,            //ʤ��
	SCENE_FAIL            //ʧ��
	
};

class SceneManager : public Ref{

public:
	static SceneManager* getInstance();
	virtual bool init();
	void changeScene(SCENE_TYPE scene , bool isforward = true);

private:
	static SceneManager* instance;
};