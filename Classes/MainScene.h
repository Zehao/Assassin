
#ifndef __MAINSCENE_H__
#define __MAINSCENE_H__

#include "InfoLayer.h"
#include "cocos2d.h"
#include "Hero.h"
#include "Monster.h"
#include "MapLayer.h"


enum LAYER_ZORDER{
	LAYER_MAP=1,
	LAYER_INFO,
	LAYER_ENTITY
};

class MoveInfo
{
public:
	Vec2 targetPoint;
	Vec2 curPosition;
	float speed;
	float deltaX;
	float deltaY;
	ENTITY_DIRECTION direction;
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
		if ((curPosition.x - targetPoint.x)*(curPosition.x - targetPoint.x) + (curPosition.y - targetPoint.y)*(curPosition.y - targetPoint.y)  <= speed*speed )
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


} ;

class MainScene : public Layer{
private:
	InfoLayer* _infoLayer;
	Entity*_hero;
	Vector<Entity*> _monsters;

private:
	MapLayer* _map;

private:
	bool _needMove;
	MoveInfo _delta;
public:
	CREATE_FUNC(MainScene);
	static Scene* createScene();
	virtual bool init() override;

	void setViewpointCenter(const Vec2& point);

	void setEntities(TMXObjectGroup* layer);



	virtual void update(float delta);



	virtual void onKeyPressed(EventKeyboard::KeyCode keyCode, Event* event);
	virtual void onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event);

	virtual bool onTouchBegan(Touch *touch, Event *unused_event);
	virtual void onTouchMoved(Touch *touch, Event *unused_event);
	virtual void onTouchEnded(Touch *touch, Event *unused_event);
	virtual void onTouchCancelled(Touch *touch, Event *unused_event);

	
};

#endif