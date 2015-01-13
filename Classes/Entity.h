#ifndef __ENTITY_H__
#define __ENTITY_H__

#include "cocos2d.h"

USING_NS_CC;


class Entity : public cocos2d::Sprite{
private:
	Vec2 _position;
	int _hp;
	bool _isAlive;
public:
	void attack(Entity* target,int damage);

public:
	CREATE_FUNC(Entity);
	Entity();
	bool init() override;
};


#endif