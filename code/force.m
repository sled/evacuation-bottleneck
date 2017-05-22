function [f] = force(agentNr, agentCoord, wallCoord, doorCoord, rad,...
	prefDoor, doorW, xmax, ymax)
% calculates the force acting on the agent
% with the number agentNr
%
% INPUT:
% agentNr		... the number of the agent, we want to 
%					forces for.
% agentCoord	... the coordinates of all agents.
% wallCoord		... the coordinates of the wall-elements.
% coorCoord		... the coordinates of the doors.
% rad			... the size of the agents in agentCoord.
% prefDoor		... the number of the prefered door of agent with agentNr.
%
% OUTPUT:
% The forces acting on agent with agentNr as a two dimensinal vector.

% parameter for the wall
wallR = 1.5;

% initialize the forces
f = [0,0];
potA = zeros(2,1);
potD = potA;
potW = potA;

% first calculate forces from agents
for i = 1:size(agentCoord,1)
   
	% we don't have a force coming
	% form ourselves.
    if (i == agentNr) 
        continue; 
    end;
    
    acor = agentCoord(agentNr,:);
    bcor = agentCoord(i,:);
    dist = norm(acor - bcor);
	% only calculate the force, if we are in 
	% the others radius
    if (rad(i) > dist)   
        potA = potAgent(acor, bcor);       
        f = f + potA(:)';
    end
end

% then the wall-forces
for i = 1:size(wallCoord,1);
   dist = norm(agentCoord(agentNr, :) - wallCoord(i,:));
   % only calculate the force, if we are
   % within the radius of a wall element.
   if (dist < wallR)  
       potW = potWall(agentCoord(agentNr, :), wallCoord(i,:));
       f = f + potW(:)';
   end    
end

% and finally door-force

% if he has no door preference, let him move around randomly
if prefDoor > 0
   
    potD = potDoor(agentCoord(agentNr,:), doorCoord(prefDoor,:),...
        doorW(prefDoor), xmax, ymax);

    f = f + potD(:)';      
end
end
