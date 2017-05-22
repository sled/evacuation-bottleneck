function [vis] = is_vis(aid, did, agent_coords, door_coords,...
	wall_coords, pile_coords) 

    % input:
    %   aid:    agent id
    %   did:    door id
    %   agent_coords: coordinate matrix of all agents
    %   door_coords: coordinate matrix of all doors
    %   wall_coords: coordinate matrix of all walls
    %   pile_coords: coordinate matrix of all piles
    
    % output:
    %   returns 1 if door is visible to agent
    %   returns 0 if door is invisible for agent 
    

    % is door "did" visible to agent "aid" Default: true
    vis  = 1;
    
    % door doesnt exist
    if did == 0
        % not visible
        vis = 0;
        return;
    end
    
    % accuracy (resolution) same as walls/piles 
    Weps = 0.1;
    
    % get agent's position
    agentCX  = agent_coords(aid, 1);
    agentCY  = agent_coords(aid, 2);
    
    % get the door's position
    doorCX   = door_coords(did, 1);
    doorCY   = door_coords(did, 2);
    
    % gradient of the line between agent and the middle of the door
    lineGrad = (doorCY - agentCY)/(doorCX - agentCX);
    

    % rectangle between agent and door (interval)
    rectLeft    = doorCX;
    rectRight   = agentCX;
    rectTop     = agentCY;
    rectBottom  = doorCY;
    
    % swap boundaries of rectangle if necessary
    if rectLeft > rectRight
        tmpLeft = rectLeft;
        rectLeft = rectRight;
        rectRight = tmpLeft;
    end
    
    if rectBottom > rectTop 
        tmpBottom = rectBottom;
        rectBottom = rectTop;
        rectTop    = tmpBottom;
    end
    
    
    % loop through all piles
    for i=1:size(pile_coords,1) 
        
        % pile coordinates
        pileX   = pile_coords(i, 1);
        pileY   = pile_coords(i, 2);
        
        % check if pile is out of the rectangle
        if pileX < rectLeft || pileX > rectRight...
			|| pileY < rectBottom || pileY > rectTop
            % if yes, the pile is not of any interest, skip
            continue;
        end

        % check if pile is on the sight-line!
        tmpY    = round((lineGrad * (pileX - agentCX) ...
			+ agentCY)*(1/Weps))/(1/Weps);

        if pileY == tmpY
            %hold on;
            %plot([agentCX, doorCX], [agentCY, doorCY]);
            
            % the pile is in the agent's sightline to the door 
            % the door is not visible to the agent
            vis = 0;
            return;
        end
        
    end
        
        
end
