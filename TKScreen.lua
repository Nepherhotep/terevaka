module(..., package.seeall)

local math = require('math')

local TKTapEvent = require( 'terevaka/TKTapEvent')

local DEFAULT_DPI = 160
SCREEN_WIDTH = MOAIEnvironment.horizontalResolution or 480
SCREEN_HEIGHT = MOAIEnvironment.verticalResolution or 320
SCREEN_DPI = MOAIEnvironment.screenDpi or DEFAULT_DPI

-- Trunk dpi to prevent stairs-like scaling
if(SCREEN_DPI <= 170 )then
   SCREEN_DPI = 160
end

if((SCREEN_DPI > 300) and (SCREEN_DPI < 340))then
   SCREEN_DPI = 320
end


function viewport(desiredWidth, desiredHeight, scale)
   -- Setup viewport
   local viewport = MOAIViewport.new ()
   viewport:setSize (desiredWidth/scale, desiredHeight/scale)
   viewport:setScale ( desiredWidth, desiredHeight ) 
   viewport:setOffset(-1, -1)
   return viewport
end

function getScreenSize()
   return SCREEN_WIDTH, SCREEN_HEIGHT
end

function getScreenDpi()
   return SCREEN_DPI
end

function pxToDip(x, y, alignRight, alignTop)
   local screenWidth, screenHeight = getScreenSize()
   local scaleFactor = SCREEN_DPI/DEFAULT_DPI
   if alignRight then
      outX = (screenWidth - x)/scaleFactor
   else
      outX = x/scaleFactor
   end
   if alignTop then
      outY = (screenHeight - y)/scaleFactor
   else
      outY = y/scaleFactor
   end
   return outX, outY
end

function dipToPx(x, y, alignRight, alignTop)
   local outX, outY
   local screenWidth, screenHeight = getScreenSize()
   local scaleFactor = SCREEN_DPI/DEFAULT_DPI
   if alignRight then
      outX = screenWidth - x*scaleFactor
   else
      outX = x*scaleFactor
   end
   if alignTop then
      outY = screenHeight - y*scaleFactor
   else
      outY = y*scaleFactor  
   end
   return outX, outY
end

function scaleProp(prop, dpi)
   fromDpi = dpi or DEFAULT_DPI
   prop:setScl( SCREEN_DPI / fromDpi )
end

function subscribeTouches(handleClickOrTouch)
   local scale = MOAIEnvironment.simulatorScale or 1
   if MOAIInputMgr.device.pointer then
      MOAIInputMgr.device.mouseLeft:setCallback(
	 function(isMouseDown)
            if(isMouseDown) then
	       event = TKTapEvent:new()
	       x, y = MOAIInputMgr.device.pointer:getLoc()
	       event.wndX, event.wndY = x, y
	       event.dipX, event.dipY = pxToDip(x*scale, y*scale, false, true)
	       handleClickOrTouch(event)
            end
            -- Do nothing on mouseUp
	 end)
   else
      -- If it isn't a mouse, its a touch screen... or some really weird device.
      MOAIInputMgr.device.touch:setCallback (
	 function ( eventType, idx, x, y, tapCount )
            if eventType == MOAITouchSensor.TOUCH_DOWN then
	       event = TKTapEvent:new()
	       x, y = MOAIInputMgr.device.pointer:getLoc()
	       event.wndX, event.wndY = x, y 
	       event.dipX, event.dipY = pxToDip(x*scale, y*scale, false, true)
	       handleClickOrTouch(event)
            end
	 end)
   end
end
