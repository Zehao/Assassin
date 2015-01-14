
#ifndef __MAPLAYER_H__
#define __MAPLAYER_H__
#include "cocos2d.h"
#include "ui/CocosGUI.h"
#include "Entity.h"
#include "AnimationManager.h"


using namespace ui;
USING_NS_CC;

/*
地图层,置于场景最下面
*/
class MapLayer : public Layer{
private:
	 TMXLayer* _accessLayer;
	 TMXLayer* _bgLayer;
	 TMXTiledMap* _map;
	 TMXObjectGroup* _entityLayer;
public:
	CREATE_FUNC(MapLayer);

	virtual bool init() override;

	TMXObjectGroup* getEntitesLayer(){ return _entityLayer; }
	bool isAccessible(const Vec2&  tile);
};

#endif