module(..., package.seeall)

function flipProp(prop, flipped)
   local x, y = prop:getScl()
   if flipped then
      if x > 0 then
	 x = -x
      end
   else
      if x < 0 then
	 x =-x 
      end
   end
   prop:setScl(x, y)
end