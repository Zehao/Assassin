
#ifndef __MAPLAYER_H__
#define __MAPLAYER_H__
#include "cocos2d.h"
#include "ui/CocosGUI.h"
#include "Entity.h"
#include "Hero.h"
#include "Monster.h"

#include "AnimationManager.h"


using namespace ui;
USING_NS_CC;


/************************************************************************/
/* 实体移动信息                                                                     */
/************************************************************************/
class MoveInfo
{
public:
	Vec2 targetPoint;
	Vec2 curPosition;
	float speed;
	float deltaX;
	float deltaY;
	ENTITY_DIRECTION direction;
	Size tileSize;
public:
	MoveInfo() :speed(3){}
	void setPoint(const Vec2& cur, const Vec2& tar) {
		curPosition = cur;
		targetPoint = tar;
		speed = 3;

		double theta = atan(fabs((tar.y - cur.y) / (tar.x - cur.x)));

		deltaX = speed*cos(theta);
		if (tar.x < cur.x)
			deltaX = -deltaX;
		deltaY = speed*sin(theta);
		if (tar.y < cur.y)
			deltaY = -deltaY;

	}
	bool isDestination(){
		if ((curPosition.x - targetPoint.x)*(curPosition.x - targetPoint.x) + (curPosition.y - targetPoint.y)*(curPosition.y - targetPoint.y) <= speed*speed)
		{
			return true;
		}
		return false;
	}

	const Vec2 getNewPos(){
		curPosition.x += deltaX;
		curPosition.y += deltaY;
		return curPosition;
	}

	const Vec2 checkPoint(){
		float x, y;
		float half = tileSize.width / 2;
		x = deltaX < 0 ? curPosition.x - half : curPosition.x + half;
		y = deltaY < 0 ? curPosition.y - half : curPosition.y + half;
		return Vec2(x, y);
	}

};





static const int LAYER_BG = 1;
static const int LAYER_ENTITY = 2;

/*
地图层和实体
*/
class MapLayer : public Layer{

	//map info
private:
	 TMXLayer* _accessLayer;
	 TMXLayer* _bgLayer;
	 TMXTiledMap* _map;
	 TMXObjectGroup* _entityLayer;
	 Size _tileSize;
	 int _resHeight;
	 int _resWidth;

	 int _mapHeight;
	 int _mapWidth;

	 //entity info
private:
	 Entity*_hero;
	 Vector<Entity*> _monsters;

private:
	bool _needMove;
	MoveInfo _delta;

public:
	CREATE_FUNC(MapLayer);

	virtual bool init() override;

public:
	void setViewpointCenter(const Vec2& point);

	void setEntities();

     Vec2 getAccessPoint(const Vec2&  pointA, const Vec2& pointB);

	 bool isAccessable(const Vec2& point);
	 
	 ACCESS_TYPE getAccessType(const Vec2& point);

protected:
	inline const Vec2& point2Tile(const Vec2& point);

public:
	virtual void update(float delta);
	virtual void onKeyPressed(EventKeyboard::KeyCode keyCode, Event* event);
	virtual void onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event);

	virtual bool onTouchBegan(Touch *touch, Event *unused_event);
	virtual void onTouchMoved(Touch *touch, Event *unused_event);
	virtual void onTouchEnded(Touch *touch, Event *unused_event);
	virtual void onTouchCancelled(Touch *touch, Event *unused_event);

};

#endif