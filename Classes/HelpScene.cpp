#include "HelpScene.h"
#include "SceneManager.h"
#include "cocostudio\CocoStudio.h"
#include "ui/CocosGUI.h"

USING_NS_CC;
using namespace cocostudio;
using namespace ui;

Scene* HelpScene::createScene()
{
    // 'scene' is an autorelease object
    auto scene = Scene::create();
    
    // 'layer' is an autorelease object
	auto layer = HelpScene::create();

    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool HelpScene::init()
{
    if ( !Layer::init() )
    {
        return false;
    }
    
	Size visibleSize = Director::getInstance()->getVisibleSize();

	auto widgets = GUIReader::getInstance()->widgetFromJsonFile("menu/help.json");
	assert(widgets != nullptr);

	auto back = static_cast<Button*>(widgets->getChildByName("Button_back"));
	
	back->addClickEventListener(CC_CALLBACK_1(HelpScene::menuCloseCallback, this));

	this->addChild(widgets);

    
    return true;
}


void HelpScene::menuCloseCallback(Ref* pSender)
{
	SceneManager::getInstance()->changeScene(SCENE_MENU, false);
}
