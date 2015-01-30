
-- 方向
ENTITY_DIRECTION =
    {   RIGHT_DOWN=1,
        LEFT_DOWN=2,
        LEFT_UP=3,
        RIGHT_UP=4,
        DOWN=5,
        LEFT=6,
        UP=7,
        RIGHT=8
     }


ACTION_TAG={
    MOVE = 1,
    CHANGING=2,
}
     
--动画类型
ANIMATION_TYPE = {
    HERO_RUN=1,
    HERO_STAND=2,
    HERO_ATTACK=3,
    MONSTER=4,
    WEAPON=5,
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




