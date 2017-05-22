function [agentCoord, doorCoord, wallCoord, pileCoord, prefDoor, doorFam,...
	v, rad, doorW, xmax, ymax] = init5(xmax, ymax, nrPeople, doorW,...
	distToCorner, pileNr, pileDist)
% This function creates a room with doors and piles
% The doors are specified in a CSV file called "doors.csv" 
% The piles are specified in a CSV file called "piles.csv"
%
% INPUT:
% xmax, ymax	... the dimensions of the room
% nrPeople		... how many people it will have in the room 
% doorW         ... has no further use anymore
% distToCorner  ... has no further use anymore
% pileNr        ... has no further use anymore
% pileDist      ... has no further use anymore
%
% OUTPUT:
% agentCoord ... The coordinates of the people. 
% doorCoord  ... The coordinates of the doors (i.e. the middle of the door)
% wallCoord  ... The coordinates of the wall-"people". These are particles,
%                which don't move, thus represent wall-elements.
%                This matrix also contains the coordinates of the piles in 
%                the first column
% pileCoord  ... The explicit coordinates of the piles (middle of the pile)
% prefDoor   ... This gives the currently prefered door of the people, it's
%                a vector with one entry for each person in agentCoord. The
%                index of the value corresponds to the person with the same
%                index in the matrix agentCoord
% doorFam    ... Stores information about every agent. Tells us which doors
%                an agent is familiar to.
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

% the size of the people
peopleRad = 0.75;

%% the room
% boarder walls
piles = [];

% get coordinates from CSV file
doors       = csvread('doors.csv');
%piles       = csvread('piles.csv');


% the full walls

% the construction of the north wall
northWall = 0:Weps:xmax;
northWall = northWall(:);
northWall = [northWall, ymax * ones(size(northWall))];

% the construction of the east wall
eastWall = 0:Weps:ymax;
eastWall = eastWall(:);
eastWall = [xmax * ones(size(eastWall)), eastWall];


% the construction of the south wall
southWall = 0:Weps:xmax; 
southWall = southWall(:);
southWall = [southWall, 0 * ones(size(southWall)) ];

% the construction of the west wall
westWall = 0:Weps:ymax; 
westWall = westWall(:);
westWall = [0 * ones(size(westWall)), westWall];


% place doors into wall

% hold door widths (capacities)
doorW = [];
% hold door coordinates
doorCoord = [];

% loop through all doors
for i=1:size(doors, 1)

    % position
	cDoorX	= doors(i, 1);
	cDoorY	= doors(i, 2);
    
    % capacity
	cDoorW	= doors(i, 3);
	
	if cDoorX == 0 
		% west wall
		startY	= (cDoorY - (cDoorW / 2));
		endY	= (cDoorY + (cDoorW / 2));

        % cut the door out of the wall
		westWall = [westWall(1:(startY/Weps),:);...
		westWall((endY/Weps):size(westWall),:)];
	end

	if cDoorX == xmax
		% east wall
		startY	= (cDoorY - (cDoorW / 2));
		endY	= (cDoorY + (cDoorW / 2));	
        
        % cut the door out of the wall
   		eastWall = [eastWall(1:(startY/Weps),:);...
		eastWall((endY/Weps):size(eastWall),:)];
	end

	if cDoorY == 0
		% south wall
		startX	= (cDoorX - (cDoorW / 2));
		endX	= (cDoorX + (cDoorW / 2));		
        
        % cut the door out of the wall
   		southWall = [southWall(1:(startX/Weps),:);... 
		southWall((endX/Weps):size(southWall),:)];
	end

	if cDoorY == ymax 
		% north wall
		startX	= (cDoorX - (cDoorW / 2));
		endX	= (cDoorX + (cDoorW / 2));		
        
        % cut the door out of the wall
   		northWall = [northWall(1:(startX/Weps),:);...
		northWall((endX/Weps):size(northWall),:)];
    end

    % add door to the door coordinates container
	doorCoord(i,1) = cDoorX;
    doorCoord(i,2) = cDoorY;
	doorW(i) = cDoorW;

end

% init pile coordinates
pileCoord = [];

% loop through all piles
for i=1:size(piles, 1)
   
    % coordinates
	cPileX	= piles(i, 1);
	cPileY	= piles(i, 2);
  
    % pile width (default 1)
    cPileW  = 1;

    startX  = (cPileX - (cPileW / 2));
    endX    = (cPileX + (cPileW / 2));
    
    startY  = cPileY - (cPileW / 2);
    endY    = cPileY + (cPileW / 2);
    
    % x and y coordinates of the pile
    pileCoordX = [];
    pileCoordY = [];
    
    % cut pile into small piles (Weps)
    for k=startY:Weps:endY
        
        % store coordinates of current pile
        pileCoordX = [startX:Weps:endX];
        pileCoordX = pileCoordX(:);
    
        % calculate Y coordinates
        pileCoordY = k * ones(size(pileCoordX));
        
        % append to other piles
        pileCoord  = [pileCoord;[pileCoordX, pileCoordY]];
    end
   
    
end

% put the walls and piles together
wallCoord = [pileCoord;northWall; southWall; westWall; eastWall];

%% People
% place the people
%agentCoord = rand(nrPeople,2) .* repmat([xmax, ymax],nrPeople, 1);

% ensure no agent will be placed inside of a pile
agentCoord = [];
i = 1;

while i <= nrPeople
    
    % random coordinates
    agentCX = rand() * xmax;
    agentCY = rand() * ymax;
    
    % position is ok by default
    coordOk = true;
    
    % loop through walls and piles
    for k=1:size(wallCoord,1) 
       
        if abs(wallCoord(k,1)-agentCX) <= peopleRad &&...
			abs(wallCoord(k,2)-agentCY) <= peopleRad
            % to close to a wall or pile, retry
            coordOk = false;
            break;
        end
        
    end    
    
    if coordOk == false
        % to close, retry
        continue;
    else
        % coordinates ok, store
        agentCoord(i,1) = agentCX;
        agentCoord(i,2) = agentCY;
        i = i + 1;
    end
end
    
% set random door preferences
prefDoor = ceil(rand(nrPeople,1) .* size(doorCoord,1));


% setup random door acknowledges
doorFam = [];

for i=1:nrPeople
    for j=1:size(doorCoord,1)
        doorFam(i,j) = round(rand());
    end
end

% test if the people have chosen a valid door
for i = 1:nrPeople
    while (doorW(prefDoor(i)) == 0)  
        prefDoor(i) = ceil(rand(1) * length(doorW));
    end
end
 

% set value and direction of the initial velocities 
% of the people

rad = peopleRad * ones(nrPeople,1);
v = zeros(nrPeople, 2);

for i = 1:nrPeople
    dir = doorCoord(prefDoor(i),:) - agentCoord(i,:);
    v(i,:) = (dir./norm([xmax,ymax])) * norm([15,15]);
end
