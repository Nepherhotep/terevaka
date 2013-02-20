module(..., package.seeall)


local TKScreen = require( 'terevaka/TKScreen')
local TKTexturePackerUtil = require( 'terevaka/TKTexturePackerUtil' )

local layoutFileNameCache = {}


function loadTexturePack(packName)
   local modifier, modifierDpi = getModifier(TKScreen.SCREEN_DPI)
   local resourceDir = 'res/drawable-'..modifier..'/'
   local png = resourceDir..packName..'.png'
   local spec = resourceDir..packName..'.lua'
   local pack = {}
   pack.quads, pack.spriteNames = TKTexturePackerUtil.load(spec, png)
   pack.dpi = modifierDpi
   return pack
end

function findLayoutFile(layoutName)
   -- Currently it only forms full path
   -- Searching with prefixes and caching implied in future
   return 'res/layout/'..layoutName..'.lua'
end

function getModifier(dpi)
   if dpi <= 160 then
      return 'mdpi', 160
   else
      return 'xhdpi', 320
   end
end
