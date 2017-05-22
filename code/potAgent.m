function [pot] = potAgent(xp, xq)
% potential between agents with positions
% xp and xq

pot = zeros(2,1);

div = (xp(1)^2 - 2*xp(1)*xq(1) + xq(1)^2 + ...
       xp(2)^2 - 2*xp(2)*xq(2) + xq(2)^2 )^(3/2);

pot(1) = - 15.84893192 * (xp(1) - xq(1))/ div;        
pot(2) = - 15.84893192 * (xp(2) - xq(2))/ div; 

end
