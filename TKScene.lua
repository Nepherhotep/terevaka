module(..., package.seeall)

local TKResourceManager = require('terevaka/TKResourceManager')
local TKScreen = require('terevaka/TKScreen')


function scaleProp(prop, dpi)
   fromDpi = dpi or TKScreen.DEFAULT_DPI
   scale = TKScreen.SCREEN_DPI / fromDpi
   prop:setScl( scale )
end


-- GameScene prototype
TKScene = {}

-- GameScene constructor
function TKScene:new (o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   self.viewCache = nil
   return o
end

function TKScene:fillLayer(params)
   -- Unpack options
   texturePack = params['texturePack']
   resourceName = params['resourceName']
   layer = params['layer']
   self:updateViewCacheTable(resourceName)
   local resourceFile = TKResourceManager.findLayoutFile(resourceName)
   local resource = dofile ( resourceFile )
   if resource.layout_type == 'elastic' then
      self:fillElasticLayout(resourceName, resource, layer, texturePack)
   else
      self:fillScalableLayout(resourceName, resource, layer, texturePack)
   end
end

function TKScene:fillScalableLayout(resourceName, resource, layer, texturePack)
   local scaleFactor = TKScreen.SCREEN_HEIGHT / resource.layout_height
   local deltaX
   if resource.layout_h_align == 'center' then
      deltaX = (TKScreen.SCREEN_WIDTH - scaleFactor * resource.layout_width)/2
   else
      if resource.layout_h_align == 'left' then
	 deltaX = 0
      else
	 deltaX = (TKScreen.SCREEN_WIDTH - scaleFactor * resource.layout_width)
      end
   end

   for i, propTable in ipairs(resource.props) do
      local prop = MOAIProp2D.new ()
      prop:setDeck(texturePack.quads)
      prop:setIndex(texturePack.spriteNames[propTable.name])
      
      if propTable.x_unit == '%' then
	 if propTable.align_left then
	    x = deltaX + scaleFactor * resource.layout_width * propTable.x / 100
	 else
	    x = deltaX + scaleFactor * resource.layout_width * (100 - propTable.x) / 100
	 end
      else
	 if propTable.align_left then
	    x = deltaX + scaleFactor * propTable.x
	 else
	    x = deltaX + scaleFactor * ( resource.layout_width - propTable.x)
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
      prop:setScl( scaleFactor * TKScreen.DEFAULT_DPI / texturePack.dpi)
      layer:insertProp( prop )
      self:cacheView( resourceName, propTable.uid, prop )
   end
end

function TKScene:fillElasticLayout(resourceName, resource, layer, texturePack)
   for i, propTable in ipairs(resource.props) do
      local prop = self:addProp({layer = layer, propTable = propTable, texturePack = texturePack})
      self:cacheView(resourceName, propTable.uid, prop)
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
   local prop = self.layer:getPartition():propForPoint(self.layer:wndToWorld(event.wndX, event.wndY))
   if prop then
      if prop.onTouch then
	 prop:onTouch(event)
      end
   end
end

function TKScene:addProp(params)
   layer = params['layer']
   propTable = params['propTable']
   texturePack = params['texturePack']
   local prop = MOAIProp2D.new ()
   prop:setDeck ( texturePack.quads )
   prop:setIndex ( texturePack.spriteNames[propTable.name] )
   
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
   scaleProp( prop, texturePack.dpi)
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