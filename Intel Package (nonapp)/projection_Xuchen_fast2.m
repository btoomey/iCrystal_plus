function [boundary, interior, region,perfect, distanceinfo] = projection_Xuchen_fast2(A,cursor,a,b,c,positions,distanceinfo)
% This function projects the bases to the entire space

% To start with, the only point in checklist is our starting point A

% boundary contains the boundary points of the region
% interior contains the intetior points of the region
% perfect contains the perfect positions of the points in the region

% checklist and perfectChecklist are queue.
% checklist contains call number, while perfectChecklist contains the
% coordinates
checklist = cursor;
perfectChecklist = A;

% Initialize the boundary and interior to empty
boundary = [];
interior = [];
perfect = [];

% As long as checklist is not empty
while ~isequal(size(checklist), [0, 1])
    % pop out the last point in checklist(perfectChecklist)
    [current, checklist] = pop(checklist);
    [currentPerfect,perfectChecklist] = pop(perfectChecklist);
    % because only interior points can enter checklist, push the current
    % point on to the list 'interior'
    interior = push(current, interior);
    perfect = push(currentPerfect, perfect);


    % mark the current point as identified
    distanceinfo{current, 3} = 1;
    
    % update the perfect position in the distanceinfo
    distanceinfo{current, 4} = currentPerfect;
    
    % get the actual coordinates of the current point
    current_pt = distanceinfo{current,1};
    
    % generate the 26 neighbors of the current point
    neighbors = gen_adj(current_pt,a,b,c);
    neighborsPerfect = gen_adj(currentPerfect,a,b,c);
    
    
    % check whether the neighbor is in the data
    for i = 1:26
        % points is the 30 nearest neighbor of the starting point
        points = zeros(30, 3);
        M = distanceinfo{current, 2};
        for j = 1:30
            points(j,:) = positions(M(j), :);
        end
        idx = dsearchn(points,neighbors(i,:));
        
        % closestPoint is the closest point of the current point in the
        % data
        closestPoint = points(idx, :);
        Point4 = M(idx);
        
        
        
        % inData = 1 if the current neighbor is in the data
        inData = is_same(closestPoint, neighbors(i,:));
        
        
        % process this neighbor if it is in the data and has not been
        % identified yet
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

            % if the current neighbor is not in the checklist, process it,
            % else igore it
            if ~inChecklist
                % check if the neighbor is an interior point
                isInterior = qualify2(neighbors(i,:), a,b,c, distanceinfo, positions, Point4);
                if isInterior
                    % if the neighbor is an interior point, and it is not in checklist, interior or boundary
                    % push this point on to 'checklist'
                    checklist = push(Point4, checklist);
                    perfectChecklist = push(neighborsPerfect(i,:),perfectChecklist);      
                else
                    % if the neighbor is not an interior point, but it matches one of the points in the data,
                    % we rule it as boundary point and push it on to 'boundary'
                    boundary = push(Point4, boundary);
                    distanceinfo{Point4, 3} = 1;
                    perfect = push(neighborsPerfect(i,:), perfect);
                    distanceinfo{Point4, 4} = neighborsPerfect(i,:);
                end
            end
        end
    end
% region is interior points plus boundary points
end

region = vertcat(interior, boundary);

end



