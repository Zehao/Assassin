#include "InfoLayer.h"
#include "config.h"
#include "Hero.h"

bool InfoLayer::init(){

	//load info ui


	this->scheduleUpdate();

	return true;
}

//update info of hero and monsters;
void InfoLayer::update(float delta){

}

void InfoLayer::setHero(Hero *hero){

}

void InfoLayer::setMonster(Monster* monster){

}