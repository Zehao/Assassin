#include "MenuScene.h"
#include "cocostudio\CocoStudio.h"
#include "SceneManager.h"
#include "ui\CocosGUI.h"

USING_NS_CC;
using namespace cocostudio;
using namespace ui;

Scene* MenuScene::createScene()
{
	auto scene = Scene::create();
	auto layer = MenuScene::create();
	scene->addChild(layer);

	return scene;
}


bool MenuScene::init()
{
	if (!Layer::init())
	{
		return false;
	}

	Size visibleSize = Director::getInstance()->getVisibleSize();

	auto widgets = GUIReader::getInstance()->widgetFromJsonFile("menu/Prestart.ExportJson");

	auto new_game = static_cast<Button *>(widgets->getChildByName("Button_new"));
	auto settings = static_cast<Button *>(widgets->getChildByName("Button_setting") );
	auto help = static_cast<Button *>(widgets->getChildByName("Button_help"));
	auto quit = static_cast<Button *>(widgets->getChildByName("Button_quit"));
	
	help->addClickEventListener(CC_CALLBACK_1(MenuScene::menuHelp,this));


	Vec2 origin = Director::getInstance()->getVisibleSize();

	//widgets->setPosition(origin / 2);

	this->addChild(widgets);


	return true;
}


void MenuScene::menuHelp(Ref* pSender)
{
	SceneManager::getInstance()->changeScene(SCENE_MENU_HELP,true);
}

