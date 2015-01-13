#include "cocos2d.h"

#ifndef __MAPSCENE_H__
#define __MAPSCENE_H__

USING_NS_CC;

enum LAYER_ZORDER{
	LAYER_MAP=1,
	LAYER_INFO,
	LAYER_ENTITY
};

/*
	地图层,置于场景最下面
*/
class MapLayer : public Layer{
private:
	TMXLayer* _accessLayer;
	TMXLayer* _bgLayer;
	TMXTiledMap* _map;

public:
	CREATE_FUNC(MapLayer);
	MapLayer() :_accessLayer(nullptr), _bgLayer(nullptr), _map(nullptr){}
	
	virtual bool init() override;

	bool isAccessible(const Vec2&  tile);
};




class MapScene : public Layer{
private:
	MapLayer* _mapLayer;
public:
	CREATE_FUNC(MapScene);
	static Scene* createScene();
	MapScene() :_mapLayer(nullptr){}
	virtual bool init() override;
};

#endif