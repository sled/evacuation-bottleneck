function [prefDoorID, door_fams]  = basic2(aid, agent_coords, ...
	agent_speeds, agent_prefs, door_coords, door_caps, patience,...
	wall_coords, pile_coords, door_fams, peopleRad) 
% This function calculates the door we prefere at our current 
% position and velocity.
%
% aid           = Agent ID
% agents        = Vector of all Agents
% agent_coords  = Agent Positions 
% agent_speeds  = Agent Speeds
% agent_prefs   = Agent's Preferred Doors
% doors         = Vector of all Doors
% door_coords   = Door Positions
% door_caps     = Door Capacitivities
% patience 		= how much better an other door needs to be to be chosen
 
    % init
    agent_pos       = agent_coords(aid,:)';
    agent_vel       = agent_speeds(aid,:)';
    door_caps       = door_caps';
    
    d_weights       = [];
    d_vis           = [];
    
    prefDoorID             = 0;
    
    
    old_door        = agent_prefs(aid);
    
    % get weigthing for doors
    
    for i=1:size(door_coords,1)
        
        d_vis(i) = is_vis(aid, i, agent_coords, door_coords, wall_coords,...
			pile_coords);
        
        if is_fam(aid, i, door_fams) == 1 && d_vis(i) == 1
            % door is visible and familiar
            d_weights(i) = 1;
        elseif is_fam(i, i, door_fams) == 1 && d_vis(i) == 0
             % door is familiar but not visible
            d_weights(i) = 2;
        elseif is_fam(aid, i, door_fams) == 0 && d_vis(i) == 1
            % door is visible but not familiar
            d_weights(i) = 3;
        else
            % door is invisible and not familiar
            d_weights(i) = 4;
        end
    
    end
    
    % select the group with the best (lowest) preference numbers
    
    bPrefNr     = min(d_weights);
    
    % worst case, person doesn't know any doors and can't see any
    if bPrefNr  == 4
        % he goes panic!!!! 
        prefDoorID = 0;
    end
    
    if bPrefNr < 4

        % get best group of door indices
        bDoorInd    = find(d_weights == bPrefNr)';
        d_time      = zeros(size(bDoorInd,1), 1);
        d_time_raw  = zeros(size(bDoorInd,1), 1);
        
        % loop through these doors and find the one with the 
		% best waiting time

        for i=1:size(bDoorInd,1)

            % door capacity (people per time step it can take
            bk  = 1/(door_caps(bDoorInd(i))*10); 

            % estimated moving time:
            est_mtime   = distance_time(norm(agent_pos -...
				door_coords(bDoorInd(i),:)'), agent_vel);

            % estimated queueing time                
            est_qtime   = bk * get_queue_count(bDoorInd(i), aid,...
				agent_coords, agent_prefs, door_coords);     


            % we cannot calculate the queue time if the door is not visible!
            d_time_raw(i) = est_mtime + est_qtime;
            est_qtime   = d_vis(bDoorInd(i))*est_qtime;

            d_time(i)   = est_mtime + est_qtime;

        end     

        % get the best one!

        prefDoorID     = bDoorInd(find(d_time == min(d_time), 1, 'first'));
    end
    
    % calculate time of old door
    
    % door capacity (people per time step it can take
    bk  = 1/(door_caps(old_door)*10); 

    % estimated moving time:
    est_mtime   = distance_time(norm(agent_pos -...
		door_coords(old_door,:)'), agent_vel);

    % estimated queueing time                
    est_qtime   = bk * get_queue_count(old_door, aid, agent_coords,...
		agent_prefs, door_coords);     


    % we cannot calculate the queue time if the door is not visible!
    est_qtime   = d_vis(old_door)*est_qtime;
    
    old_time = est_mtime + est_qtime;
    
    % compare new preferable door and the old one, only take the new one
    % if it is better!
    if old_time <= d_time_raw(find(d_time == min(d_time), 1, 'first'))  
        prefDoorID = old_door;
    end
    
    
end
