function [agentCoord, doorCoord, wallCoord, pileCoord, prefDoor, doorFam,...
	v, rad, doorW, xmax, ymax] = init2(xmax, ymax, nrPeople, doorW, doorDist)
% This function gives a room back, which has two doors at one wall,
% the west wall
%
% INPUT:
% xmax, ymax	... the dimensions of the room.
% nrPeople		... how many people it will have in the room.
% doorW			... the width of the doors.
% doorDist		... the distance of between the two doors.
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
% we will have here only two doors. which will be next to each other.
pileCoord = [];
doorFam = ones(nrPeople, 2);

% the full walls
northWall = 0:Weps:xmax;
northWall = northWall(:);
northWall = [northWall, ymax * ones(size(northWall))];

southWall = 0:Weps:xmax;
southWall = southWall(:);
southWall = [southWall, zeros(size(southWall))];

eastWall = 0:Weps:ymax;
eastWall = eastWall(:);
eastWall = [xmax * ones(size(eastWall)), eastWall];

% constuction of the wall, which contains the doors.
doorDist = min(ymax/2, doorDist);
doorW(1) = min(doorW(1), (ymax - doorDist)/2);
doorW(2) = min(doorW(2), (ymax - doorDist)/2);

lower = 0:Weps: ymax/2 - doorW(2) - doorDist/2;
middle = (0:Weps:doorDist) + ymax/2 - doorDist/2;
upper = ymax/2 + doorDist/2 + doorW(1):Weps:ymax;
lower = lower(:); middle = middle(:); upper = upper(:);

westWall = [ zeros(size(lower)), lower; zeros(size(middle)), middle; ...
    zeros(size(upper)), upper];

% put all the walls into one matrix
wallCoord = [northWall; southWall; westWall; eastWall];

%% Doors
doorCoord = [-Deps * doorW(1)/fak, ymax/2 + doorDist/2 + doorW(1)/2; ...
    -Deps * doorW(2)/fak, ymax/2 - doorDist/2 - doorW(2)/2];


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
