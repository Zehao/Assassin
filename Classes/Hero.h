#ifndef __HERO_H__
#define __HERO_H__

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
	virtual bool init() override;

};


#endif