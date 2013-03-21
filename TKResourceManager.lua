module(..., package.seeall)


local TKScreen = require( 'terevaka/TKScreen')
local TKTexturePackerUtil = require( 'terevaka/TKTexturePackerUtil' )

local layoutFileNameCache = {}


function loadTexturePack(packName)
   local modifier, modifierDpi = getModifier(TKScreen.SCREEN_DPI)
   local resourceDir = 'res/drawable-'..modifier..'/'
   local png = resourceDir..packName..'.png'
   local spec = resourceDir..packName..'.lua'
   if MOAIFileSystem.checkFileExists(spec) == false then
      if modifier == 'mdpi' then
	 modifier, modifierDpi = 'xhdpi', 320
      else
	 modifier, modifierDpi = 'mdpi', 160
      end
      resourceDir = 'res/drawable-'..modifier..'/'
      png = resourceDir..packName..'.png'
      spec = resourceDir..packName..'.lua'
      if MOAIFileSystem.checkFileExists(spec) == false then
	 print(packName..' resource not found')
	 -- quit function
	 return nil
      end
   end
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
