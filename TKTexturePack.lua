module(..., package.seeall)

TKTexturePack = {}

function TKTexturePack:new ( o )
   o = o or {}
   setmetatable ( o, self )
   self.__index = self
   return o
end

function TKTexturePack:init ()
   self.textureTables = {}
   return self
end

function TKTexturePack:addTextureTable ( tbl )
   table.insert ( self.textureTables, tbl )
end

function TKTexturePack:getFrameInfo ( frameName )
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

function TKTexturePack:release ()
   for i, tbl in ipairs ( self.textureTables ) do
      tbl.texture:release ()
   end
   self.textureTables = {}
end

return TKTexturePack