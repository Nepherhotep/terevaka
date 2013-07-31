module(..., package.seeall)

local TKLayer = require ( 'terevaka/TKLayer' )
local TKScreen = require ( 'terevaka/TKScreen' )


TKPortraitLayer = TKLayer:new ()


function TKPortraitLayer:absoluteLocFromPropTable ( propTable )
    return self:scaledToAbsolute ( propTable.x, propTable.y, propTable.v_align )
end

function TKPortraitLayer:scaledToAbsolute ( x, y, v_align )
    local scaleFactor = TKScreen.SCREEN_WIDTH / self.layoutWidth
    local verticalOffset
    if v_align == 'center' then
        verticalOffset = ( TKScreen.SCREEN_HEIGHT - scaleFactor * self.layoutHeight ) / 2
    else
        if v_align == 'bottom' then
            verticalOffset = 0
        else
            if v_align == 'top' then
                verticalOffset = ( TKScreen.SCREEN_HEIGHT - scaleFactor * self.layoutHeight )
            else
                verticalOffset = y * ( TKScreen.SCREEN_HEIGHT / self.layoutHeight - scaleFactor )
            end
        end
    end
    x = scaleFactor * x
    y = verticalOffset + scaleFactor * y
    return x, y
end

return TKPortraitLayer