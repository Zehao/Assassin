-- require("math")

MoveInfo = class("MoveInfo")
MoveInfo.__index = MoveInfo


MoveInfo.curPosition = cc.p(0,0)
MoveInfo.targetPosition = cc.p(0,0)
MoveInfo.speed = 200
MoveInfo.duration = 0
MoveInfo.distance = 0
MoveInfo.direction = ENTITY_DIRECTION.RIGHT_DOWN

function MoveInfo:ctor()

end

function MoveInfo:setPoint(cur,tar)
	self.curPosition = cc.p(cur.x,cur.y)
    self.targetPosition = cc.p(tar.x,tar.y)
    self.distance = math.sqrt((cur.x- tar.x)*(cur.x- tar.x) + (cur.y- tar.y)*(cur.y- tar.y))
    self.duration = self.distance/self.speed
end

