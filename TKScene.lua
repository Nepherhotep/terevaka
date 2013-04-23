module(..., package.seeall)

local TKResourceManager = require('terevaka/TKResourceManager')
local TKScreen = require('terevaka/TKScreen')


function scaleProp(prop, dpi)
   fromDpi = dpi or TKScreen.DEFAULT_DPI
   scale = TKScreen.SCREEN_DPI / fromDpi
   prop:setScl( scale )
end


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
   if params.resource.layout_type == 'elastic' then
      self:fillElasticLayout(params)
   else
      self:fillScalableLayout(params)
   end
end

function TKScene:fillScalableLayout(params)
   if params.texturePack then
      params.deck = params.texturePack.quads
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
   local dpiMultiplier = params.dpiMultiplier or 1
   local resourceDpi = params.resourceDpi or TKScreen.DEFAULT_DPI
   local deck = params.deck
   local index = params.index
   local horizontalOffset

   -- do method
   local scaleFactor = TKScreen.SCREEN_HEIGHT / layout_height
   if params.h_align == 'center' then
      horizontalOffset = (TKScreen.SCREEN_WIDTH - scaleFactor * layout_width)/2
   else
      if params.h_align == 'left' then
	 horizontalOffset = 0
      else
	 horizontalOffset = (TKScreen.SCREEN_WIDTH - scaleFactor * layout_width)
      end
   end

   local prop = MOAIProp2D.new ()

   prop:setDeck(deck)
   prop:setIndex(index)
   if propTable.x_unit == '%' then
      if propTable.align_left then
	 x = horizontalOffset + scaleFactor * layout_width * propTable.x / 100
      else
	 x = horizontalOffset + scaleFactor * layout_width * (100 - propTable.x) / 100
      end
   else
      if propTable.align_left then
	 x = horizontalOffset + scaleFactor * propTable.x
      else
	 x = horizontalOffset + scaleFactor * ( layout_width - propTable.x)
      end
   end
   if propTable.y_unit == '%' then
      if propTable.align_bottom then
	 y = TKScreen.SCREEN_HEIGHT * propTable.y / 100
      else
	 y = TKScreen.SCREEN_HEIGHT * (100 - propTable.y) / 100
      end
   else
      if propTable.align_bottom then
	 y = scaleFactor * propTable.y
      else
	 y = TKScreen.SCREEN_HEIGHT - scaleFactor * propTable.y
      end
   end
   prop:setLoc ( x, y )
   prop:setScl( scaleFactor * TKScreen.DEFAULT_DPI / (resourceDpi * dpiMultiplier) )
   params.layer:insertProp( prop )
   return prop
end

function TKScene:fillElasticLayout(params)
   for i, propTable in ipairs(params.resource.props) do
      params.propTable = propTable
      local prop = self:addProp(params)
      self:cacheView(params.resourceName, params.propTable.uid, prop)
   end
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

function TKScene:addProp(params)
   -- extract params
   local layer = params['layer']
   local propTable = params['propTable']
   local texturePack = params['texturePack']
   local dpiMultiplier = params['dpiMultiplier'] or 1
   local resourceDpi = params['resourceDpi'] or TKScreen.DEFAULT_DPI
   local deck, dpi, index

   -- extract deck, index, dpi depending on resource type - texturePack or single resource
   if texturePack then
      deck = texturePack.quads
      index = texturePack.spriteNames[propTable.name]
      dpi = texturePack.dpi * dpiMultiplier
   else
      deck = params.deck
      index = params.index
      dpi = resourceDpi * dpiMultiplier
   end
   local prop = MOAIProp2D.new ()
   prop:setDeck ( deck )
   prop:setIndex ( index )
   local x, y = TKScreen.dipToPx(propTable.x, propTable.y, not propTable.align_left, not propTable.align_bottom )
   if propTable.x_unit == '%' then
      if propTable.align_left then
	 x = TKScreen.SCREEN_WIDTH * propTable.x / 100
      else
	 x = TKScreen.SCREEN_WIDTH * (100 - propTable.x) / 100
      end
   end
   if propTable.y_unit == '%' then
      if propTable.align_bottom then
	 y = TKScreen.SCREEN_HEIGHT * propTable.y / 100
      else
	 y = TKScreen.SCREEN_HEIGHT * (100 - propTable.y) / 100
      end
   end
   prop:setLoc ( x, y )
   scaleProp( prop, dpi)
   layer:insertProp ( prop )
   return prop
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