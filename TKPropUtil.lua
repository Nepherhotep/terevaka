module(..., package.seeall)

function flopProp(prop, flipped)
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

function flipProp(prop, flopped)
   local x, y = prop:getScl()
   if flopped then
      if y > 0 then
	 y = -y
      end
   else
      if y < 0 then
	 y =-y 
      end
   end
   prop:setScl(x, y)
end