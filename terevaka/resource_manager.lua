module(..., package.seeall)


local display_helper = require( 'display_helper')
local texturepacker_loader = require( 'util/texturepacker_util' )


function loadSpritePack(packName)
   local modifier, modifierDpi = getModifier(display_helper.getScreenDpi())
   local resourceDir = 'res/drawable-'..modifier..'/'
   local png = resourceDir..packName..'.png'
   local spec = resourceDir..packName..'.lua'
   local pack = {}
   pack.quads, pack.spriteNames = texturepacker_loader.load(spec, png)
   pack.dpi = modifierDpi
   return pack
end


function getModifier(dpi)
   if dpi <= 160 then
      return 'mdpi', 160
   else
      return 'xhdpi', 320
   end
end
