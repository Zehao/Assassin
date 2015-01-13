
#include "config.h"
#include "Hero.h"

Hero::Hero(){
	_mp = 0;
}

bool Hero::init(){
	if (!Entity::init())
		return false;
	
}