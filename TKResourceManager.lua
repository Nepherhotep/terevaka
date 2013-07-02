module(..., package.seeall)


local TKScreen = require ( 'terevaka/TKScreen' )
local TKTexturePackerUtil = require ( 'terevaka/TKTexturePackerUtil' )
local TKTexturePack = require ( 'terevaka/TKTexturePack' )

local MAX_TEXTURE_PARTS = 10

function loadDrawable ( name, ext )
   local ext = ext or '.png'
   local dirs = MOAIFileSystem.listDirectories ( 'res' )
   local foundDirs = {}
   local lesserKeys = {}
   local largerKeys = {}
   local sortedKeys = {}
   for i, dir in pairs ( MOAIFileSystem.listDirectories ( 'res' )) do
      fist, last, sub = string.find ( dir, 'drawable[-]h(%d+)px' )
      if sub then
	 local height = tonumber ( sub )
	 foundDirs [ sub ] = dir
	 if height < TKScreen.SCREEN_HEIGHT then
	    table.insert ( lesserKeys, height )
	 else
	    table.insert ( largerKeys, height )
	 end
      end
   end
   table.sort ( largerKeys ) -- sort in incrementing order
   table.sort ( lesserKeys, function  ( a, b ) return a < b end ) -- sort in decrementing order
   
   for i, key in ipairs ( largerKeys ) do
      table.insert ( sortedKeys, key )
   end
   for i, key in ipairs ( lesserKeys ) do
      table.insert ( sortedKeys, key )
   end
   return loadExistingResource ( foundDirs, sortedKeys, name, ext )
end

function loadExistingResource ( foundDirs, sortedKeys, name, ext )
   for i, key in ipairs ( sortedKeys ) do
      local resourceDir = 'res/' .. foundDirs [ tostring ( key )] .. '/'
      local resourceScaleFactor = TKScreen.SCREEN_HEIGHT / key
      -- load texture pack
      local path = resourceDir .. name .. '.lua'

      if MOAIFileSystem.checkFileExists ( path ) then
	 local drawablePath = resourceDir .. name .. ext
	 local pack = TKTexturePackerUtil.load ( spec, drawablePath )
	 pack.resourceScaleFactor = resourceScaleFactor
	 
	 local multiPack = TKTexturePack:new () :init ()
	 multiPack:addTextureTable ( pack )
	 return multiPack
      end
      
      -- load multi pack
      local packParts = {}
      
      for i = 1, MAX_TEXTURE_PARTS do
	 local multiPack = TKTexturePack:new () :init ()
	 path = resourceDir .. name .. '-part' .. tostring ( i ) .. '.lua'
	 local drawablePath = resourceDir .. name .. '-part' .. tostring ( i ) .. ext
	 if MOAIFileSystem.checkFileExists ( path ) then
	    local pack = TKTexturePackerUtil.load ( spec, drawablePath )
	    pack.resourceScaleFactor = resourceScaleFactor
	    multiPack:addTextureTable ( pack )
	 else
	    if i > 1 then
	       return multiPack
	    else
	       break
	    end
	 end
      end

      -- load single texture
      path = resourceDir .. name .. ext
      if MOAIFileSystem.checkFileExists ( path ) then
	 local texture = MOAITexture.new ()
	 texture:load ( path, MOAIImage.PREMULTIPLY_ALPHA )
	 texture.resourceScaleFactor = drawable.resourceScaleFactor
	 return texture
      end
   end
end

function findLayoutFile ( layoutName )
   -- Currently it only forms full path
   -- Searching with prefixes and caching implied in future
   return 'res/layout/' .. layoutName .. '.lua'
end

function getModifier ( dpi )
   if dpi <= 160 then
      return 'mdpi', 160
   else
      return 'xhdpi', 320
   end
end
