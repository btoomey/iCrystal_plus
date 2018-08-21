% read data from file
% pos is the original matrix
[name, num, pos] = read_xyz_v3('multiGrainCopperAnnealed.txt',499911);

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
        
                
    

%     matchflag = 0;
%     %This variable keeps track of whether the current point is a match.
%     %Once we get a match, we'll update matchflag to true and break out of
%     %the for i = 1:rows loop.
%     where = 0;
%      for j = 1:rowinfo
%         if ~isequal(0, searchPoint(info{j,4}, A))
%              where = j;
%         end
%      end
%      if where ~= 0
%          abc = info{where, 6};
%          Aa = abc(1,:);
%          Ab = abc(2,:);
%          Ac = abc(3,:);
%          %[AA, AB, AC, AD, Aa, Ab, Ac] = buildprimitive(pos1, A);
%          %[adj_A] = gen_adj(A, Aa, Ab, Ac);
%          
%          adj = gen6(current_pt, Aa, Ab, Ac);
%          
%          for i = 1:6
%              if ~isequal(0, searchPoint(info{where, 4}, adj(i, :)))
%                  info{where,4} = vertcat(info{where,4}, current_pt);
%                  newp = 1;
%                  matchflag = 1;
%                  rows =rows -1;
%                  %Then our current point is a "good enough" match
%                   %So we need to update the boundary list to include it
%                   %boundary = vertcat(boundary, current_pt);
% %We've found that this point is in the boundary region, so there's no
% %reason to check any of its other neighbors
%                   break
%              end
%          end
%      end
% 
%  if (matchflag==1)
%      continue
%  end
%  
%      where = 0;
%      for j = 1:rowinfo
%         if ~isequal(0, searchPoint(info{j,4}, B))
%              where = j;
%         end
%      end
%      if where ~= 0
%          abc = info{where, 6};
%          Ba = abc(1,:);
%          Bb = abc(2,:);
%          Bc = abc(3,:);
%          %[AA, AB, AC, AD, Aa, Ab, Ac] = buildprimitive(pos1, A);
%          %[adj_A] = gen_adj(A, Aa, Ab, Ac);
%          
%          adj = gen6(current_pt, Ba, Bb, Bc);
%          
%          for i = 1:6
%              if ~isequal(0, searchPoint(info{where, 4}, adj(i, :)))
%                  info{where,4} = vertcat(info{where,4}, current_pt);
%                  newp = 1;
%                  rows =rows -1;
%                  matchflag = 1;
%                  %Then our current point is a "good enough" match
%                   %So we need to update the boundary list to include it
%                   %boundary = vertcat(boundary, current_pt);
% %We've found that this point is in the boundary region, so there's no
% %reason to check any of its other neighbors
%                   break
%              end
%          end
%      end
% 
%  if (matchflag==1)
%      continue
%  end
%  
%      where = 0;
%      for j = 1:rowinfo
%         if ~isequal(0, searchPoint(info{j,4}, C))
%              where = j;
%         end
%      end
%      if where ~= 0
%          abc = info{where, 6};
%          Ca = abc(1,:);
%          Cb = abc(2,:);
%          Cc = abc(3,:);
%          %[AA, AB, AC, AD, Aa, Ab, Ac] = buildprimitive(pos1, A);
%          %[adj_A] = gen_adj(A, Aa, Ab, Ac);
%          
%          adj = gen6(current_pt, Ca, Cb, Cc);
%          
%          for i = 1:6
%              if ~isequal(0, searchPoint(info{where, 4}, adj(i, :)))
%                  info{where,4} = vertcat(info{where,4}, current_pt);
%                  newp = 1;
%                  rows =rows -1;
%                  matchflag = 1;
%                  %Then our current point is a "good enough" match
%                   %So we need to update the boundary list to include it
%                   %boundary = vertcat(boundary, current_pt);
% %We've found that this point is in the boundary region, so there's no
% %reason to check any of its other neighbors
%                   break
%              end
%          end
%      end
% 
%  if (matchflag==1)
%      continue
%  end
%  
%      where = 0;
%      for j = 1:rowinfo
%         if ~isequal(0, searchPoint(info{j,4}, D))
%              where = j;
%         end
%      end
%      if where ~= 0
%          abc = info{where, 6};
%          Da = abc(1,:);
%          Db = abc(2,:);
%          Dc = abc(3,:);
%          %[AA, AB, AC, AD, Aa, Ab, Ac] = buildprimitive(pos1, A);
%          %[adj_A] = gen_adj(A, Aa, Ab, Ac);
%          
%          adj = gen6(current_pt, Da, Db, Dc);
%          
%          for i = 1:6
%              if ~isequal(0, searchPoint(info{where, 4}, adj(i, :)))
%                  info{where,4} = vertcat(info{where,4}, current_pt);
%                  newp = 1;
%                  rows =rows -1;
%                  matchflag = 1;
%                  %Then our current point is a "good enough" match
%                   %So we need to update the boundary list to include it
%                   %boundary = vertcat(boundary, current_pt);
% %We've found that this point is in the boundary region, so there's no
% %reason to check any of its other neighbors
%                   break
%              end
%          end
%      end
% 
%  if (matchflag==1)
%      continue
%  end
%  
%      where = 0;
%      for j = 1:rowinfo
%         if ~isequal(0, searchPoint(info{j,4}, E))
%              where = j;
%         end
%      end
%      if where ~= 0
%          abc = info{where, 6};
%          Ea = abc(1,:);
%          Eb = abc(2,:);
%          Ec = abc(3,:);
%          %[AA, AB, AC, AD, Aa, Ab, Ac] = buildprimitive(pos1, A);
%          %[adj_A] = gen_adj(A, Aa, Ab, Ac);
%          
%          adj = gen6(current_pt, Ea, Eb, Ec);
%          
%          for i = 1:6
%              if ~isequal(0, searchPoint(info{where, 4}, adj(i, :)))
%                  info{where,4} = vertcat(info{where,4}, current_pt);
%                  newp = 1;
%                  rows =rows -1;
%                  matchflag = 1;
%                  %Then our current point is a "good enough" match
%                   %So we need to update the boundary list to include it
%                   %boundary = vertcat(boundary, current_pt);
% %We've found that this point is in the boundary region, so there's no
% %reason to check any of its other neighbors
%                   break
%              end
%          end
%      end
% 
%  if (matchflag==1)
%      continue
%  end
%  
%      where = 0;
%      for j = 1:rowinfo
%         if ~isequal(0, searchPoint(info{j,4}, F))
%              where = j;
%         end
%      end
%      if where ~= 0
%          abc = info{where, 6};
%          Fa = abc(1,:);
%          Fb = abc(2,:);
%          Fc = abc(3,:);
%          %[AA, AB, AC, AD, Aa, Ab, Ac] = buildprimitive(pos1, A);
%          %[adj_A] = gen_adj(A, Aa, Ab, Ac);
%          
%          adj = gen6(current_pt, Fa, Fb, Fc);
%          
%          for i = 1:6
%              if ~isequal(0, searchPoint(info{where, 4}, adj(i, :)))
%                  info{where,4} = vertcat(info{where,4}, current_pt);
%                  newp = 1;
%                  rows =rows -1;
%                  matchflag = 1;
%                  %Then our current point is a "good enough" match
%                   %So we need to update the boundary list to include it
%                   %boundary = vertcat(boundary, current_pt);
% %We've found that this point is in the boundary region, so there's no
% %reason to check any of its other neighbors
%                   break
%              end
%          end
%      end
% 
%  if (matchflag==1)
%      continue
%  end
%  
%  
% end
% end

 
 
 
 
