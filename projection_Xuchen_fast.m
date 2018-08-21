function [boundary, interior, region] = projection_Xuchen_fast(A, a,b,c, positions,distanceinfo)
% This function projects the bases to the entire space

% To start with, the only point in checklist is our starting point A
% checklist is a queue, and it contains the point number
checklist = dsearchn(positions, A);

% Initialize the boundary and interior to empty
boundary = [];
interior = [];


% As long as checklist is not empty
while ~isequal(size(checklist), [0, 1])
    % pop out the last point in checklist
    [current, checklist] = pop(checklist);

    % because only interior points can enter checklist, push the current
    % point on to the list 'interior'
    interior = push(current, interior);
    current_pt = distanceinfo{current,1};
    % generate the 26 neighbors of the current point
    neighbors = gen_adj(current_pt,a,b,c);
    for i = 1:26
        % check whether the neighbor is in the data
        Point4 = dsearchn(positions,neighbors(i,:));
        inData = is_same(positions(Point4,:), neighbors(i,:));
        
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
            
            sizeInterior = size(interior);
            rowInterior = sizeInterior(1);
            if rowInterior > 0
                Point2 = dsearchn(interior,Point4);
                Point2 = interior(Point2,1);
            else
                Point2 = -1;
            end
            
            sizeBoundary = size(boundary);
            rowBoundary = sizeBoundary(1);
            if rowBoundary > 0
                Point3 = dsearchn(boundary,Point4);
                Point3 = boundary(Point3, 1);
            else
                Point3 = -1;
            end
            
            inChecklist = (Point1 == Point4);
            inInterior = (Point2 == Point4);
            inBoundary = (Point3 == Point4);
        
            if ~inChecklist && ~inInterior && ~inBoundary
                % check if the neighbor is an interior point
                isInterior = qualify(neighbors(i,:), a,b,c, distanceinfo, positions);
                if isInterior
                    % if the neighbor is an interior point, and it is not in checklist, interior or boundary
                    % push this point on to 'checklist'
                    checklist = push(Point4, checklist);
                else
                    % if the neighbor is not an interior point, but it matches one of the points in the data,
                    % we rule it as boundary point and push it on to 'boundary'
                    boundary = push(Point4, boundary);
                end
            end
        end
    end
end

region = vertcat(interior, boundary);

end



