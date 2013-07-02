module(..., package.seeall)


TKFrameInfo = {}

function TKFrameInfo:new ( o )
   o = o or {}
   setmetatable ( o, self )
   self.__index = self
   return o
end

function TKFrameInfo:init ()
   return self
end

return TKFrameInfo