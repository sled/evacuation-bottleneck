%%% Matlab Socio %%%
% This is the main file, where the simulations should be started from. 

doorW = [1,0.4];
cornerDist = [1,2];
pileDist = [0.5,0.5];
pileNr = [2,4];
nrP = 30;
xmax = 5; 
ymax = 5;
patience = 0;

% [agentCoord, doorCoord, wallCoord, prefDoor, v, rad, doorW,...
%     xmax, ymax] = init2(xmax, ymax, nrP, doorW, doorDist);
[agentCoord, doorCoord, wallCoord, pileCoord, prefDoor, doorFam, v, rad, doorW,...
xmax, ymax] = init5(xmax, ymax, nrP, doorW, cornerDist, pileNr, pileDist);

simulation(agentCoord, doorCoord, wallCoord, pileCoord, prefDoor,...
                    doorFam, v, rad, doorW, xmax, ymax, patience)