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
	·�����ϵ��ϰ���
	
*/
extern enum class ACCESS_TYPE{
	ACC_BLOCK,   //�ϰ�
	ACC_FULL,      //���ϰ�
	ACC_HALF,     //��͸���ϰ�
	ACC_MONSTER //��
};

#endif