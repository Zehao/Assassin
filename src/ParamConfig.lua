--window
CONF = {
    FRAME_HEIGHT =  600 ,
    FRAME_WIDTH = 800,
    
    RESOLUTION_HEIGHT = 900,
    RESOLUTION_WIDTH = 1200,
    
    --map
    MAP_HEIGHT = 3000,
    MAP_WIDTH = 4000,
    MAP_TILESIZE = 50,
    MAP_TILE_PATH = "bg/bg1.tmx",
    MAP_TILE_BG = "bg",
    MAP_TILE_ACCESS = "access",
    MAP_TILE_ENTITY = "entity",
    
    --hero
    HERO_STATIC_TEXTURE = "hero/hero_static.png",
    HERO_ATTACK_PREFIX = "0642-3e26809d-",
    HERO_ATTACK_FRAME_NUM = 15,
    HERO_ATTACK_DIRECTIONS = 4,
    HERO_ATTACK_PLIST = "hero/attack.plist",
    HERO_ATTACK_PNG = "hero/attack.png",
    
    HERO_RUN_PREFIX = "2314-f44c3fde-",
    HERO_RUN_FRAME_NUM = 8,
    HERO_RUN_DIRECTIONS = 8,
    HERO_RUN_PLIST = "hero/run.plist",
    HERO_RUN_PNG = "hero/run.png",
    
    HERO_STOP_PREFIX = "1700-af8399b0-",
    HERO_STOP_FRAME_NUM = 7,
    HERO_STOP_DIRECTIONS = 8,
    HERO_STOP_PLIST = "hero/stop.plist",
    HERO_STOP_PNG = "hero/stop.png",
    
    --血量，魔法值，伤害等
    HERO_HP = 800,
    HERO_MP = 500,
    HERO_DAMAGE = 50,
    HERO_DAMAGE_SKILL1 = 100,
    HERO_DAMAGE_SKILL2 = 150,
    HERO_ATTACK_DISTANCE=100,
    --weapon
    WEAPON_PLIST = "hero/weapon.plist",
    WEAPON_PNG = "hero/weapon.png",
    WEAPON_PREFIX = "0012-494dc152-",
    WEAPON_STATIC = "hero/weapon_static.png",
    WEAPON_FRAME_NUM = 8,
    WEAPON_DIRECTIONS = 8,
    
    --monster1
    MONSTER1_STATIC_TEXTURE = "monster/monster1_static.png",
    MONSTER1_PLIST = "monster/monster1.plist",
    MONSTER1_PREFIX = "0968-60b2e461-",
    MONSTER1_PNG = "monster/monster1.png",
    MONSTER1_DIRECTIONS = 4,
    MONSTER1_FRAME_NUM = 7,
    
    MONSTER1_HP = 200,
    MONSTER1_DAMAGE=20,
    
    --monster2
    MONSTER2_STATIC_TEXTURE = "monster/monster2_static.png",
    MONSTER2_ATTACK_PREFIX = "0061-2a44e34d-",
    MONSTER2_ATTACK_FRAME_NUM = 11,
    MONSTER2_ATTACK_DIRECTIONS = 4,
    MONSTER2_ATTACK_PLIST = "monster/monster2_attack.plist",
    MONSTER2_ATTACK_PNG = "monster/monster2_attack.png",

    MONSTER2_RUN_PREFIX = "0078-389845d5-",
    MONSTER2_RUN_FRAME_NUM = 5,
    MONSTER2_RUN_DIRECTIONS = 4,
    MONSTER2_RUN_PLIST = "monster/monster2_run.plist",
    MONSTER2_RUN_PNG = "monster/monster2_run.png",

    MONSTER2_STOP_PREFIX = "0086-3d46505c-",
    MONSTER2_STOP_FRAME_NUM = 10,
    MONSTER2_STOP_DIRECTIONS = 4,
    MONSTER2_STOP_PLIST = "monster/monster2_stand.plist",
    MONSTER2_STOP_PNG = "monster/monster2_stand.png",
    
    MONSTER2_HP = 500,
    MONSTER2_DAMAGE=60,
    
    
    --ui
    UI_HEAD_JSON = "ui/head/hpmp0.ExportJson",
    UI_MONSTER_JSON="ui/MonsterHP/MonsterHP.ExportJson",
    UI_HERO_SKILL_ENABLE="ui/skill/skill.png",
    UI_HERO_SKILL_DISABLE="ui/skill/skill2.png",
    
    UI_SKILL_NAME="SKILL",
    
    
    --layers
    MAP_LAYER_NAME="MapLayer",
    INFO_LAYER_NAME="InfoLayer"
    
}
