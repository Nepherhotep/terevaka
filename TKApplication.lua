module(..., package.seeall)

local TKScreen = require( 'terevaka/TKScreen' )
require( 'math' )

-- TKApplication prototype
TKApplication = {}

-- TKApplication constructor
function TKApplication:new ( o )
   o = o or {}
   setmetatable ( o, self )
   self.__index = self
   return o
end

function TKApplication:setupSim ()
   -- Setup sim
   local scale = MOAIEnvironment.simulatorScale or 1
   MOAISim.openWindow ( "test", TKScreen.SCREEN_WIDTH/scale, TKScreen.SCREEN_HEIGHT/scale )
   MOAISim.setListener( MOAISim.EVENT_RESUME, function () self:onResume () end )
   MOAISim.setListener( MOAISim.EVENT_PAUSE, function () self:onPause () end )
   
   -- Make graphics smooth
   MOAISim.setStep ( 1 / 60 )
   MOAISim.clearLoopFlags ()
   MOAISim.setLoopFlags( MOAISim.LOOP_FLAGS_FIXED )
   
   -- Init viewport
   self.viewport = TKScreen.viewport( TKScreen.SCREEN_WIDTH, TKScreen.SCREEN_HEIGHT, scale )

   -- Subscribe touches
   self:subscribeTouches ()
end

function TKApplication:initWithScene( scene )
   -- User constructor
   self:setupSim ()
   self:onCreate ()
   self:loadScene ( scene )
   self:onResume()
end

function TKApplication:loadScene ( scene )
   self.currentScene = scene
   for i, layer in pairs ( scene:getRenderTable ()) do
      layer:setViewport ( self.viewport )
   end
   MOAIRenderMgr.setRenderTable ( scene:getRenderTable ())
   scene:onLoadScene ()
end

function TKApplication:replaceScene ( scene )
   self.currentScene:onRemoveScene ()
   self:loadScene ( scene )
end

function TKApplication:subscribeTouches ()
   TKScreen.subscribeTouches (
      function ( dipX, dipY, rawX, rawY )
	 if self.currentScene then
	    self.currentScene:onTouch ( dipX, dipY, rawX, rawY )
	 end
      end )
end

function TKApplication:onCreate ()

end

function TKApplication:onPause ()

end

function TKApplication:onResume ()

end

local app

function TKApplication:getSharedApp ()
   if app == nil then
      print('init application first!')
   end
   return app
end

function TKApplication:setSharedApp ( application )
   app = application
end

return TKApplication