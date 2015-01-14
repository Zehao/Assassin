#ifndef __ENTITYLAYER_H__
#define __ENTITYLAYER_H__
#include "cocos2d.h"
#include "ui/CocosGUI.h"
#include "Entity.h"
#include "AnimationManager.h"


using namespace ui;
USING_NS_CC;



/*
ΚµΜε²γ

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

	virtual void onKeyPressed(EventKeyboard::KeyCode keyCode, Event* event);
	virtual void onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event);

	virtual bool onTouchBegan(Touch *touch, Event *unused_event);
	virtual void onTouchMoved(Touch *touch, Event *unused_event);
	virtual void onTouchEnded(Touch *touch, Event *unused_event);
	virtual void onTouchCancelled(Touch *touch, Event *unused_event);

};
#endif