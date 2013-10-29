module(..., package.seeall)

local TKResourceManager = require ( 'terevaka/TKResourceManager' )
local TKScreen = require ( 'terevaka/TKScreen' )


TKScene = {}

function TKScene:new ( o )
    o = o or {}
    setmetatable ( o, self )
    self.__index = self
    o.viewCache = nil
    return o
end

function TKScene:init ()
    return self
end

function TKScene:handleTouch ( layer, event )
    local props = {layer:getPartition () :propListForPoint ( layer:wndToWorld ( event.wndX, event.wndY ))}
    for i = 1, #props do
        local prop = props [ i ]
        if prop then
            if prop.onTouch then
                return prop:onTouch ( event )
            end
        end
    end
end

-- protocol for Terevaka.TKApplication
function TKScene:getRenderTable ()
    print ( 'Override TKScene:getRenderTable ()' )
    return {}
end

function TKScene:onLoadScene ()
    print ( 'Override TKScene:onLoadScene ()' )
end

function TKScene:onRemoveScene ()
    print ( 'Override TKScene:onRemoveScene ()' )
end

function TKScene:onTouch ( event )
    print ( 'Override TKScene:onTouch ( event ) method' )
end

return TKScene