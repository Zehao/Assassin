#ifndef __HERO_H__
#define __HERO_H__
#include "types.h"
#include "cocos2d.h"
#include "Entity.h"

class Hero : public Entity{
private:
	int _mp;

public:
	//void runAnimation(ANIMATION_TYPE type) override;
	
public:
	//CREATE_FUNC(Hero);
	Hero();
	Hero(const string& texturePath, int hp, int mp, bool isAlive, int damage, ENTITY_DIRECTION direction);
	virtual bool init() override;

};


#endif