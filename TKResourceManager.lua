module(..., package.seeall)


local TKScreen = require( 'terevaka/TKScreen')
local TKTexturePackerUtil = require( 'terevaka/TKTexturePackerUtil' )

local layoutFileNameCache = {}
local drawableDirs = {}


function loadTexturePack(packName)
   local drawable = findDrawable(packName, '.png')
   local spec = drawable.resourceDir..packName..'.lua'
   local pack = TKTexturePackerUtil.load(spec, drawable.path)
   pack.resourceScaleFactor = drawable.resourceScaleFactor
   return pack
end

function loadTexture(name, ext)
   local drawable = findDrawable(name, ext)
   texture = MOAITexture.new()
   texture:load(drawable.path, MOAIImage.PREMULTIPLY_ALPHA)
   texture.resourceScaleFactor = drawable.resourceScaleFactor
   return texture
end

function findDrawable(name, ext)
   local ext = ext or '.png'
   local dirs = MOAIFileSystem.listDirectories('res')
   local foundDirs = {}
   local lesserKeys = {}
   local largerKeys = {}
   for i, dir in pairs(MOAIFileSystem.listDirectories('res')) do
      fist, last, sub = string.find(dir, 'drawable[-]h(%d+)px')
      if sub then
	 local height = tonumber(sub)
	 foundDirs[sub] = dir
	 if height < TKScreen.SCREEN_HEIGHT then
	    table.insert(lesserKeys, height)
	 else
	    table.insert(largerKeys, height)
	 end
      end
   end
   table.sort(largerKeys) -- sort in incrementing order
   table.sort(lesserKeys, function (a, b) return a < b end) -- sort in decrementing order
   
   local resourceHeight
   if #largerKeys > 0 then
      resourceHeight = largerKeys[1]
   else
      resourceHeight = lesserKeys[1]
   end
      
   local resourceDir = 'res/'..foundDirs[tostring(resourceHeight)]..'/'
   local resourceScaleFactor = TKScreen.SCREEN_HEIGHT / resourceHeight
   local path = resourceDir..name..ext
   return {path = path, resourceDir = resourceDir, resourceScaleFactor = resourceScaleFactor}
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
