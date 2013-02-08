module(..., package.seeall)


require( 'terevaka/TKScreen')
require( 'terevaka/TKTexturePackerUtil' )


function loadSpritePack(packName)
   local modifier, modifierDpi = getModifier(TKScreen.SCREEN_DPI)
   local resourceDir = 'res/drawable-'..modifier..'/'
   local png = resourceDir..packName..'.png'
   local spec = resourceDir..packName..'.lua'
   local pack = {}
   pack.quads, pack.spriteNames = TKTexturePackerUtil.load(spec, png)
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
