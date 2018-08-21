% read data from file
% pos is the original matrix
[name, num, pos] = read_xyz_v3('NaClBulk.txt',1);

%get the distance info
[distanceinfo] = getDistancek(pos);


%This version eliminates a redundant if loop in the interlocking case. 
%info is the cell that contains all the known info of the data
%the first column contains the region number
%the second column contains the interior points
%the third colum contains boundary points
%the fourth column contains the region points
%the fifth column contains the lattice type
%the sixth column contains the primitive basis of that region
info = {};

% numUnidentified keeps track of the number of points that have not been
% identified yet
sizepos = size(pos);
row = sizepos(1);
cursor = 1;
numregion = 0;
while row >= cursor
    current_pt =  distanceinfo{cursor, 1};
    if distanceinfo{cursor, 3} == 0
        
    % build primitive from the 50 nearest neighbor of the starting point
    [A,B,C,D,a,b,c] = buildprimitive(distanceinfo{cursor, 2}, current_pt, pos);
    
    
    if ~isequal(A, -1)
        % niggli reduction
        [v1, v2, v3, v4, v5, v6, x] = niggliReduce_fromThePaper(a, b, c);
    
        if isEqual(v1,v2,x) && isEqual(v2, v3,x)
            disp('ri');
        end
        % determine bravais type
        str = niggliToLattice(v1, v2, v3, v4, v5, v6, x*1000);
    
        % generate 6 neighbors of the starting point
        neighbor = gen6(A, a, b, c);
    
        % check if all points in the neighbor are in the data 
        allNeighborsInData = 1;
        for i = 1:6
            point = neighbor(i,:);
            [garbage,D] = dsearchn(pos, point);
            if D>0.5
                allNeighborsInData = 0;
                break;
            end
        end
        
        if allNeighborsInData
            % show bases and A,B,C,D,E,F
            disp('vector');
            disp(a);
            disp(b);
            disp(c);
            disp('Niggli');
            disp(v1);
            disp(v2);
            disp(v3);
            disp(v4);
            disp(v5);
            disp(v6);
            
            %do the projection
            [boundary, interior,region] = projection_Xuchen_fast2(current_pt,a,b,c,pos,distanceinfo);
            sizeRegion = size(region);
            rowRegion = sizeRegion(1);
            
            % mark these points as matched
            for k = 1: rowRegion
                distanceinfo{region(k, 1),3} = 1;
            end
            
            disp('Boundary');
            disp(boundary);
            disp('Interior');
            disp(interior);
            disp('Region');
            disp(region);
            numregion = numregion + 1;
            info{numregion,1} = numregion;
            info{numregion,2} = interior;
            info{numregion,3} = boundary;
            info{numregion,4} = region;
            info{numregion,5} = str;
            info{numregion,6} = [a;b;c];
            size_region = size(region);
            info{numregion,7} = size_region(1);
        end
    end
    end
 cursor = cursor + 1;

end








%interlocking handling
cursor = 1;
while cursor <= row
     if distanceinfo{cursor, 3} == 1
         cursor = cursor + 1;
     else
             current_pt =  distanceinfo{cursor, 1};
        

        % build primitive from the 50 nearest neighbor of the starting point
        [A,B,C,D,a,b,c] = buildprimitive_interlock_fast(distanceinfo{cursor, 2}, current_pt,pos);


        if ~isequal(A, -1)
            % niggli reduction
            [v1, v2, v3, v4, v5, v6, x] = niggliReduce_fromThePaper(a, b, c);

            if isEqual(v1,v2,x) && isEqual(v2, v3,x)
                disp('ri');
            end
            % determine bravais type
            str = niggliToLattice(v1, v2, v3, v4, v5, v6, x*1000);

            % generate 6 neighbors of the starting point
            neighbor = gen6(A, a, b, c);

            % check if all points in the neighbor are in the data 
            allNeighborsInData = 1;
            for i = 1:6
                point = neighbor(i,:);
                [garbage,D] = dsearchn(pos, point);
                if D>0.5
                    allNeighborsInData = 0;
                    break;
                end
            end

            if allNeighborsInData
                % show bases and A,B,C,D,E,F
                disp('vector');
                disp(a);
                disp(b);
                disp(c);
                disp('Niggli');
                disp(v1);
                disp(v2);
                disp(v3);
                disp(v4);
                disp(v5);
                disp(v6);

                %do the projection
                [boundary, interior,region] = projection_Xuchen_fast_interlocking(current_pt,a,b,c,pos,distanceinfo);
                sizeRegion = size(region);
                rowRegion = sizeRegion(1);

                % mark these points as matched
                for k = 1: rowRegion
                    distanceinfo{region(k, 1),3} = 1;
                end

                disp('Boundary');
                disp(boundary);
                disp('Interior');
                disp(interior);
                disp('Region');
                disp(region);
                numregion = numregion + 1;
                info{numregion,1} = numregion;
                info{numregion,2} = interior;
                info{numregion,3} = boundary;
                info{numregion,4} = region;
                info{numregion,5} = str;
                info{numregion,6} = [a;b;c];

            end
        end
        
        cursor = cursor + 1;
     end
    
    
    
    
    
end








%Here's where we check all the points that are still unmatched. 
% I'm assuming that M is our matrix of unmatched points. I'm worried that
% this might not actually be the case, but I'll test this assumption after
% finishing this code. 
cursor = 1;
doneSearching = 1;
while cursor <= row 
    
    if distanceinfo{cursor, 3} == 1
        cursor = cursor + 1;
    else
        current_pt = pos(cursor, :);
        near6idx = knnsearch(pos, current_pt, 'k', 7);
        found = 0;
        for i = 2:7
            current_neighbor = near6idx(1,i);
            for j = 1:numregion
                order = dsearchn(info{j,4}, current_neighbor);
                matrix = info{j,4};
                match = matrix(order, 1);
                if match == current_neighbor
                    abc = info{j, 6};
                    a = abc(1,:);
                    b = abc(2,:);
                    c = abc(3,:);
                    adj = gen6(distanceinfo{match, 1}, a, b, c);
                    for k = 1:6
                        if is_same(current_pt, adj(k,:))
                            info{j, 4} = push(cursor, info{j, 4});
                            info{j, 3} = push(cursor, info{j, 3});
                            info{j, 7} = info{j, 7}+1;
                            distanceinfo{cursor,3} = 1;
                            doneSearching = 0;
                            found = 1;
                        break;
                        end
                    end
                end
            if found ==1
                break;
            end

            
            end
            if found ==1
                break;
            end
        end
        cursor = cursor+1;
        if cursor > row && doneSearching == 0
            cursor = 1;
            doneSearching = 1; 
        end
    end

        
end



length_num = length(num);  
size_info = size(info);


    
    
    
number_of_atoms_in_current_region_of_most_prevalent_atom_type = 0;    
for i = 1:size_info(1)
    offset = 0;
    atomsnum_in_region = info{i,4};
    [m,gar] = size(atomsnum_in_region);
    atoms_in_region = zeros(m,3);
    for j = 1:m
        atoms_in_region(j,:) = distanceinfo{atomsnum_in_region(j),1};
    end
    
    
    count = 1;
    eltsCell = cell(length_num,1);
    for j = 1:length_num
        numAtom = num(j);
        elts = zeros(numAtom, 3);
        for k = 1:numAtom
            elts(k,:) = pos(count,:);
            count = count+1;
        end
        eltsCell{j,1} = elts;
    end
        
            
    
    
    
   
    for j = 1:length_num
%         elts_of_current_type = zeros(num(j), 3);
%         elts_of_current_type(j,:) = pos(j+offset,:);
%         atoms_in_current_region_of_current_type = [];
        elts_of_current_type = eltsCell{j,1};
        atoms_in_current_region_of_current_type = [];
        for k = 1:info{i,7}
             
            [Lia,Locb] = ismember(atoms_in_region(k,:),elts_of_current_type, 'rows');
            if ~isequal(Locb,0)
                atoms_in_current_region_of_current_type = vertcat(atoms_in_current_region_of_current_type, atoms_in_region(k,:));
            end
        end
        number_of_atoms_in_current_region_of_current_type = size(atoms_in_current_region_of_current_type);
        number_of_atoms_in_current_region_of_most_prevalent_atom_type = max(number_of_atoms_in_current_region_of_most_prevalent_atom_type, number_of_atoms_in_current_region_of_current_type(1)); 
        if number_of_atoms_in_current_region_of_current_type(1) == number_of_atoms_in_current_region_of_most_prevalent_atom_type
            positions_of_most_prevalent_type = atoms_in_current_region_of_current_type;
        end
    end
    
    
    
    
    
    
    
    
    
    
    
    
        %Do Niggli reduction with positions_of_most_prevalent_type
        sizepos = size(positions_of_most_prevalent_type);
        pos2 = positions_of_most_prevalent_type;
row = sizepos(1);
cursor = 1;
numregion = 0;
[distanceinfo] = getDistancek(pos2);
while row >= cursor
    current_pt =  distanceinfo{cursor, 1};
    if distanceinfo{cursor, 3} == 0
        
    % build primitive from the 50 nearest neighbor of the starting point
    [A,B,C,D,a,b,c] = buildprimitive(distanceinfo{cursor, 2}, current_pt, pos2);
    
    
    if ~isequal(A, -1)
        % niggli reduction
        [v1, v2, v3, v4, v5, v6, x] = niggliReduce_fromThePaper(a, b, c);
    
        
        % determine bravais type
        str = niggliToLattice(v1, v2, v3, v4, v5, v6, x*1000);
    
        % generate 6 neighbors of the starting point
        neighbor = gen6(A, a, b, c);
    
        % check if all points in the neighbor are in the data 
        allNeighborsInData = 1;
        for k = 1:6
            point = neighbor(k,:);
            [garbage,D] = dsearchn(pos2, point);
            if D>0.5
                allNeighborsInData = 0;
                break;
            end
        end
        
        if allNeighborsInData
            % show bases and A,B,C,D,E,F
            disp('vector');
            disp(a);
            disp(b);
            disp(c);
            disp('Niggli');
            disp(v1);
            disp(v2);
            disp(v3);
            disp(v4);
            disp(v5);
            disp(v6);
            
            symmetry_level = 0;
            if strcmp(str, 'triclinic')
                symmetry_level = 1;
            end
            if strcmp(str, 'primitive monoclinic')
                symmetry_level = 2;
            end
            if strcmp(str, 'base-centered monoclinic')
                symmetry_level = 3;
            end
            if strcmp(str, 'simple orthorhombic')
                symmetry_level = 4;
            end
            if strcmp(str, 'base-centered orthorhombic')
                symmetry_level = 5;
            end
            if strcmp(str, 'body-centered orthorhombic')
                symmetry_level = 6;
            end
            if strcmp(str, 'face-centered orthorhombic')
                symmetry_level = 7;
            end
            if strcmp(str, 'rhombodhedral')
                symmetry_level = 8;
            end
            
            if strcmp(str, 'primitive tetragonal')
                symmetry_level = 9;
            end
            if strcmp(str, 'body-centered tetragonal')
                symmetry_level = 10;
            end
            if strcmp(str, 'hexagonal')
                symmetry_level = 11;
            end
            if strcmp(str, 'primitive cubic')
                symmetry_level = 12;
            end
            if strcmp(str, 'body-centered cubic')
                symmetry_level = 13;
            end
            if strcmp(str, 'face-centered cubic')
                symmetry_level = 14;
            end
            
            if ~(symmetry_level == 0)
                break;
            end
            
            %No need to do the projection, since we already know the
            %region's boundaries
%             %do the projection
%             [boundary, interior,region] = projection_Xuchen_fast2(current_pt,a,b,c,pos,distanceinfo);
%             sizeRegion = size(region);
%             rowRegion = sizeRegion(1);
%             
%             % mark these points as matched
%             for k = 1: rowRegion
%                 distanceinfo{region(k, 1),3} = 1;
%             end
%             
%             disp('Boundary');
%             disp(boundary);
%             disp('Interior');
%             disp(interior);
%             disp('Region');
%             disp(region);
%             numregion = numregion + 1;
%             info{numregion,1} = numregion;
%             info{numregion,2} = interior;
%             info{numregion,3} = boundary;
%             info{numregion,4} = region;
%             info{numregion,5} = str;
%             info{numregion,6} = [a;b;c];
%             size_region = size(region);
%             info{numregion,7} = size_region(1);
        end
    end
    end
 cursor = cursor + 1;

end
        
        
        %Compare symmetry
        str2 = info{i, 5};
 
            if strcmp(str2, 'triclinic')
                symmetry_level2 = 1;
            end
            if strcmp(str2, 'primitive monoclinic')
                symmetry_level2 = 2;
            end
            if strcmp(str2, 'base-centered monoclinic')
                symmetry_level2 = 3;
            end
            if strcmp(str2, 'simple orthorhombic')
                symmetry_level2 = 4;
            end
            if strcmp(str2, 'base-centered orthorhombic')
                symmetry_level2 = 5;
            end
            if strcmp(str2, 'body-centered orthorhombic')
                symmetry_level2 = 6;
            end
            if strcmp(str2, 'face-centered orthorhombic')
                symmetry_level2 = 7;
            end
            if strcmp(str2, 'rhombodhedral')
                symmetry_level2 = 8;
            end
            
            if strcmp(str2, 'primitive tetragonal')
                symmetry_level2 = 9;
            end
            if strcmp(str2, 'body-centered tetragonal')
                symmetry_level2 = 10;
            end
            if strcmp(str2, 'hexagonal')
                symmetry_level2 = 11;
            end
            if strcmp(str2, 'primitive cubic')
                symmetry_level2 = 12;
            end
            if strcmp(str2, 'body-centered cubic')
                symmetry_level2 = 13;
            end
            if strcmp(str2, 'face-centered cubic')
                symmetry_level2 = 14;
            end        
        highest_symmetry = max(symmetry_level, symmetry_level2);
        if highest_symmetry==symmetry_level
            info{i,5} = str;
        end
        
end


% miller index

plot_structure(name, info, distanceinfo);
            %if atoms_in_region(k)
        