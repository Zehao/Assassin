
#ifndef __MAINSCENE_H__
#define __MAINSCENE_H__

#include "EntityLayer.h"
#include "InfoLayer.h"
#include "MapLayer.h"

enum LAYER_ZORDER{
	LAYER_MAP=1,
	LAYER_INFO,
	LAYER_ENTITY
};


class MainScene : public Layer{
private:
	EntityLayer* _entityLayer;
	MapLayer* _mapLayer;
	InfoLayer* _infoLayer;
public:
	CREATE_FUNC(MainScene);
	static Scene* createScene();
	virtual bool init() override;




	virtual void onKeyPressed(EventKeyboard::KeyCode keyCode, Event* event);
	virtual void onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event);

	virtual bool onTouchBegan(Touch *touch, Event *unused_event);
	virtual void onTouchMoved(Touch *touch, Event *unused_event);
	virtual void onTouchEnded(Touch *touch, Event *unused_event);
	virtual void onTouchCancelled(Touch *touch, Event *unused_event);


};

#endif