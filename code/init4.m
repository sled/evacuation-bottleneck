function [agentCoord, doorCoord, wallCoord, pileCoord, prefDoor, doorFam,...
	v, rad, doorW, xmax, ymax] = init4(xmax, ymax, nrPeople, ...
	doorW, distToCorner, pileNr, pileDist)
% This function creates a world, where the two doors are at one corner
% The first door lies in the west wall, the second in the south wall
% additionally, the doors have piles in front of it.
%
% INPUT:
% xmax, ymax	... the dimensions of the room
% nrPeople		... how many people it will have in the room 
% doorW			... the width of the doors (doorW(1), west
%					door; doorW(2), southDoor)
% distToCorner	... the distance of the doors form the corner
%					in south-west
% pileNr        ... for each door the number of piles in front
% pileDist      ... the distance of the piles from the door (2dim vector)
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

%% Parameters
% some parameters for the doors
Deps = 0;
fak = 2;

% the distance between two wall elements
Weps = 0.1;
Peps = 0.5;

% the size of the people
peopleRad = 0.75;

%% the room
% boarder walls
wallCoord = [];
pileCoord = [];

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

% add the piles
if pileNr(1) > 0
    if pileNr(1) == 1
        westPiles = [pileDist(1), ...
            (doorW(1)/2 + distToCorner(1))'];
    else
        westPiles = [ones(pileNr(1),1) * pileDist(1),...
            ((0:Peps:Peps*(pileNr(1)-1)) + distToCorner(1) + ...
            doorW(1)/2  - Peps*(pileNr(1)-1)/2)'];
    end
    wallCoord = [wallCoord; westPiles];
end

if pileNr(2) > 0
    if pileNr(2) == 1
        westPiles = [(doorW(2)/2 + distToCorner(2))',...
            pileDist(2)];
    else
        westPiles = [((0:Peps:Peps*(pileNr(2)-1)) + distToCorner(2) + ...
            doorW(2)/2  - Peps*(pileNr(2)-1)/2)', ...
            ones(pileNr(2),1) * pileDist(2)];
    end
    wallCoord = [wallCoord; westPiles];
end

% put all the walls into one matrix
wallCoord = [wallCoord; northWall; southWall; westWall; eastWall];

% set the doors
doorCoord = [-Deps * doorW(1)/fak, distToCorner(1) + doorW(1)/2; ...
    distToCorner(2) + doorW(2)/2, -Deps * doorW(2)/fak];
doorW = doorW(1:2);
doorFam = ones(nrPeople, 2);

%% People
% place the people
agentCoord = rand(nrPeople,2) .* repmat([xmax, ymax],nrPeople, 1);
prefDoor = ceil(rand(nrPeople,1) .* 2);
rad = peopleRad * ones(nrPeople,1);
v = zeros(nrPeople, 2);

% test if the people have chosen a valid door
% for i = 1:nrPeople
%     while (doorW(prefDoor(i)) == 0)  
%         prefDoor(i) = ceil(rand(1) * length(doorW));
%     end
% end

% set value and direction of the initial velocities 
% of the people
for i = 1:nrPeople
    dir = doorCoord(prefDoor(i),:) - agentCoord(i,:);
    v(i,:) = (dir./norm([xmax,ymax])) * norm([5,5]);
end
