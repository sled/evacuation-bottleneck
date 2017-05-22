function [queue] = get_queue_count(did, aid, agent_coords, agent_prefs,...
	door_coords)
% This function computes, how many people are in front of agent did 
% and are heading for the same door
%
% did           = Door ID
% aid           = Agent ID
% agents        = Vector of all Agents
% agent_coords  = Agent Coordinates
% agent_prefs   = Agent's preferred Door
% doors         = Vector of all Doors
% door_coords   = Door Coordinates


% Returns queue count of agents heading in direction of Door did


    agent_dist      = norm(agent_coords(aid,:)' - door_coords(did,:)');
    queue           = 0;
    
    for i=1:size(agent_coords, 1)
        
        c_did      = agent_prefs(i);
        
        % exclude our agent and agents heading for a different door %
        if(i == aid || c_did ~= did) 
           continue 
        end
        
       
        c_dist      = norm(agent_coords(i,:)' - door_coords(c_did,:)');
        
        if(c_dist <= agent_dist) 
            queue = queue + 1;
        end
    end
   
end
