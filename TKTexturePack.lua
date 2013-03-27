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

function TKTexturePack:release()
   self.texture:release()
   self.quads = nil
   self.names = nil
end

return TKTexturePack