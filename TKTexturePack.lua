module(..., package.seeall)

-- GameScene prototype
TKTexturePack = {}

-- GameScene constructor
function TKTexturePack:new (o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

return TKTexturePack