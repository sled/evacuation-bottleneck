function [ time ] = distance_time(dist, speed) 
% Calculate Travelling Time if we can hold our speed 
    time = dist / sqrt(speed(1)^2 + speed(2)^2);

end
