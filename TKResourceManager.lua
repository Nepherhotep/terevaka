module(..., package.seeall)


local TKScreen = require( 'terevaka/TKScreen')
local TKTexturePackerUtil = require( 'terevaka/TKTexturePackerUtil' )

local layoutFileNameCache = {}


function loadTexturePack(packName)
   local drawable = findDrawable(packName, '.png')
   local spec = drawable.resourceDir..packName..'.lua'
   local pack = TKTexturePackerUtil.load(spec, drawable.path)
   pack.dpi = drawable.dpi
   return pack
end

function loadTexture(name, ext)
   local drawable = findDrawable(name, ext)
   texture = MOAIImage.new()
   texture:load(drawable.path, MOAIImage.PREMULTIPLY_ALPHA)
   texture.dpi = drawable.dpi
   return texture
end

function findDrawable(name, ext)
   local ext = ext or '.png'
   local modifier, modifierDpi = getModifier(TKScreen.SCREEN_DPI)
   local resourceDir = 'res/drawable-'..modifier..'/'
   local drawable = resourceDir..name..ext
   if MOAIFileSystem.checkFileExists(drawable) == false then
      if modifier == 'mdpi' then
	 modifier, modifierDpi = 'xhdpi', 320
      else
	 modifier, modifierDpi = 'mdpi', 160
      end
      resourceDir = 'res/drawable-'..modifier..'/'
      drawable = resourceDir..name..ext
      if MOAIFileSystem.checkFileExists(drawable) == false then
	 print(drawable..' resource not found')
	 -- quit function
	 return nil
      end
   end
   return {path = drawable, dpi = modifierDpi, resourceDir = resourceDir}
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
