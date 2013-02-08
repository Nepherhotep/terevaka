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
   
   -- Make graphics smooth
   MOAISim.setStep ( 1 / 60 )
   MOAISim.clearLoopFlags ()
   MOAISim.setLoopFlags ( MOAISim.SIM_LOOP_ALLOW_BOOST )
   MOAISim.setLoopFlags ( MOAISim.SIM_LOOP_LONG_DELAY )
   MOAISim.setBoostThreshold ( 0 )
   
   -- Init viewport
   self.__viewport = TKScreen.viewport(TKScreen.SCREEN_WIDTH, TKScreen.SCREEN_HEIGHT, scale)

   -- Subscribe touches
   self:subscribeTouches()
end

function TKApplication:initWithScene(scene)
   -- User constructor
   self:setupSim()
   self:onCreate()
   self:loadScene(scene)
   self:onStart()
   self:onResume()
end

function TKApplication:loadScene(scene)
   self.currentScene = scene
   for i, layer in ipairs(scene:getLayers()) do
      layer:setViewport(self.__viewport)
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

function TKApplication:onStart()
   -- nothing to do yet
end

function TKApplication:onResume()
  -- nothing to do yet
end

local app
function TKApplication:get()
   if app == nil then
      print('init application first!')
   end
   return app
end

function TKApplication:set(application)
   app = application
end

return TKApplication