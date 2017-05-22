
function [fam] = is_fam(aid, did, famDoors) 
    % input: 
    %   aid: agent id
    %   did: door id
    %   famDoors: a matrix with a row for each agent and one column for
    %   ...each door with a binary flag (known/unknown)
    
    % output:
    % returns 0 if door (did) is not familiar to agent (aid)
    % returns 1 if door (did) is familiar to agent (aid)
    fam = 0;
    
    if famDoors(aid, did) ~= 0
        fam = 1;
    end
    

end
