
#ifndef __MAINSCENE_H__
#define __MAINSCENE_H__

#include "InfoLayer.h"
#include "MapLayer.h"

#include "cocos2d.h"


enum LAYER_ZORDER{
	LAYER_MAP=1,
	LAYER_INFO,
};

class MainScene : public Layer{
private:
	InfoLayer* _infoLayer;
	MapLayer* _map;

public:
	CREATE_FUNC(MainScene);
	static Scene* createScene();
	virtual bool init() override;

};

#endif