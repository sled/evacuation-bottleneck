%%% Matlab Socio %%%
% This is the debug file for logging

doorW = [0.5,0.4];
cornerDist = [1,2];
pileDist = [0.5,0.5];
pileNr = [5,4];
nrP = 500;
xmax = 10; 
ymax = 10;
patience = 0;

cases = [100,200,300,400,500]; % people count
evals = 12; % 12 runs

logfile = fopen('logfile.log', 'w');
 
 
 
for i=1:size(cases,2)
    
    ppCnt = cases(1,i);
    disp(strcat('Case Nr. ', num2str(i), ' - ', num2str(ppCnt), '\n'));
    
    % -100,[peopleCount]   // -100 defines a case
    fprintf(logfile, strcat('-100,',num2str(ppCnt),'\n'));
    
    for j=1:evals
        disp(strcat('---> Run Nr. ', num2str(j), '\n'));
        
        % -200,[runNr] // -200 defines a run
        fprintf(logfile, strcat('-200,',num2str(j),'\n')); 
        
        % init
        [agentCoord, doorCoord, wallCoord, pileCoord, prefDoor, doorFam, v, rad, doorW,...
        xmax, ymax] = init5(xmax, ymax, ppCnt, doorW, cornerDist, pileNr, pileDist); 
    
        % simulate
        simulation(agentCoord, doorCoord, wallCoord, pileCoord, prefDoor,...
                             doorFam, v, rad, doorW, xmax, ymax, patience, true, logfile);
   
    end
    
end
 
fclose(logfile);
 