function [boundary, interior, region, perfect, distanceinfo] = projection_Xuchen_fast_interlocking(A, a,b,c, positions,distanceinfo,cursor)
% This function projects the bases to the entire space (similar to normal
% projection

% To start with, the only point in checklist is our starting point A
% checklist is a queue, and it contains the point number
checklist = cursor;

% Initialize the boundary and interior to empty
boundary = [];
interior = [];
perfectChecklist = A;
perfect = [];

% As long as checklist is not empty
while ~isequal(size(checklist), [0, 1])
    % pop out the last point in checklist
    [current, checklist] = pop(checklist);
    [currentPerfect,perfectChecklist] = pop(perfectChecklist);
    % because only interior points can enter checklist, push the current
    % point on to the list 'interior'
    interior = push(current, interior);
    perfect = push(currentPerfect, perfect);
    
    distanceinfo{current, 3} = 1;
    distanceinfo{current, 4} = currentPerfect;
    
    current_pt = distanceinfo{current,1};
    % generate the 26 neighbors of the current point
    neighbors = gen_adj(current_pt,a,b,c);
    neighborsPerfect = gen_adj(currentPerfect,a,b,c);
    for i = 1:26
        % check whether the neighbor is in the data
        points = zeros(48, 3);
        M = distanceinfo{current, 2};
        for j = 1:48
            points(j,:) = positions(M(j), :);
        end
        idx = dsearchn(points,neighbors(i,:));
        closestPoint = points(idx, :);
        Point4 = M(idx);
        
        
        inData = is_same(closestPoint, neighbors(i,:));
        
        if inData && (distanceinfo{Point4, 3} == 0)
            
            % check if the neighbor is already in one of the lists 
            sizeChecklist = size(checklist);
            rowChecklist = sizeChecklist(1);
            if rowChecklist > 0
                Point1 = dsearchn(checklist,Point4);
                Point1 = checklist(Point1,1);
            else 
                Point1 = -1;
            end
            
            inChecklist = (Point1 == Point4);
            if ~inChecklist
                checklist = push(Point4, checklist);
                perfectChecklist = push(neighborsPerfect(i,:),perfectChecklist);
            end
        end
    end
end

region = vertcat(interior, boundary);

end



