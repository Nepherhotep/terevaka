module(..., package.seeall)


local TKScreen = require ( 'terevaka/TKScreen' )
local TKTexturePackerUtil = require ( 'terevaka/TKTexturePackerUtil' )
local TKTexturePack = require ( 'terevaka/TKTexturePack' )

local MAX_TEXTURE_PARTS = 10


function loadDrawable ( name, ext )
    local ext = ext or '.png'
    local foundDirs = {}
    local lesserKeys = {}
    local largerKeys = {}
    local sortedKeys = {}
    local screenSize, resourceSize

    -- look for height-based resources
    for i, dir in pairs ( MOAIFileSystem.listDirectories ( 'res' )) do
        local first, last, sub = string.find ( dir, 'drawable[-]h(%d+)px' )
        if sub then
            screenSize = TKScreen.SCREEN_HEIGHT
            local height = tonumber ( sub )
            foundDirs [ sub ] = dir
            if height < screenSize then
                table.insert ( lesserKeys, height )
            else
                table.insert ( largerKeys, height )
            end
        end
    end

    -- look for width-based resources if height-based not found
    if #foundDirs == 0 then
        for i, dir in pairs ( MOAIFileSystem.listDirectories ( 'res' )) do
            local first, last, sub = string.find ( dir, 'drawable[-]w(%d+)px' )
            if sub then
                screenSize = TKScreen.SCREEN_WIDTH
                local width = tonumber ( sub )
                foundDirs [ sub ] = dir
                if width < screenSize then
                    table.insert ( lesserKeys, width )
                else
                    table.insert ( largerKeys, width )
                end
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
    return loadExistingResource ( foundDirs, sortedKeys, screenSize, name, ext )
end

function loadExistingResource ( foundDirs, sortedKeys, screenSize, name, ext )
    for i, key in ipairs ( sortedKeys ) do
        local resourceDir = 'res/' .. foundDirs [ tostring ( key )] .. '/'
        local resourceScaleFactor = screenSize / key

        -- load texture pack
        local path = resourceDir .. name .. '.lua'
        if MOAIFileSystem.checkFileExists ( path ) then
            local drawablePath = resourceDir .. name .. ext
            local textureTable = TKTexturePackerUtil.load ( path, drawablePath )
            textureTable.resourceScaleFactor = resourceScaleFactor
            local multiPack = TKTexturePack:new () :init ()
            multiPack:addTextureTable ( textureTable )
            return multiPack
        end

        -- load multi pack
        local packParts = {}
        local multiPack = TKTexturePack:new () :init ()
        for i = 1, MAX_TEXTURE_PARTS do
            path = resourceDir .. name .. '-part' .. tostring ( i ) .. '.lua'
            local drawablePath = resourceDir .. name .. '-part' .. tostring ( i ) .. ext
            if MOAIFileSystem.checkFileExists ( path ) then
                local textureTable = TKTexturePackerUtil.load ( path, drawablePath )
                textureTable.resourceScaleFactor = resourceScaleFactor
                multiPack:addTextureTable ( textureTable )
            else
                if i > 1 then
                    return multiPack
                else
                    break
                end
            end
        end

        -- load font
        path = resourceDir .. name .. '.fnt'
        if MOAIFileSystem.checkFileExists ( path ) then
            local font = MOAIFont.new ()
            font:loadFromBMFont ( path )
            font.resourceScaleFactor = resourceScaleFactor
            return font
        end

        -- load single texture
        path = resourceDir .. name .. ext
        if MOAIFileSystem.checkFileExists ( path ) then
            local texture = MOAITexture.new ()
            texture:load ( path, MOAIImage.PREMULTIPLY_ALPHA )
            texture.resourceScaleFactor = resourceScaleFactor
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
