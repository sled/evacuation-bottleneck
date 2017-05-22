function [] = plotField(agentCoord, wallCoord, doorCoord, doorW, xmax, ymax)
% function that evaluates the field and gives then a 
% contour plot and a 3d-plot of the field.
% the field is only calculated with the door which is the
% first one in the doorCoord input.
%
% INPUT:
% agentCoord	... the coordinates of the agents
% wallCoord		... the coordinates of the wall-agents
% doorCoord		... the coordinates of the doors-middle
% doorW			... the width of the doors
% xmax, ymax	... the size of room


% the number of points to be evaluated per dimension.
nrEvals = 200;

% some parameters
wallR = 1.5;
agentR = 0.75;

% initialization
sol = zeros(nrEvals,nrEvals);
evalx = linspace(0,xmax,nrEvals);
evaly = linspace(0,ymax,nrEvals);

% parellelized loop for the evaluation
% if you want multiple processes running
% you need to write the following into the
% command window: matlabpool open
parfor i = 1:length(evalx);
    i %#ok<PFPRT>
    for j = 1:length(evaly);
        tsol = sol(i,:);
       
        
		%% potential we got from the agents
        for k = 1:size(agentCoord,1)
            r = norm([evalx(i), evaly(j)] - agentCoord(k,:));
            if (r <= agentR)
                tsol(j) = tsol(j) + 10^1.2 * 1/r;
            end
        end
        
		%% potential we get from the walls
        for k = 1:size(wallCoord,1)
            r = norm([evalx(i), evaly(j)] -  wallCoord(k,:));
            if (r < wallR)
                tsol(j) = tsol(j) + 1 * 1/r;
            end
        end
        
		%% potential we get from the Door 1
        r = norm([evalx(i), evaly(j)] - doorCoord(1,:));
        tsol(j) = tsol(j) + 10 * (r+4)^2;
        
		% since the values can go to infinity
		% this corrects those, that we still can
		% see something in the plot
        tsol(j) = min(tsol(j), 2500);
        sol(i,:) = tsol;
    end 
end

% plot the 3d plot
figure(99);
[x,y] = meshgrid(evalx, evaly);
daspect([1,1,1]);
surfc(x,y,sol);

% plot the contour plot
figure(98);
daspect([1,1,1000]);
contourf(evalx,evaly, sol);

