
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
public:
	 TMXLayer* _accessLayer;
	 TMXLayer* _bgLayer;
	 TMXTiledMap* _map;
	 TMXObjectGroup* _entityLayer;
	 Size _tileSize;
	 int _resHeight;
	 int _resWidth;

	 int _mapHeight;
	 int _mapWidth;

public:
	CREATE_FUNC(MapLayer);

	virtual bool init() override;
	
	TMXObjectGroup* getEntitesLayer(){ return _entityLayer; }
     Vec2 getAccessPoint(const Vec2&  pointA, const Vec2& pointB);

	 void setMapPosition(const Vec2& point);

protected:
	inline const Vec2& point2Tile(const Vec2& point);
};

#endif