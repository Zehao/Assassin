#ifndef __TYPES_H__
#define __TYPES_H__


extern enum class ENTITY_DIRECTION{
	RIGHT_DOWN,
	LEFT_DOWN,
	LEFT_UP,
	RIGHT_UP,
	DOWN,
	LEFT,
	UP,
	RIGHT
};


extern enum class ANIMATION_TYPE{
	HERO_RUN,
	HERO_STAND,
	HERO_ATTACK,
	MONSTER
};


extern enum class ENTITY_STATE{
	STATE_RUN,
	STATE_STAND,
	STATE_FIGHT,
	STATE_DIE,
};

/*
	路径点上的障碍点
	
*/
extern enum class ACCESS_TYPE{
	ACC_BLOCK,   //障碍
	ACC_FULL,      //无障碍
	ACC_HALF,     //半透明障碍
	ACC_MONSTER //怪
};

#endif