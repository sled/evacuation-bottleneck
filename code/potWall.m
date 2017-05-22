function [pot] = potWall(xp, xq)
% potential between agent xp and wall-element at xq.
pot = zeros(2,1);

div = (xp(1)^2 - 2*xp(1)*xq(1) + xq(1)^2 + ...
       xp(2)^2 - 2*xp(2)*xq(2) + xq(2)^2 )^(3/2);

pot(1) = - 5 * (xp(1) - xq(1))/ div;        
pot(2) = - 5 * (xp(2) - xq(2))/ div;       
   
