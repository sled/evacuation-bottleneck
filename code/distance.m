function [ dist ] = distance(pta, ptb) 
% Calculate Distance between Point A (PTA = [x;y]) and Point B (PTB =
% [x;y])
    dist = sqrt((ptb(1) - pta(1))^2 + (ptb(2) - pta(2))^2);

end

