module(..., package.seeall)

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

function TKLayer:findPropById ( viewId )
   return self.viewCache [ viewId ]
end

-- override methods
function TKLayer:clear ()
   self.viewCache = {}
   self.layer:clear ()
end

return TKLayer