module(..., package.seeall)

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