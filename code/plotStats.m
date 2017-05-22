function[] = plotStats(logfile, plottitle) 

% plots statistics for result CSV file logfile
% input:
%   logfile: path to csv logfile
%   plottitle: title for plot (ex. with piles / without piles)

% output:
%   nothing - draws a plot!

% get raw data
raw_data		= csvread(logfile);

% containers
agent_count		= [];
door_changes	= [];

evac_times		= [];

cases			= [];

case_count		= 0;

% colors for plot
colors = ['m', 'c', 'y', 'r', 'g', 'b'];

run_rows        = [];
run_counts      = [];

c_rows          = 0;

% collecting data
for i=1:length(raw_data)

    % -100 indicates a new case
	if raw_data(i,1) == -100
        
        % output
        disp(strcat(num2str(raw_data(i,1)), ' - ', num2str(raw_data(i,2)))); 
    
        % increase case
        case_count = case_count+1;        
    
        % store count of people
        cases(case_count) = raw_data(i,2);
        
        % reset values
        run_counts(case_count) = 0;
        run_rows(case_count) = 0;
        c_rows               = 0;
        
        agent_count(1, case_count) = 0;
        door_changes(1, case_count) = 0;
        
        continue;
        
    end

    % -200 indicates a run within a case
	if raw_data(i,1) == -200
        % output
        disp(strcat('---> ',  num2str(raw_data(i,1)), ' - ', num2str(raw_data(i,2)))); 
        
        % increase run count
        run_counts(case_count) = run_counts(case_count) + 1;
        % reset rows
        c_rows = 0;
        
        continue;
    end
    
    % this is a data set
    
    % increase rows for this run
    run_rows(case_count) = run_rows(case_count) + 1;
    c_rows = c_rows + 1;
    
    % reserve space for stats
    if size(agent_count, 1) < c_rows
        agent_count(c_rows, case_count) = 0;
    end
    
    % append agent count
    agent_count(c_rows, case_count) = ...
        agent_count(c_rows, case_count) + raw_data(i,1);
    
    % reserve space for stats
    if size(door_changes, 1) < c_rows
        door_changes(c_rows, case_count) = 0;
    end
    
    % append door changes
    door_changes(c_rows, case_count) = ...
        door_changes(c_rows,case_count) + raw_data(i,2);
    
end


% analyze data (calculating averages)
for i=1:case_count
    % loop through all cases
    
    % average timesteps 
    evac_times(i) = 0;
    evac_times(i) = round(run_rows(1,i) / run_counts(1,i));
    
    
    % calculate average agent count
    for j=1:size(agent_count, 1)
        agent_count(j,i)  = agent_count(j,i) / run_counts(1,i);
        
        if j > evac_times(i)
            agent_count(j,i) = 0;
        end
        
    end    
    
    % calculate average door changes
    for k=1:size(door_changes,1)
        door_changes(k,i) = door_changes(k,i) / run_counts(1,i);
        
        if k > evac_times(i)
            door_changes(k,i) = 0;
        end        
    end
    
end
    

% setup plots

% first plot (agent count)
figure(98);
set(gca, 'XTick', 0:100:900);
set(gca, 'YTick', 0:100:max(cases));

axis([0 900 0 500]);

title(strcat({'Agents '},plottitle));

xlabel('Time Steps');
ylabel('Agent Count');

% second plot (decision count)
figure(99);

set(gca, 'XTick', 0:100:900);
set(gca, 'YTick', 0:10:300);

axis([0 900 0 100]);

title(strcat({'Decisions '}, plottitle));

xlabel('Time Steps');
ylabel('Decisions');

legend1 = cell(1, case_count);
legend2 = cell(1, case_count);


% loop through all cases an generate plot using average values
for i=1:case_count

    disp(strcat('Evac Time of Case ', num2str(i), ': ', num2str(evac_times(i)))); 
    
    % create legend
    legend1{i} = sprintf('%d Agents\nAVG: %d Time Steps', cases(i), evac_times(i));
    legend2{i} = sprintf('%d Agents\nMax: %.2f\nAvg: %.2f', cases(i), ...
        max(door_changes(:,i)), mean(door_changes(1:evac_times(i),i)));
    
    
    
    figure(98);
	hold on;
	plot(agent_count(:,i), colors(i));
    

    figure(99);
    hold on;
    plot(door_changes(:,i), colors(i));
   
    
end			

% set legend

figure(98);
legend(legend1);
figure(99);
legend(legend2);


end