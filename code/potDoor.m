function [pot] = potDoor(xp, xq, width, xmax, ymax)
% Potential between an agent  and doors
% The doors are not just a point source, they are
% stretched, so that the the field is computed
% from multiple points,
%
% INPUT:
% xp	... position of an agent. 
% xq	... position of a door middle.
% width	... width of the door xq.
% xmax	... roomwidth in x direction.
% ymax	... roomwidth in y direction.

% initial potential from the door
pot = zeros(2,1);

% describes the how far the points in the stretched
% potential are from each other.
eps = 0.01;

% make the potential field not only from a point.
if (xq(1) >= xmax || xq(1) <= 0)
    yCoords = (0:eps:width)' + xq(2) - width/2;
    iter = [xq(1) * ones(size(yCoords)), yCoords];
else
    xCoords = (0:eps:width)' + xq(1) - width/2;
    iter = [xCoords, xq(2) * ones(size(xCoords))];
end

% iterate over all created points from above
iterSize = size(iter,1);
for i = 1:iterSize
    div = norm(xp - iter(i,:));
    pot(1) = pot(1) + 60 * (div + 4) * (xp(1) - iter(i,1)) / (div *iterSize);        
    pot(2) = pot(2) + 60 * (div + 4) * (xp(2) - iter(i,2)) / (div *iterSize); 
end
