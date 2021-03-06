module(..., package.seeall)


function load( lua, png )
   local textureTable = {}
   local frames = dofile ( lua ).frames
   textureTable.texture = MOAITexture.new ()
   textureTable.texture:load ( png )

   -- Annotate the frame array with uv quads and geometry rects
   for i, frame in ipairs ( frames ) do
        -- convert frame.uvRect to frame.uvQuad to handle rotation
      local uv = frame.uvRect
      local q = {}
      if not frame.textureRotated then
	 -- From Moai docs: "Vertex order is clockwise from upper left (xMin, yMax)"
	 q.x0, q.y0 = uv.u0, uv.v0
	 q.x1, q.y1 = uv.u1, uv.v0
	 q.x2, q.y2 = uv.u1, uv.v1
	 q.x3, q.y3 = uv.u0, uv.v1
      else
	 -- Sprite data is rotated 90 degrees CW on the texture
	 -- u0v0 is still the upper-left
	 q.x3, q.y3 = uv.u0, uv.v0
	 q.x0, q.y0 = uv.u1, uv.v0
	 q.x1, q.y1 = uv.u1, uv.v1
	 q.x2, q.y2 = uv.u0, uv.v1
      end
      frame.uvQuad = q
      
      -- convert frame.spriteColorRect and frame.spriteSourceSize
      -- to frame.geomRect.  Origin is at x0,y0 of original sprite
      local cr = frame.spriteColorRect
      local r = {}
      r.x0 = cr.x - cr.width/2
      r.y0 = cr.y - cr.height/2
      r.x1 = cr.x + cr.width/2
      r.y1 = cr.y + cr.height/2
      frame.geomRect = r
   end
   
   -- Construct the deck
   textureTable.deck = MOAIGfxQuadDeck2D.new ()
   textureTable.deck:setTexture ( textureTable.texture )
   textureTable.deck:reserve ( #frames )
   local names = {}
   for i, frame in ipairs ( frames ) do
      local q = frame.uvQuad
      local r = frame.geomRect
      names[frame.name] = i
      textureTable.deck:setUVQuad ( i, q.x0,q.y0, q.x1,q.y1, q.x2,q.y2, q.x3,q.y3 )
      textureTable.deck:setRect ( i, r.x0,r.y0, r.x1,r.y1 )
   end
   
   textureTable.spriteNames = names
   return textureTable
end
