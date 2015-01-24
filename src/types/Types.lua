


-- 方向
ENTITY_DIRECTION =
    {   RIGHT_DOWN=0,
        LEFT_DOWN=1,
        LEFT_UP=2,
        RIGHT_UP=3,
        DOWN=4,
        LEFT=5,
        UP=6,
        RIGHT=7
     }

     
--动画类型
ANIMATION_TYPE = {
    HERO_RUN=0,
    HERO_STAND=1,
    HERO_ATTACK=2,
    MONSTER=3
}

--实体状态
ENTITY_STATE = {
    STATE_RUN=0,
    STATE_STAND=1,
    STATE_FIGHT=2,
    STATE_DIE=3,
}


--路径点上的障碍点
ACCESS_TYPE = {
    ACC_BLOCK=1,    --障碍
    ACC_FULL=2,     --无障碍
    ACC_HALF=3,     --半透明障碍
    ACC_MONSTER=4   --怪
}

LAYER_ZORDER = {
    MAP = -1,
    ENTITY = 1,
    INFO = 2
}