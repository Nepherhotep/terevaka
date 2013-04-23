module(..., package.seeall)


local TKScreen = require( 'terevaka/TKScreen')
local TKTexturePackerUtil = require( 'terevaka/TKTexturePackerUtil' )

local layoutFileNameCache = {}
local drawableDirs = {}


function loadTexturePack(packName)
   local drawable = findDrawable(packName, '.png')
   local spec = drawable.resourceDir..packName..'.lua'
   local pack = TKTexturePackerUtil.load(spec, drawable.path)
   pack.dpi = drawable.dpi
   return pack
end

function loadTexture(name, ext)
   local drawable = findDrawable(name, ext)
   texture = MOAITexture.new()
   texture:load(drawable.path, MOAIImage.PREMULTIPLY_ALPHA)
   texture.dpi = drawable.dpi
   return texture
end

function findDrawable(name, ext)
   local ext = ext or '.png'
   local dirs = MOAIFileSystem.listDirectories('res')
   local foundDirs = {}
   local keys = {}
   for i, dir in pairs(MOAIFileSystem.listDirectories('res')) do
      fist, last, sub = string.find(dir, 'drawable[-]h(%d+)px')
      if sub then
	 foundDirs[sub] = dir
	 keys[i] = sub
      end
   end
   table.sort(keys, function(a,b) return a>b end)
   local resourceDir = 'res/'..foundDirs[keys[1]]..'/'
   local path = resourceDir..name..ext
   local dpi = TKScreen.DEFAULT_DPI
   return {path = path, dpi = modifierDpi, resourceDir = resourceDir}
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
