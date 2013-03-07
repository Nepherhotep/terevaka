module(..., package.seeall)


-- Tap event prototype
TKTapEvent = {}

-- Tap event constructor
function TKTapEvent:new (o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

return TKTapEvent