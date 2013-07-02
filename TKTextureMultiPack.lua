module(..., package.seeall)

TKTextureMultiPack = {}

function TKTextureMultiPack:new ( o )
   o = o or {}
   setmetatable ( o, self )
   self.__index = self
   return o
end

function TKTextureMultiPack:init ()
   self.texturePacks = {}
   return self
end

function TKTextureMultiPack:addTexturePack ( pack )
   table.insert ( self.texturePacks, pack )
end

function TKTextureMultiPack:getFrameInfo ( frameName )
   for i, pack in ipairs ( self.texturePacks ) do
      if pack.spriteNames [ frameName ] then
	 local frameInfo = {}
	 frameInfo.frameName = frameName
	 frameInfo.quads = pack.quads
	 frameInfo.resourceScaleFactor = pack.resourceScaleFactor
	 frameInfo.index = pack.spriteNames [ frameName ]
	 return frameInfo
      end
   end
end

function TKTextureMultiPack:release ()
   for i, pack in ipairs ( self.texturePacks ) do
      pack.texture:release ()
   end
   self.texturePacks = {}
end

return TKTextureMultiPack