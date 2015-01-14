#ifndef __ENTITYLAYER_H__
#define __ENTITYLAYER_H__
#include "cocos2d.h"
#include "ui/CocosGUI.h"
#include "Entity.h"
#include "AnimationManager.h"


using namespace ui;
USING_NS_CC;



/*
ʵ���

*/
class EntityLayer : public Layer{
private:
	Entity* _hero;
	Vector<Entity*> _monsters;
	virtual bool init() override;

	

private:
	TMXObjectGroup* _entities;
public:
	CREATE_FUNC(EntityLayer);
	void setEntities(TMXObjectGroup* layer);
	Entity* getHero(){ return _hero; }
};
#endif