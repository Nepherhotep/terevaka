module(..., package.seeall)

local TKResourceManager = require('terevaka/TKResourceManager')
local TKScreen = require('terevaka/TKScreen')


TKScene = {}

function TKScene:new (o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   self.viewCache = nil
   return o
end

function TKScene:fillLayer(params)
   -- Unpack options
   self:updateViewCacheTable(params.resourceName)
   local resourceFile = TKResourceManager.findLayoutFile(params.resourceName)
   params.resource = dofile ( resourceFile )
   self:fillScalableLayout(params)
end

function TKScene:fillScalableLayout(params)
   if params.texturePack then
      params.deck = params.texturePack.quads
      params.resourceScaleFactor = params.texturePack.resourceScaleFactor
   end
   params.horizontalOffset = deltaX
   params.layout_width = params.resource.layout_width
   params.layout_height = params.resource.layout_height
   for i, propTable in ipairs(params.resource.props) do
      if params.texturePack then
	 params.index = params.texturePack.spriteNames[propTable.name]
      end
      params.propTable = propTable
      local prop = self:addScalableProp(params)
      self:cacheView( params.resourceName, propTable.uid, prop )
   end
end

function TKScene:addScalableProp(params)
   -- extract params
   local propTable = params.propTable
   local layout_height = params.layout_height
   local layout_width = params.layout_width
   local resourceScaleFactor = params.resourceScaleFactor
   local deck = params.deck
   local index = params.index
   local horizontalOffset
   -- do method
   local scaleFactor = TKScreen.SCREEN_HEIGHT / layout_height
   if propTable.h_align == 'center' then
      horizontalOffset = (TKScreen.SCREEN_WIDTH - scaleFactor * layout_width)/2
   else
      if propTable.h_align == 'left' then
	 horizontalOffset = 0
      else
	 horizontalOffset = (TKScreen.SCREEN_WIDTH - scaleFactor * layout_width)
      end
   end

   local prop = MOAIProp2D.new ()

   prop:setDeck(deck)
   prop:setIndex(index)
   x = horizontalOffset + scaleFactor * propTable.x
   y = scaleFactor * propTable.y
   prop:setLoc ( x, y )
   prop:setScl( resourceScaleFactor )
   if propTable.z_index then
      prop:setPriority( propTable.z_index )
   end
   params.layer:insertProp( prop )
   return prop
end

function TKScene:updateViewCacheTable(resourceName)
   -- Create cache table if it doesn't exist
   if self.viewCache == nil then
      self.viewCache = {}
   end
   if self.viewCache[resourceName] == nil then
      self.viewCache[resourceName] = {}
   end
end

function TKScene:cacheView(resourceName, viewId, view)
   if viewId ~= "" and viewId ~= nil then
      self.viewCache[resourceName][viewId] = view
   end
end

function TKScene:findPropById(layerResourceName, viewId)
   if self.viewCache ~= nil then
      if self.viewCache[layerResourceName] ~= nil then
	 return self.viewCache[layerResourceName][viewId]
      end
   end
   return nil
end

function TKScene:handleTouch(layer, event)
   local prop = layer:getPartition():propForPoint(layer:wndToWorld(event.wndX, event.wndY))
   if prop then
      if prop.onTouch then
	 prop:onTouch(event)
      end
   end
end

function TKScene:clear()
   for i, layer in ipairs(self:getLayers()) do
      layer:clear()
   end
end

-- protocol for Terevaka.TKApplication
function TKScene:getRenderTable()
   print('Override TKScene:getLayers()')
   return {}
end

function TKScene:onLoadScene()
   print('Override TKScene:onLoadScene()')
end

function TKScene:onRemoveScene()
   print('Override TKScene:onRemoveScene()')
end

function TKScene:onTouch(event)
   print('Override TKScene:onTouch(event) method')
end

return TKScene