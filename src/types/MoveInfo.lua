-- require("math")

MoveInfo = class("MoveInfo")
MoveInfo.__index = MoveInfo


MoveInfo.curPosition = cc.p(0,0)
MoveInfo.targetPoint = cc.p(0,0)
MoveInfo.speed = 3
MoveInfo.deltaX = 0
MoveInfo.deltaY = 0
MoveInfo.direction = ENTITY_DIRECTION.RIGHT_DOWN
MoveInfo.tileSize = cc.size(0,0)


function MoveInfo:ctor()

end

function MoveInfo:setPoint(cur,tar)
	self.curPosition = cur
	self.targetPoint = tar
	local theta = math.atan(math.abs((tar.y - cur.y) / (tar.x - cur.x) ) )
	
	self.deltaX = self.speed * math.cos(theta)
	if tar.x < cur.x then 
	   self.deltaX = - self.deltaX 
	end
	
	self.deltaY = self.speed * math.sin(theta)
    if tar.y < cur.y then 
        self.deltaY = - self.deltaY 
    end
end


function MoveInfo:isDestination()
    local d1 = (self.curPosition.x - self.targetPoint.x)*(self.curPosition.x - self.targetPoint.x)
    local d2 = (self.curPosition.y - self.targetPoint.y)*(self.curPosition.y - self.targetPoint.y)
    
    if (d1 + d2) < self.speed*self.speed then
        return true
    end
    return false
end

function MoveInfo:getNewPos()
    self.curPosition.x , self.curPosition.y  =self.curPosition.x + self.deltaX , self.curPosition.y + self.deltaY
    return self.curPosition
end


function MoveInfo:checkPoint()
    local x, y 
    local half = self.tileSize.width / 2
    if self.deltaX < 0 then
        x = self.curPosition.x - half
    else
        x = self.curPosition.x + half
    end
    
    if self.deltaY < 0 then
        y = self.curPosition.y - half
    else
        y = self.curPosition.y + half
    end
    return cc.p(x,y)
    
end