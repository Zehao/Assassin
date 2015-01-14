
#ifndef __MAPLAYER_H__
#define __MAPLAYER_H__
#include "cocos2d.h"
#include "ui/CocosGUI.h"
#include "Entity.h"
#include "AnimationManager.h"


using namespace ui;
USING_NS_CC;

/*
��ͼ��,���ڳ���������
*/
class MapLayer : public Layer{
private:
	 TMXLayer* _accessLayer;
	 TMXLayer* _bgLayer;
	 TMXTiledMap* _map;
	 TMXObjectGroup* _entityLayer;
	 Size _tileSize;
	 int _resHeight;
	 int _resWidth;
public:
	CREATE_FUNC(MapLayer);

	virtual bool init() override;
	
	TMXObjectGroup* getEntitesLayer(){ return _entityLayer; }
     bool isAccessible(const Vec2&  pointA, const Vec2& pointB);

protected:
	inline const Vec2& point2Tile(const Vec2& point);
};

#endif