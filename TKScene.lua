module(..., package.seeall)

local TKResourceManager = require('terevaka/TKResourceManager')
local TKScreen = require('terevaka/TKScreen')


-- GameScene prototype
TKScene = {}

-- GameScene constructor
function TKScene:new (o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

function TKScene:fillLayer(layer, resourceName, texturePack)
   local resourceFile = TKResourceManager.findLayoutFile(resourceName)
   local resource = dofile ( resourceFile )
   for i, propTable in ipairs(resource) do
      self:addProp(layer, propTable, texturePack)
   end
end

function TKScene:addProp(layer, propTable, texturePack)
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
   TKScreen.scaleProp( prop, texturePack.dpi)
   layer:insertProp ( prop )
   return prop
end


-- protocol for Terevaka.TKApplication
function TKScene:getLayers()
   print('Override TKScene:getLayers()')
   return {}
end

function TKScene:onSceneLoaded()
   print('Override TKScene:onSceneLoaded()')
end

function TKScene:onTouch(x, y)
   print('Override TKScene:onTouch(x, y) method')
end

return TKScene