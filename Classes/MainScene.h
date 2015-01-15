
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

class DeltaPoint
{
public:
	Vec2 targetPoint;
	Vec2 curPosition;
	float speed;
	float deltaX;
	float deltaY;
	ENTITY_DIRECTION direction;
public:
	DeltaPoint(Vec2 cur, Vec2 tar) :curPosition(cur), targetPoint(tar), speed(10){
		deltaX = tar.x - cur.x;
		deltaY = tar.y - cur.y;
	}

	void setPoint(const Vec2& cur, const Vec2& tar) {
		curPosition = cur;
		targetPoint = tar;
		speed = 10;



		double theta = atan((tar.y - cur.y) / (tar.x - cur.x));

		deltaX = speed*cos(theta);
		deltaY = speed*sin(theta);
		
	}
	bool isDestination(){
		if (fabs(curPosition.x - targetPoint.x)<= 2 && fabs(curPosition.y - targetPoint.y) <=2)
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

	DeltaPoint(){}
} ;

class MainScene : public Layer{
private:
	EntityLayer* _entityLayer;
	MapLayer* _mapLayer;
	InfoLayer* _infoLayer;

private:
	bool _needMove;
	DeltaPoint _delta;
public:
	CREATE_FUNC(MainScene);
	static Scene* createScene();
	virtual bool init() override;


	virtual void update(float delta);

	virtual void onKeyPressed(EventKeyboard::KeyCode keyCode, Event* event);
	virtual void onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event);

	virtual bool onTouchBegan(Touch *touch, Event *unused_event);
	virtual void onTouchMoved(Touch *touch, Event *unused_event);
	virtual void onTouchEnded(Touch *touch, Event *unused_event);
	virtual void onTouchCancelled(Touch *touch, Event *unused_event);

	
};

#endif