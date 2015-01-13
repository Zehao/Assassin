
#ifndef __MAPSCENE_H__
#define __MAPSCENE_H__
#include "cocos2d.h"
#include "ui/CocosGUI.h"
#include "Entity.h"

using namespace ui;
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
/*
	信息层，血条，技能等
*/
class InfoLayer : public Layer{
private:
	LoadingBar* _heroHP;
	LoadingBar* _heroMP;
	LoadingBar* _monsterHP;
	Button* _heroSkill_1;
	Button* _heroSkill_2;

public:
	CREATE_FUNC(InfoLayer);
};

/*
	实体层
	
*/
class EntityLayer : public Layer{
private:
	Entity* _hero;
	Vector<Entity*> _monsters;
	virtual bool init() override;

public:
	CREATE_FUNC(EntityLayer);
};


class MapScene : public Layer{
private:
	EntityLayer* _entityLayer;
	MapLayer* _mapLayer;
	InfoLayer* _infoLayer;
public:
	CREATE_FUNC(MapScene);
	static Scene* createScene();
	MapScene() :_mapLayer(nullptr){}
	virtual bool init() override;
};

#endif