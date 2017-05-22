function [agentCoord, doorCoord, wallCoord, pileCoord, prefDoor, doorFam,...
	v, rad, doorW, xmax, ymax] = init3(xmax, ymax, nrPeople, doorW,...
	distToCorner)
% This function creates a world, where the two doors are at one corner
% The first door lies in the west wall, the second in the south wall 
%
% INPUT:
% xmax, ymax	... the dimensions of the room
% nrPeople		... how many people it will have in the room 
% doorW			... the width of the doors (doorW(1), west
%					door; doorW(2), southDoor)
% distToCorner	... the distance of the doors form the corner
%					in south-west
%
% OUTPUT:
% agentCoord ... The coordinates of the people. 
% doorCoord  ... The coordinates of the doors (i.e. the middle of the door)
% wallCoord  ... The coordinates of the wall-"people". These are particles,
%                which don't move, thus represent wall-elements.
% prefDoor   ... This gives the currently prefered door of the people, it's
%                a vector with one entry for each person in agentCoord. The
%                index of the value corresponds to the person with the same
%                index in the matrix agentCoord
% v          ... These should be the initial velocities of the people. It
%                should have the same size as agentCoord.
% rad        ... This gives how big persons are.
% doorW      ... For each Door, we need to know its size.
% xmax, ymax ... The dimensions of the room.
% patience   ... This is a parameter, which describes how patience the
%                people are with their door.

%% Parameters
% some parameters for the doors
Deps = 0;
fak = 2;

% the distance between two wall elements
Weps = 0.1;

% the size of the people
peopleRad = 0.75;

%% the room
% boarder walls
pileCoord = [];
doorFam = ones(nrPeople, 2);

% the full walls
northWall = 0:Weps:xmax;
northWall = northWall(:);
northWall = [northWall, ymax * ones(size(northWall))];

eastWall = 0:Weps:ymax;
eastWall = eastWall(:);
eastWall = [xmax * ones(size(eastWall)), eastWall];

% correct the parameters if they are to big.
distToCorner(1) = min(ymax, distToCorner(1));
distToCorner(2) = min(xmax, distToCorner(2));

doorW(1) = min(doorW(1), ymax - distToCorner(1));
doorW(2) = min(doorW(2), xmax - distToCorner(2));

% the construction of the south wall, which includes 
% one door
southLeft = 0:Weps:distToCorner(2); 
southLeft = southLeft(:);
southRight = distToCorner(2) + doorW(2):Weps:xmax;
southRight = southRight(:);
southWall = [southLeft, zeros(size(southLeft));...
	southRight, zeros(size(southRight))];

% the construction of the west wall, which includes 
% one door
westLower = 0:Weps:distToCorner(1); 
westLower = westLower(:);
westUpper = distToCorner(1) + doorW(1):Weps:ymax;
westUpper = westUpper(:);
westWall = [ zeros(size(westLower)), westLower;...
	zeros(size(westUpper)), westUpper];

% put all the walls into one matrix
wallCoord = [northWall; southWall; westWall; eastWall];

% set the doors
doorCoord = [-Deps * doorW(1)/fak, distToCorner(1) + doorW(1)/2; ...
    distToCorner(2) + doorW(2)/2, -Deps * doorW(2)/fak];
doorW = doorW(1:2);

%% People
% place the people
agentCoord = rand(nrPeople,2) .* repmat([xmax, ymax],nrPeople, 1);
prefDoor = ceil(rand(nrPeople,1) .* size(doorCoord,1));



rad = peopleRad * ones(nrPeople,1);
v = zeros(nrPeople, 2);

% test if the people have chosen a valid door
for i = 1:nrPeople
    while (doorW(prefDoor(i)) == 0)  
        prefDoor(i) = ceil(rand(1) * length(doorW));
    end
end

% set value and direction of the initial velocities 
% of the people
for i = 1:nrPeople
    dir = doorCoord(prefDoor(i),:) - agentCoord(i,:);
    v(i,:) = (dir./norm([xmax,ymax])) * norm([15,15]);
end
