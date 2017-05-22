function [i] = simulation( agentCoord, doorCoord, wallCoord, pileCoord, ...
    prefDoor, doorFam, v, rad, doorW, xmax, ymax, patience, debug, logf)
% The function simulation is the main file, where the simulation runs.
%
% INPUT: 
% The *Coord Matrices should all be N x 2, where the N is the number of
% elements and 2 is the corresponding x and y coordinate.
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
% debug      ... Defines if we shall log anything
% logf       ... Handle to logfile
%
% OUPUT:
% The return value indicates how long it took until all persons left the
% room.


colors = ['m', 'c', 'y', 'r', 'g', 'b'];

%% Parameters
% maximal running time
Time = 10;

% step size of the time integration
dt = 10^-2;

% maximal velocity an agent can have
vmax = [10,10];

% how much one takes the old velocity into account
oldPartV = 0.5;

% the probability of reevaluate the doors to choose
probDoorUpdate = 1;

%% Statistics initialization
%initially door chosen
chosenDoor = [];
exitThrough = [];

for k=1:size(doorW,2)
    chosenDoor(1,k) = length(prefDoor(prefDoor == k));
end
    exitThrough = zeros(numel(doorW));
    

%% Time integration
% the time integration is done by a simple explicit euler time stepping
for i = 0:dt:Time 
%     i %#ok<NOPRT>
    
    decisionChanges = 0;
    activeAgents    = 0;
    

    % in which order the agents are updated
    whichOne = randperm(size(agentCoord,1));
    
    % update all the agents for this timestep
    for j = 1:size(agentCoord,1)
       currAgent = whichOne(j);
       
       % coordinates of the current agent
       currx = agentCoord(currAgent,1);
       curry = agentCoord(currAgent,2);
       
       % if the current agent has already left the room, continue.
       if (currx > xmax || curry > ymax || currx < 0 || curry < 0)
           continue;
       end
       
       % reconsider the preferred door
       oldPrefDoor = prefDoor(currAgent);
       
       if (rand(1) <= probDoorUpdate)
           [prefDoor(currAgent), doorFam] = ...
		   		basic2(currAgent, agentCoord, v, prefDoor, doorCoord, ...
				doorW, patience, wallCoord, pileCoord, doorFam, rad);
       end
       
       if oldPrefDoor ~= prefDoor(currAgent) 
           decisionChanges = decisionChanges + 1;
       end
   
       % calculate the current acceleration
       dv = - force(currAgent, agentCoord, wallCoord, doorCoord, rad, ...
	   		prefDoor(currAgent), doorW, xmax, ymax);
       
       % update the velocity and ensure, it is not faster then the max
       % velocity
       v(currAgent, :) = 0.5 * max(min(oldPartV * v(currAgent,:) +  dt * dv,...
	   		vmax), -vmax);
       
       % update the coordinates
       agentCoord(currAgent, :) = agentCoord(currAgent, :) + dt ...
	   		.* v(currAgent,:); 
       
       % test if we have left the room after this step
       currx = agentCoord(currAgent,1);
       curry = agentCoord(currAgent,2);
       if (currx > xmax || curry > ymax || currx < 0 || curry < 0)
           agentCoord(currAgent,:) = [-100. -100];
           v(currAgent,:) = [0,0];
           exitThrough(prefDoor(currAgent)) = ...
		   		exitThrough(prefDoor(currAgent)) + 1;
           prefDoor(currAgent) = -1;
       end  
      
    end
      
       
     
     % plot everything if not in debug mode
     if debug == false
         figure(1);

         plot(wallCoord(:,1), wallCoord(:,2), 's', 'MarkerEdgeColor', 'k', ...
                'MarkerFaceColor','k', 'MarkerSize', 7);
         hold on; 



         for k=1:size(doorW,2)
             plot(agentCoord(prefDoor == k,1), agentCoord(prefDoor == k,2),...
                'o', 'MarkerEdgeColor', colors(1,k), 'MarkerFaceColor',...
                colors(1,k), 'MarkerSize', 7);
         end

         plot(agentCoord(prefDoor == 0,1), agentCoord(prefDoor == 0,2),...
                    'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor','k', ...
                    'MarkerSize', 7);

         plot(wallCoord(:,1), wallCoord(:,2), 's', 'MarkerEdgeColor', 'k', ...
                'MarkerFaceColor','k', 'MarkerSize', 7);            
         axis([-0.01, xmax+0.01, -0.01, ymax+0.01]);    
         daspect([1,1,1]);
         set(gca,'XTickLabel','');
         set(gca,'YTickLabel','');
     
        % there has to be a folder "../bilder" that the pictures can be saved
        % comment the next three lines if you don't want to save every step
        %nameStr = sprintf('../bilder/2sociSim_patience%03.1f_%05.2f.png',... 
        %    patience, i);
        %saveas(1,nameStr,'png');    
         hold off;  
     end
    
    for k=1:size(doorW,2)
        chosenDoor(k) = length(prefDoor(prefDoor == k)) + exitThrough(k);
        exitThrough(k) = 0;
    end
    
    activeAgents = length(prefDoor(prefDoor > -1));
    
    if debug == true
        % log 
        fprintf(logf, strcat(num2str(activeAgents),',',num2str(decisionChanges),'\n'));
    end

    % exit integration if no one is in the room left
    if (isempty(prefDoor(prefDoor > -1)))
        break;
    end
    

end

%% Statistic plots
%figure(2);
%plot(chosenDoor(1:numel(chosenDoor(1,:)),:) * 100);
%xlabel('step number');
%ylabel('%');
%axis([0, index, 0, 100]);
%legend('upper door', 'lower door');
%title([num2str(exitThrough(1)),' / ', num2str(exitThrough(2))])


end



