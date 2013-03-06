module(..., package.seeall)

local TKScreen = require( 'terevaka/TKScreen' )
require( 'math' )

-- TKApplication prototype
TKApplication = {}

-- TKApplication constructor
function TKApplication:new (o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

function TKApplication:setupSim()
   -- Setup sim
   local scale = MOAIEnvironment.simulatorScale or 1
   MOAISim.openWindow ( "test", TKScreen.SCREEN_WIDTH/scale, TKScreen.SCREEN_HEIGHT/scale )
   MOAISim.setListener(MOAISim.EVENT_RESUME, function() self:onResume() end)
   MOAISim.setListener(MOAISim.EVENT_PAUSE, function() self:onPause() end)
   
   -- Make graphics smooth
   MOAISim.setStep ( 1 / 60 )
   MOAISim.clearLoopFlags ()
   MOAISim.setLoopFlags( MOAISim.LOOP_FLAGS_FIXED )
   
   -- Init viewport
   self.viewport = TKScreen.viewport(TKScreen.SCREEN_WIDTH, TKScreen.SCREEN_HEIGHT, scale)

   -- Subscribe touches
   self:subscribeTouches()
end

function TKApplication:initWithScene(scene)
   -- User constructor
   self:setupSim()
   self:onCreate()
   self:loadScene(scene)
   self:onResume()
end

function TKApplication:loadScene(scene)
   self.currentScene = scene
   for i, layer in ipairs(scene:getLayers()) do
      layer:setViewport(self.viewport)
      MOAISim.pushRenderPass ( layer )
   end
   scene:onSceneLoaded()
end

function TKApplication:subscribeTouches()
   TKScreen.subscribeTouches(
      function(x, y)
	 if self.currentScene then
	    self.currentScene:onTouch(x, y)
	 end
      end)
end

function TKApplication:onCreate()
   -- nothing to do yet
end

function TKApplication:onPause()
   -- nothing to do yet
end

function TKApplication:onResume()
  -- nothing to do yet
end

local app
function TKApplication:getSharedApp()
   if app == nil then
      print('init application first!')
   end
   return app
end

function TKApplication:setSharedApp(application)
   app = application
end

return TKApplication