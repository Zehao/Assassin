#ifndef __ENTITY_H__
#define __ENTITY_H__

#include "cocos2d.h"
#include "types.h"
using namespace std;
USING_NS_CC;


class Entity : public cocos2d::Sprite{

public:

protected:
	Vec2 _position;
	int _hp;
	bool _isAlive;
	int _damage;
	ENTITY_DIRECTION _direction;
public:
	void attack(Entity* target);

	void setDirection(ENTITY_DIRECTION direction);
	void runAnimation(ANIMATION_TYPE type);

public:
	CREATE_FUNC(Entity);

	static Entity* create(const string& file) ;
	bool init() override;
};


#endif