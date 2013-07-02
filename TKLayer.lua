module(..., package.seeall)

local TKResourceManager = require ( 'terevaka/TKResourceManager' )
local TKScreen = require ( 'terevaka/TKScreen' )


TKLayer = {}

function TKLayer:new ( o )
   o = o or {}
   setmetatable ( o, self )
   self.__index = self
   o:proxyNativeLayer ({ 'setViewport', 'insertProp', 'removeProp', 'getPartition', 'wndToWorld' })
   return o
end

function TKLayer:init ()
   self.viewCache = {}
   self.layer = MOAILayer2D.new ()
   return self
end

function TKLayer:proxyNativeLayer ( methods )
   for i, method in ipairs ( methods ) do
      self.__index [ method ] = function ( self, ... )
	 return self.layer [ method ] ( self.layer, unpack ( arg ))
      end
   end
end

function TKLayer:fill ( params )
   -- Unpack options
   local resourceFile = TKResourceManager.findLayoutFile ( params.resourceName )
   params.resource = dofile ( resourceFile )
   self:fillScalableLayout ( params )
end

function TKLayer:fillScalableLayout ( params )
   if params.texturePack then
      params.deck = params.texturePack.quads
      params.resourceScaleFactor = params.texturePack.resourceScaleFactor
   end
   self.layoutWidth = params.resource.layout_width
   self.layoutHeight = params.resource.layout_height
   for i, propTable in ipairs ( params.resource.props ) do
      if params.texturePack then
	 params.index = params.texturePack.spriteNames [ propTable.name ]
      end
      params.propTable = propTable
      self:addScalableProp ( params )
   end
end

function TKLayer:addScalableProp ( params )
   -- extract params
   local propTable = params.propTable
   local resourceScaleFactor = params.resourceScaleFactor
   local deck = params.deck
   local index = params.index
   local horizontalOffset
   -- do method

   local prop = MOAIProp2D.new ()
   prop:setDeck ( deck )
   prop:setIndex ( index )

   local x, y = self:scaledToAbsolute ( propTable.x, propTable.y, propTable.h_align )

   prop:setLoc ( x, y )
   prop:setScl ( resourceScaleFactor )
   if propTable.z_index then
      prop:setPriority ( propTable.z_index )
   end
   self.layer:insertProp ( prop )
   self:cacheView ( propTable.uid, prop )
   return prop
end

function TKLayer:scaledToAbsolute ( x, y, h_align )
   local scaleFactor = TKScreen.SCREEN_HEIGHT / self.layoutHeight
   if h_align == 'center' then
      horizontalOffset = ( TKScreen.SCREEN_WIDTH - scaleFactor * self.layoutWidth ) / 2
   else
      if h_align == 'left' then
	 horizontalOffset = 0
      else
	 if h_align == 'right' then
	    horizontalOffset = ( TKScreen.SCREEN_WIDTH - scaleFactor * self.layoutWidth )
	 else
	    horizontalOffset = x * ( TKScreen.SCREEN_WIDTH / self.layoutWidth - scaleFactor )
	 end
      end
   end
   x = horizontalOffset + scaleFactor * x
   y = scaleFactor * y
   return x, y
end

function TKLayer:cacheView ( viewId, view )
   if viewId ~= "" and viewId ~= nil then
      self.viewCache [ viewId ] = view
   end
end

function TKLayer:findPropById ( viewId )
   return self.viewCache [ viewId ]
end

function TKLayer:getMOAILayer ()
   return self.layer
end

-- override methods
function TKLayer:clear ()
   self.viewCache = {}
   self.layer:clear ()
end

return TKLayer