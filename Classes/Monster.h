#ifndef __MONSTER_H__
#define __MONSTER_H__

#include "types.h"
#include "cocos2d.h"
#include "Entity.h"

class Monster : public Entity{
private:

public:
	//void runAnimation(ANIMATION_TYPE type) override;

public:
	//CREATE_FUNC(Hero);
	Monster();
	virtual bool init() override;

};



#endif