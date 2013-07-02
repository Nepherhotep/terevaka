module(..., package.seeall)

TKTextureMultiPack = {}

function TKTextureMultiPack:new ( o )
   o = o or {}
   setmetatable ( o, self )
   self.__index = self
   return o
end

function TKTextureMultiPack:init ()
   self.textureTables = {}
   return self
end

function TKTextureMultiPack:addTextureTable ( pack )
   table.insert ( self.textureTables, pack )
end

function TKTextureMultiPack:getFrameInfo ( frameName )
   for i, tbl in ipairs ( self.textureTables ) do
      if tbl.spriteNames [ frameName ] then
	 local frameInfo = {}
	 frameInfo.frameName = frameName
	 frameInfo.quads = tbl.quads
	 frameInfo.resourceScaleFactor = tbl.resourceScaleFactor
	 frameInfo.index = tbl.spriteNames [ frameName ]
	 return frameInfo
      end
   end
end

function TKTextureMultiPack:release ()
   for i, tbl in ipairs ( self.textureTables ) do
      tbl.texture:release ()
   end
   self.textureTables = {}
end

return TKTextureMultiPack