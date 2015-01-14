
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
};

#endif