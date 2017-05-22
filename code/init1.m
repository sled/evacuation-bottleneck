function [agentCoord, doorCoord, wallCoord, pileCoord, prefDoor, doorFam, ...
	v, rad, doorW, xmax, ymax] = init1(xmax, ymax, nrPeople, doorW)
% This function creates a world, where we have four doors, which are 
% located in the middle of all the walls. With:
% - the first door in the north
% - the second door in the south
% - the third door in the east
% - the fourth door in the west
%
% INPUT:
% xmax, ymax	... the dimensions of the room
% nrPeople		... how many people it will have in the room 
% doorw			... the widths of the doors, Must contain four 
%					values. If a value is smaller or equal to 
% 					zero, the door will not be place.
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
Deps = 0;
Weps = 0.1;
peopleRad = 0.75;

%% The room
wallCoord = [];

middlex = xmax/2;
middley = ymax/2;

% test if doorwidths are smaller or equal to the maximum size 
% of the wall, else shrink it to that size
doorW(1) = min(doorW(1), xmax);
doorW(2) = min(doorW(2), xmax);
doorW(3) = min(doorW(3), ymax);
doorW(4) = min(doorW(4), ymax);

% construct the north wall
leftN = (0:Weps:(middlex - doorW(1)/2))';
rightN = (middlex + doorW(1)/2:Weps:xmax)';
northWall = [ leftN, ymax * ones(length(leftN), 1)];
northWall = [northWall; [rightN, ymax * ones(length(rightN), 1)]];

% construct the south wall
leftS = (0:Weps:(middlex - doorW(2)/2))';
rightS = (middlex + doorW(2)/2:Weps:xmax)';
southWall = [ leftS, zeros(length(leftS), 1)];
southWall = [southWall; [rightS, zeros(length(rightS), 1)]];

% construct the east wall
lowerE = (0:Weps:middley - doorW(3)/2)';
upperE = (middley + doorW(3)/2:Weps:ymax)';
eastWall = [xmax * ones(length(lowerE), 1), lowerE];
eastWall = [eastWall; [xmax * ones(length(upperE), 1), upperE]];

% construct the west wall
lowerW = (0:Weps:middley - doorW(4)/2)';
upperW = (middley + doorW(4)/2:Weps:ymax)';
westWall = [zeros(length(lowerW), 1), lowerW];
westWall = [westWall; [zeros(length(upperW), 1), upperW]];

% put all the walls into one matrix
wallCoord = [wallCoord; northWall; southWall; westWall; eastWall];

pileCoord = [];
doorFam = ones(nrPeople, numel(doorW(doorW ~= 0)));
%% Doors
doorCoord = [];
fak = 2;

% set the doors
% if the width of a door is smaller or equal to zero, it will
% not be placed
if (doorW(1) > 0)
	doorCoord = [doorCoord; [middlex, ymax+Deps * doorW(1)/fak]];
end

if (doorW(2) > 0)
	doorCoord = [doorCoord; [middlex, -Deps * doorW(2)/fak]];
end

if (doorW(3) > 0) 
	doorCoord =[doorCoord; [xmax+Deps * doorW(3)/fak, middley]];
end

if (doorW(4) > 0)
	doorCoord =[doorCoord;[-Deps * doorW(4)/fak, middley]];
end
doorW = doorW(doorW > 0);


%% People
% place the people
agentCoord = rand(nrPeople,2) .* repmat([xmax, ymax],nrPeople, 1);
prefDoor = ceil(rand(nrPeople,1) .* size(doorCoord,1));
rad = peopleRad * ones(nrPeople,1);
v = zeros(nrPeople, 2);

% test if the people have chosen a valid door
for i = 1:nrPeople
    while (doorW(prefDoor(i)) == 0)  
        prefDoor(i) = ceil(rand(1) * size(doorCoord,1));
    end
end

% set value and direction of the initial velocities 
% of the people
for i = 1:nrPeople
    dir = doorCoord(prefDoor(i),:) - agentCoord(i,:);
    v(i,:) = (dir./norm([xmax,ymax])) * norm([15,15]);
end

end
