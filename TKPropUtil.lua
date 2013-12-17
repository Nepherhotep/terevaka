module(..., package.seeall)

function flopProp ( prop, flipped )
    local x, y = prop:getScl ()
    if flipped then
        if x > 0 then
            x = -x
        end
    else
        if x < 0 then
            x =-x
        end
    end
    prop:setScl ( x, y )
end

function flipProp ( prop, flopped )
    local x, y = prop:getScl ()
    if flopped then
        if y > 0 then
            y = -y
        end
    else
        if y < 0 then
            y =-y
        end
    end
    prop:setScl ( x, y )
end

function scaleProp ( prop, scaleFactor, scaleFactorY )
    local x, y = prop:getScl ()
    if not scaleFactorY then
        scaleFactorY = scaleFactor
    end
    prop:setScl ( x * scaleFactor, y * scaleFactorY )
end

function replaceProp ( layer, propId, frame, texturePack )
    local prop = layer:findPropById( propId )
    local scaleX, scaleY = prop:getScl ()
    local x, y = prop:getLoc()
    local priority = prop:getPriority ()

    local frameInfo = texturePack:getFrameInfo ( frame )
    local index = frameInfo.index
    local deck = frameInfo.deck
    local resourceScaleFactor = frameInfo.resourceScaleFactor

    local newProp = MOAIProp2D.new ()
    newProp:setDeck ( deck )
    newProp:setIndex ( index )

    newProp:setLoc ( x, y )
    newProp:setScl ( resourceScaleFactor )
    newProp:setPriority ( priority )
    newProp:setScl ( scaleX, scaleY )
    newProp.onTouch = prop.onTouch

    layer:removeProp ( prop )
    layer:insertProp ( newProp )
    layer:cacheView ( propId, newProp )
end
