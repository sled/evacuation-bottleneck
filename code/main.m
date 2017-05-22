%%% Matlab Socio %%%
% This is the main file, where the simulations should be started from. 

doorW = [0.5,0.4];
cornerDist = [1,2];
pileDist = [0.5,0.5];
pileNr = [5,4];
nrP = 500;
xmax = 10; 
ymax = 10;
patience = 0;

% initialization
[agentCoord, doorCoord, wallCoord, pileCoord, prefDoor, doorFam, v, rad, doorW,...
xmax, ymax] = init5(xmax, ymax, nrP, doorW, cornerDist, pileNr, pileDist);

% simulation
simulation(agentCoord, doorCoord, wallCoord, pileCoord, prefDoor,...
                     doorFam, v, rad, doorW, xmax, ymax, patience, false, '')

 