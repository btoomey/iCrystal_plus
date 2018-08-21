% Initializations
clear all
global tol1 tol2 tol3 tol4 tol5
load('tol.mat');
if isempty(tol1)
    tol1 = 3;
end
if isempty(tol2)
    tol2 = 0.2;
end
if isempty(tol3)
    tol3 = 0.01;
end
if isempty(tol4)
    tol4 = 0.1;
end
if isempty(tol5)
    tol5 = 0.1;
end

% read data from file
% pos is the original matrix
[name, num, pos] = read_xyz_v3(address);
%get the distance info
% disp(address);
disp('Finished reading file');

% [m,gar] = size(pos);
% for i = 1:m
%     if norm(pos(i,:))>1E5
%         pos(i,:)=[];
%         num = num-1;
%     end
% end


[distanceinfo] = getDistancek(pos);



%info is the cell that contains all the known info of the data
%the first column contains the region number
%the second column contains the interior points
%the third column contains boundary points
%the fourth column contains the region points
%the fifth column contains the lattice type
%the sixth column contains the primitive basis of that region
%the seventh column contains the perfect position of that atom
%the eighth column contains number of atoms in the region
%the ninth column contains the origin of the local coordinate
%the tenth column contains the basis vector for local coordinate
%the eleventh column contains the rdf info for the region
%the twelfth column contains the miller index info for the region

info = {};

% row is the total number of points in the data
sizepos = size(pos);
row = sizepos(1);

elt_names = find_names(name);

%Here's where we label each point with its corresponding element type. 
elt_types = cell(row, 1);
length_num = length(num);
%If there's only only element type, we label all points as having that
%element type. 
if length_num==1
    for i = 1:row
        elt_types{i, 1} = name;
    end
else
    i = 1;
    current_elt = 1;
    %Otherwise, we proceed through all of the elements in the list. 
    while i<row+1
        %Each time we start over again with a new element type, we
        %initialize the number of elements of that type which we've counted
        %to 1. 
        current_elt_count = 1;
        %As long as we're within the portion of the list of elements
        %corresponding to that element type, we continue to proceed. 
        while current_elt_count < num(current_elt)+1
            elt_types{i,1} = elt_names{current_elt};
            current_elt_count = current_elt_count+1;
            i = i+1;
        end
        current_elt = current_elt+1;
    end
end

%distanceinfo is where we store the element type corresponding to each
%atom. 
distanceinfo = horzcat(distanceinfo, elt_types);

% the cursor keeps track of which point the program is processing at the
% moment
cursor = 1;

%initialize the number of identified regions to 0.
numregion = 0;

% loop through all the points
while row >= cursor
    
    % current_pt takes the coordinate of the current point
    current_pt =  distanceinfo{cursor, 1};
    
    % try to buildprimitive vectors
    if distanceinfo{cursor, 3} == 0
        
        % build primitive vectors from the 50 nearest neighbors of the starting point
        [A,B,C,D,a,b,c] = buildprimitive(distanceinfo{cursor, 2}, current_pt, pos);

        % if there is error msg from buildprimitive, process the next point
        %Otherwise, we proceed to perform the Niggli reduction. 
        if ~isequal(A, -1)
            % perform niggli reduction and get the 6 parameters of the niggli
            % form
            [v1, v2, v3, v4, v5, v6] = niggliReduce_fromThePaper(a, b, c);

            % determine bravais type
            str = niggliToLattice(v1, v2, v3, v4, v5, v6);

             % generate 6 neighbors of the starting point
             neighbor = gen6(A, a, b, c);

            % check if all 6 neighbors are in the data. If they all are, 
            % we rule the starting point as an interior point  
            allNeighborsInData = 1;
            idxlist = [-inf];
            for i = 1:6
                point = neighbor(i,:);
                M = distanceinfo{cursor,2};
                searchArea = zeros(27,3);
                for j = 1:27
                    searchArea(j,:) = distanceinfo{M(j),1};
                end
                [idx,D1] = dsearchn(searchArea, point);
                [gar,D2] = dsearchn(idxlist, idx);
                if D1>tol2 || D2<1 ||distanceinfo{M(idx),3} == 1
                    allNeighborsInData = 0;
                    break;
                end
                idxlist = push(idx, idxlist);
            end

            % if starting point is not interior, try the next point.
            if allNeighborsInData
                
   

                %do the projection
                [boundary, interior,region,perfect, distanceinfo] = projection_Xuchen_fast2(current_pt,cursor,a,b,c,pos,distanceinfo);       
%                 if size(region,1)>18
                % increment the region number 
                numregion = numregion + 1;

                % store information about the region in the info cell
                info{numregion,1} = numregion;
                info{numregion,2} = interior;
                info{numregion,3} = boundary;
                info{numregion,4} = region;
                info{numregion,5} = str;
                info{numregion,6} = [a;b;c];
                info{numregion,7} = perfect;
                
                % rowRegion is the number of atoms in this region
                sizeRegion = size(region);
                rowRegion = sizeRegion(1);
                info{numregion,8} = rowRegion;
                info{numregion,9} = A;
%                 end
            end
        end
    end
 cursor = cursor + 1;
end



disp('Finished finding normal lattices');




%interlocking handling
%reset cursor to top of the matrix
cursor = 1;
while cursor <= row
     % if the point has already been identified, skip it
     if distanceinfo{cursor, 3} == 1
         cursor = cursor + 1;
     else
         % current_pt is the coordinates of the current point
        current_pt =  distanceinfo{cursor, 1};

        % build primitive from the 48 nearest neighbor of the starting point
        [A,B,C,D,a,b,c] = buildprimitive_interlock_fast(distanceinfo{cursor, 2}, current_pt,pos);


        if ~isequal(A, -1)
            % niggli reduction
            [v1, v2, v3, v4, v5, v6] = niggliReduce_fromThePaper(a, b, c);

            % determine bravais type
            str = niggliToLattice(v1, v2, v3, v4, v5, v6);

            % generate 6 neighbors of the starting point
            neighbor = gen6(A, a, b, c);

            % check if all points in the neighbor are in the data 
            allNeighborsInData = 1;
            idxlist = [-inf];
            for i = 1:6
                point = neighbor(i,:);
                M = distanceinfo{cursor,2};
                searchArea = zeros(27,3);
                for j = 1:27
                    searchArea(j,:) = distanceinfo{M(j),1};
                end
                [idx,D1] = dsearchn(searchArea, point);
                [gar,D2] = dsearchn(idxlist, idx);
                if D1>tol2 || D2<1 ||distanceinfo{M(idx),3} == 1
                    allNeighborsInData = 0;
                    break;
                end
                idxlist = push(idx, idxlist);
            end
%             for i = 1:6
%                 point = neighbor(i,:);
%                 [garbage,D] = dsearchn(pos, point);
%                 if D>tol2
%                     allNeighborsInData = 0;
%                     break;
%                 end
%             end
            
            if allNeighborsInData

                %do the projection
                [boundary, interior,region,perfect, distanceinfo] = projection_Xuchen_fast_interlocking(current_pt,a,b,c,pos,distanceinfo,cursor);
                sizeRegion = size(region);
                rowRegion = sizeRegion(1);

                
                % determine whether this region is interlocking with a
                % region that has already been identified
                exist = 0;
                count  = 0;
                % for each identified region, test if the current region
                % has points in its convex hull
                for q = 1:numregion
                    if size(perfect,1)<30 || size(info{q,7},1)<30
                        continue
                    end
                    in = inhull(perfect, info{q,7});
                    for p = 1:rowRegion
                        if in(p) == 1
                            count = count + 1;
                        end
                    end
                    % if the number of points in the hull of other regions
                    % makes up more than 20% of the current region, rule
                    % the current region as interlocking with an existing
                    % region
                    if count/rowRegion >0.2
                        exist = 1;
                        break;
                    end
                    count = 0;
                end
                
                % if it is interlocking, combine the information on this
                % region with the previous region
                if exist == 1
                    info{q,4} = vertcat(info{q,4}, region);
                    info{q,7} = vertcat(info{q,7}, perfect);
                    info{q,8} = info{q,8} + rowRegion;
                else
                    numregion = numregion + 1;
                    info{numregion,1} = numregion;
                    % note that boundary is empty and interior is equal to
                    % region
                    info{numregion,2} = interior;
                    info{numregion,3} = boundary;
                    info{numregion,4} = region;
                    info{numregion,5} = str;
                    info{numregion,6} = [a;b;c];
                    info{numregion,7} = perfect;
                    info{numregion,8} = rowRegion;
                    info{numregion,9} = A; 
                end
            end
        end
    end
    cursor = cursor + 1;
end

%end




disp('Finished finding interlocking structures');



%Here's where we check all the points that are still unmatched. The ones
%we're looking for now are boundary points without any interior neighbors. 

%reset cursor to 1
cursor = 1;
%initialize doneSearching to 1, if donesearching is 1 and cursor has run
%through all points, we rule that all exterior boundary points have been
%found
doneSearching = 1;

% run cursor through all points
while cursor <= row 
    % skip the point if the point has already been identified
    if distanceinfo{cursor, 3} == 1
        cursor = cursor + 1;
    else
        % current_pt is the coordinate of the current point
        current_pt = pos(cursor, :);
        % M is the call number of the nearest neighbors of the current
        % point
        M = distanceinfo{cursor,2};
        % near6idx takes out the 7 nearest neighbors (the first being the
        % current point itself)
        near6idx = zeros(1,7);
        for j = 1:7
            near6idx(j) = M(j);
        end
        
        % initialize found to 0
        found = 0;
        % for each of the 6 nearest neighbor
        for i = 2:7
            current_neighbor = near6idx(1,i);
            % run through all identified region
            for j = 1:numregion
                % try to find the current neighbor in that region
                order = dsearchn(info{j,4}, current_neighbor);
                matrix = info{j,4};
                match = matrix(order, 1);
                % if the current neighbor is in that region
                if match == current_neighbor
                    % get the primitive vectors of that region
                    abc = info{j, 6};
                    a = abc(1,:);
                    b = abc(2,:);
                    c = abc(3,:);
                    % get the 6 neighbors of the current neighbor along the
                    % a,b,c and -a, -b, -c directions 
                    adj = gen6(distanceinfo{match, 1}, a, b, c);
                    
                    % run through those 6 neighbors
                    for k = 1:6
                        % if the neighbor matchs the current point
                        if is_same(current_pt, adj(k,:))
                            % if the perfect position of that point is
                            % empty
                            if ~isequal(distanceinfo{match,4},[])
                                % generate the perfect position of that
                                % point
                                adjPerfect = gen6(distanceinfo{match,4},a,b,c);
                                % record that perfect position of that
                                % point in distanceinfo and info cell
                                info{j, 7} = push(adjPerfect(k,:), info{j, 7});
                                distanceinfo{cursor,4} = adjPerfect(k,:);
                            end
                            % add the current point to the boundary and
                            % region matrix of the corresponding region
                            info{j, 4} = push(cursor, info{j, 4});
                            info{j, 3} = push(cursor, info{j, 3});
                            info{j, 8} = info{j,8}+1;
                            % mark that point as identified
                            distanceinfo{cursor,3} = 1;
                            % change doneSearching to 0 to force the
                            % section to start over
                            doneSearching = 0;
                            found = 1;
                        break;
                        end
                    end
                end
                % the point has been found in a particular region, no need
                % to check whether that point belongs to other regions
                if found ==1
                    break;
                end
            end
            % the point has been found in a particular region, no need
            % to check whether that point belongs to other regions
            if found ==1
                break;
            end
        end
        
        % if doneSearching = 0, reset the cursor to 1
        if cursor > row && doneSearching == 0
            cursor = 1;
            doneSearching = 1; 
        end
        % increment cursor
        cursor = cursor+1;
    end
end


disp('Finished finding exterior points');

% Higher Symmetry handling

% length_num is the number of different elements
length_num = length(num);  
% size_info(1) is the number of regions
size_info = size(info);
% if there are more than 1 element, check for higher symmetry
if length_num >1    
% initialize the number of the atoms that prevails to 0
number_of_atoms_in_current_region_of_most_prevalent_atom_type = 0;    
% loop through all regions
for i = 1:size_info(1)
    % m is the number of atoms in the region
    atomsnum_in_region = info{i,4};
    [m,gar] = size(atomsnum_in_region);
    % atoms_in_region contains the coordinates of all the points in the
    % region.
    atoms_in_region = zeros(m,3);
    for j = 1:m
        atoms_in_region(j,:) = distanceinfo{atomsnum_in_region(j),1};
    end
    
    % initialize count to 1
    count = 1;
    % construct eltsCell, which has the num of elements as its num of rows
    % each entry records the coordinates of atoms of different elements
    eltsCell = cell(length_num,1);
    for j = 1:length_num
        numAtom = num(j);
        % elts is the coordinates of the atoms of a particular element
        elts = zeros(numAtom, 3);
        for k = 1:numAtom
            elts(k,:) = pos(count,:);
            count = count+1;
        end
        eltsCell{j,1} = elts;
    end
        
            
    
    
    
    
    for j = 1:length_num
        elts_of_current_type = eltsCell{j,1};
        % atoms_in_current_region_of_current_type picks out all the atoms
        % in a certain region that is of a certain element type
        atoms_in_current_region_of_current_type = [];
        for k = 1:info{i,8}
            [Lia,Locb] = ismember(atoms_in_region(k,:),elts_of_current_type, 'rows');
            if ~isequal(Locb,0)
                atoms_in_current_region_of_current_type = vertcat(atoms_in_current_region_of_current_type, atoms_in_region(k,:));
            end
        end
        
        % positions_of_most_prevalent_type takes out the coordinates of the
        % atoms of the atom type that prevails
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
[distanceinfo2] = getDistancek(pos2);
while row >= cursor
    current_pt =  distanceinfo2{cursor, 1};
    if distanceinfo2{cursor, 3} == 0
    % build primitive from the 50 nearest neighbor of the starting point
    [A,B,C,D,a,b,c] = buildprimitive(distanceinfo2{cursor, 2}, current_pt, pos2);
    if ~isequal(A, -1)
        % niggli reduction
        [v1, v2, v3, v4, v5, v6] = niggliReduce_fromThePaper(a, b, c);
        % determine bravais type
        str = niggliToLattice(v1, v2, v3, v4, v5, v6);
        % generate 6 neighbors of the starting point
        neighbor = gen6(A, a, b, c);
        % check if all points in the neighbor are in the data 
        allNeighborsInData = 1;
        for k = 1:6
            point = neighbor(k,:);
            [garbage,D] = dsearchn(pos2, point);
            if D>0.1
                allNeighborsInData = 0;
                break;
            end
        end
        
        if allNeighborsInData
            
            % find the symmetry level of the Bravais lattice type
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
            if strcmp(str, 'primitive hexagonal')
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
                abc = vertcat(a,b,c);
                break;
            end
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
            if strcmp(str2, 'primitive hexagonal')
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
        % compare the symmetry levels. If the new Bravais lattice type has
        % a higher symmetry, update the primitive vectors and the Bravais
        % lattice type
        highest_symmetry = max(symmetry_level, symmetry_level2);
        if highest_symmetry==symmetry_level
            info{i,5} = str;
            info{i,6} = abc;
            info{i,9} = A; 
        end
        
end
end
disp('Finished finding higher symmetries');


% Zeolite handling
% save the distanceinfo for further use
% distanceForFurtherUse = distanceinfo;
% make a copy of distanceinfo
distanceinfocopy = distanceinfo;
count = 1;
[m,n] = size(distanceinfocopy);
discopy = [];
% take out all the points that have been matched and get discopy
while count<=m
    if distanceinfocopy{count, 3} == 1
        distanceinfocopy(count, :) = [];
        m = m-1;
    else
        discopy = vertcat(discopy, count);
        count = count + 1;
    end
end
distanceinfocopy = distanceinfo;
% save the original pos for further use
posForFurtherUse = pos;
% % get the new pos (the pos for the unmatched points)
% pos = distanceinfocopy(:,1);
% pos = cell2mat(pos);
% m is the number of atoms in the new pos
[m, gar] = size(pos);

if ~(m == 0)
    
%get the distanceinfo and initialize all parameters
[distanceinfo,tenThousand] = getDistancek2(pos);
for i = 1:size(distanceinfo,1)
    if distanceinfocopy{i,3} == 1
        distanceinfo{i,3} = 1;
    end
end
[m, n] = size(distanceinfo);
a = -1;
b = -1;
c = -1;
row = m;
cursor = 1;
% big cell contains info about different distanceinfo
bigcell = {};
distanceinfoall = distanceinfo;
primitive={};
countprimitive = 0;
numregion0 = numregion;
stop = 0;
numberunidentified = size(discopy,1);
while stop == 0 && numberunidentified >100
    confidence = 0.0001;
    percent = 100/numberunidentified;
    trynum = min(numberunidentified,ceil(log(confidence)/log(1-percent)));
    numbers1 = 1:numberunidentified;
    numbers1 = numbers1';
    numbers2 = rand(numberunidentified,1);
    numbers = horzcat(numbers1,numbers2);
    sortednumbers = sortrows(numbers,2);

    numbers = sortednumbers(1:trynum,1);


found = 0;
for i = 1:trynum
    merged = 0;
    cursor = discopy(numbers(i));
%     % if the point is matched, skip
%     if distanceinfo{cursor,3} == 1
%         cursor = cursor + 1;
%         continue;
%     end
    % build primitive
    [a,b,c] = buildprimitive_bulk(cursor, distanceinfo);
    A = distanceinfo{cursor,1};
    B = A + a;
    C = A + b;
    D = A + c;
    idx = knnsearch(pos,[B;C;D]);
    disp(cursor);
    % if failed to build primitive, skip
    if (isequal(a,-1) || isequal(b,-1) || isequal(c,-1))||distanceinfo{idx(1),3} == 1||distanceinfo{idx(3),3} == 1||distanceinfo{idx(2),3} == 1
        continue;
    else
        inInterior = 1;
        tol = 1.0001;
        hull = [A;A+tol*a;A+tol*b;A+tol*c;A+tol*a+tol*b;A+tol*b+tol*c;A+tol*a+tol*c;A+tol*a+tol*b+tol*c];
        
        
        %extra check
        orders = distanceinfo{cursor,2};
        testpts = zeros(tenThousand,3);
        for j = 1:tenThousand
            testpts(j,:) = distanceinfo{orders(j),1};
        end
        inbox = inhull(testpts, hull);
        pointsInBox = zeros(tenThousand,3);
        count = 1;
        for j = 1:tenThousand
            if inbox(j)
                pointsInBox(count, :) = testpts(j,:);
                count = count +1;
            end
        end
        pointsInBox(count:tenThousand,:) = [];
        [IDX,D] =knnsearch(pos,pointsInBox);
        count5= 0;
        for j = 1:size(D,1)
            if distanceinfo{IDX(j),3} == 1 && D(j)<tol2
                count5=count5+1;
            end
        end
        if count5/size(D,1)>0.2
            continue
        end
%         neighborBox = genNeighborBox(pointsInBox, a, b, c,distanceinfo,cursor,tenThousand);
%         for j = 1:6
%             completelyInData = allInData(neighborBox{i,1}, neighborBox{i,2},distanceinfo,pos,tenThousand);
%             if ~completelyInData 
%                 inInterior = 0;
%                 break;
%             end
%         end
        [idx,dd] = knnsearch(pos,hull);
        for j = 1:8
            if dd(j)>tol2
                inInterior = 0;
                break;
            end
        end
        if ~inInterior
            continue
        end
        
        
        countprimitive = countprimitive+1;
        % currentPoint the coordinate of the current point
        currentPoint = distanceinfo{cursor, 1};
        % do the projection

        [region,perfect,distanceinfo] = projectionBulk(currentPoint,a,b,c,pos,distanceinfo,tenThousand);
        % take out duplicate points
        r = unique(region, 'rows');
        region = merge(r);
        
        % niggli reduction
        [v1, v2, v3, v4, v5, v6] = niggliReduce_fromThePaper(a, b, c);
        % determine bravais type
        str = niggliToLattice(v1, v2, v3, v4, v5, v6);
%         % for debugging
%         disp(str);
        % count the number of atoms in the region
        
        [idx,d] = knnsearch(pos,region);
        row = size(d,1);
        count3 = 1;
        while count3<row
            if d(count3)>tol2
                region(count3,:)=[];
                d(count3)=[];
                row = row-1;
            else
                count3 = count3 +1;
            end
        end
        
        sizeRegion = size(region);
        rowRegion = sizeRegion(1);
        % mark these points as matched
        idx = knnsearch(pos, region);
        [numinregion,gar] = size(idx);
        for j = 1:numinregion
            distanceinfo{idx(j),3} = 1;
            distanceinfocopy{idx(j),3} = 1;
        end

        % construct posForIndex to find the idx for the matched points
        posForIndex = distanceinfo(:,1);
        posForIndex = cell2mat(posForIndex);
        idx = knnsearch(posForIndex,region);
        found = 1;
        if size(primitive,1)>0
            for j = 1:size(primitive,1)
                in = inhull(region, info{j+numregion0,7});
                count4 = 0;
                for k = 1:size(in,1)
                    if in(k) == 1;
                        count4 = count4+1;
                    end
                end
                if count4/size(in,1)>0.2
                    info{j+numregion0,7}= push(region,info{j+numregion0,7});
                    info{j+numregion0,7} = merge(info{j+numregion0,7});
                    info{j+numregion0,8}= size(info{j+numregion0,7},1);
                    info{j+numregion0,3} = knnsearch(pos,info{j+numregion0,7});
                    info{j+numregion0,4} = knnsearch(pos,info{j+numregion0,7});
                    merged = 1;
                    break
                end
            end
        end
        if merged ==0
        % increment numregion and record information
        primitive{countprimitive,1} = [a;b;c];
        countprimitive = countprimitive+1;
        numregion = numregion + 1;
        info{numregion,1} = numregion;
        info{numregion,2} = idx;
        info{numregion,3} = idx;
        info{numregion,4} = idx;
        info{numregion,5} = str;
        info{numregion,6} = [a;b;c];
        info{numregion,7} = region;
        sizeRegion = size(region);
        rowRegion = sizeRegion(1);
        info{numregion,8} = rowRegion;
        end
    end
    break
end
    if found == 0
        stop = 1;
    else
        count = 1;
        [m,n] = size(distanceinfo);
        discopy = [];
%       take out all the points that have been matched and get discopy
        while count<=m
            if distanceinfo{count, 3} == 1
                count = count +1; 
            else
                discopy = vertcat(discopy, count);
                count = count + 1;
            end
        end
        numberunidentified = size(discopy,1);
    end
end
end
pos = posForFurtherUse;
disp('Finished finding Zeolite structures');

if size(primitive,1)>0
%unmatched points
 for i = 1:size(distanceinfo,1)
    if distanceinfo{i,3} == 0
        for j = 1:size(primitive,1)
            region = info{j+numregion0,7};
            abc = primitive{j,1};
            a = abc(1,:);
            b = abc(2,:);
            c = abc(3,:);
            neighbors = gen_adj(distanceinfo{i,1},a,b,c);
            
            [idx,d]=knnsearch(region,neighbors);
            if min(min(d))<tol2
                region = push(distanceinfo{i,1},region);
                info{j+numregion0,7} = push(distanceinfo{i,1},info{j+numregion0,7});
                idx = knnsearch(pos,distanceinfo{i,1});
                info{j+numregion0,2} = push(idx,info{j+numregion0,2});
                info{j+numregion0,3} = push(idx,info{j+numregion0,3});
                info{j+numregion0,4} = push(idx,info{j+numregion0,4});
                info{j+numregion0,8} = info{j+numregion0,8}+1;
                distanceinfo{i,3} = 1;
                distanceinfocopy{i,3} = 1;
            end
        end
    end
end
end
distanceinfo = distanceinfocopy;

%Amorphous
numregion = size(info,1)+1;
info{numregion,1} = numregion;
info{numregion,5} = 'Amorphous';
amorphousMatrix = [];
for i = 1:size(pos,1)
    if distanceinfo{i,3} == 0
        point = distanceinfo{i,1};
        amorphousMatrix = push(point,amorphousMatrix);
    end
end
info{numregion,7}=amorphousMatrix;
info{numregion,8}=size(amorphousMatrix,1);

% miller index
info = plot_structure(name, info, distanceinfo);
disp('Finished finding Miller Indices');



% RDF default
dr = 0.01;
rmax = -1;
rmin = 0;

e1 = blanks(0);
e2 = blanks(0);
RDFPlot(RDFDefault(distanceinfo,info,posForFurtherUse,dr,rmax,rmin, e1, e2), 'Default RDF')
assignin('base','info',info);
assignin('base','distanceinfo',distanceinfo);
save('infos.mat','distanceinfo','info','posForFurtherUse');
disp('Finished calculating default RDF');

    
