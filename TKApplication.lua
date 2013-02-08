module(..., package.seeall)

local messaging = require( 'messaging' )
local display_helper = require( 'display_helper' )
local resource_manager = require( 'resource_manager' )
local math = require( 'math' )
local prop_util = require( 'util/prop_util' )


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
   self.screenWidth, self.screenHeight = display_helper.getScreenSize()
   local scale = MOAIEnvironment.simulatorScale or 1
   MOAISim.openWindow ( "test", self.screenWidth/scale, self.screenHeight/scale )
   
   -- Make graphics smooth
   MOAISim.setStep ( 1 / 60 )
   MOAISim.clearLoopFlags ()
   MOAISim.setLoopFlags ( MOAISim.SIM_LOOP_ALLOW_BOOST )
   MOAISim.setLoopFlags ( MOAISim.SIM_LOOP_LONG_DELAY )
   MOAISim.setBoostThreshold ( 0 )
   
   -- Init viewport
   self.__viewport = display_helper.viewport(self.screenWidth, self.screenHeight, scale)

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
   display_helper.subscribeTouches(
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
function get()
   if app == nil then
      print('init application first!')
   end
   return app
end

function set(application)
   app = application
end

return TKApplication