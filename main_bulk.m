% read data from file
% pos is the original matrix
[name, num, pos] = read_xyz_v3('POSCARMFIBulk.txt',1);
%get the distance info
[distanceinfo] = getDistancek(pos,num);
[m, n] = size(distanceinfo);
count = 1;
a = -1;
b = -1;
c = -1;
while (isequal(a,-1) || isequal(b,-1) || isequal(c,-1)) && count <m
    currentPoint = distanceinfo{count, 1};
    [a,b,c] = buildprimitive_bulk(count, distanceinfo);
    count = count +1;
end

disp(a);
disp(b);
disp(c);
disp(currentPoint);




% 
% 
% %info is the cell that contains all the known info of the data
% %the first column contains the region number
% %the second column contains the interior points
% %the third colum contains boundary points
% %the fourth column contains the region points
% %the fifth column contains the lattice type
% %the sixth column contains the primitive basis of that region
% %the seventh column contains the perfect position of that atom
% %the eighth column contains the order of atom type
% info = {};
% 
% % numUnidentified keeps track of the number of points that have not been
% % identified yet
% sizepos = size(pos);
% row = sizepos(1);
% cursor = 1;
% numregion = 0;
% while row >= cursor
%     current_pt =  distanceinfo{cursor, 1};
%     if distanceinfo{cursor, 3} == 0
%         
%     % build primitive from the 50 nearest neighbor of the starting point
%     [A,B,C,D,a,b,c] = buildprimitive(distanceinfo{cursor, 2}, current_pt, pos);
%     
%     
%     if ~isequal(A, -1)
%         % niggli reduction
%         [v1, v2, v3, v4, v5, v6, x] = niggliReduce_fromThePaper(a, b, c);
%     
%         if isEqual(v1,v2,x) && isEqual(v2, v3,x)
%             disp('ri');
%         end
%         % determine bravais type
%         str = niggliToLattice(v1, v2, v3, v4, v5, v6, 0.01);
%     
%         % generate 6 neighbors of the starting point
%         neighbor = gen6(A, a, b, c);
%     
%         % check if all points in the neighbor are in the data 
%         allNeighborsInData = 1;
%         for i = 1:6
%             point = neighbor(i,:);
%             M = distanceinfo{cursor,2};
%             searchArea = zeros(48,3);
%             for j = 1:48
%                 searchArea(j,:) = distanceinfo{M(j),1};
%             end
%             [garbage,D] = dsearchn(searchArea, point);
%             if D>0.5
%                 allNeighborsInData = 0;
%                 break;
%             end
%         end
%         
%         if allNeighborsInData
%             % show bases and A,B,C,D,E,F
%             disp('vector');
%             disp(a);
%             disp(b);
%             disp(c);
%             disp('Niggli');
%             disp(v1);
%             disp(v2);
%             disp(v3);
%             disp(v4);
%             disp(v5);
%             disp(v6);
%             
%             %do the projection
%             [boundary, interior,region,perfect, distanceinfo, atom] = projection_Xuchen_fast2(current_pt,a,b,c,pos,distanceinfo);
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
%             info{numregion,7} = perfect;
%             info{numregion,8} = atom;
%             
%         end
%     end
%     end
%  cursor = cursor + 1;
% 
% end
% 
% 
% 
% 
% 
% 
% 
% 
% %interlocking handling
% cursor = 1;
% while cursor <= row
%      if distanceinfo{cursor, 3} == 1
%          cursor = cursor + 1;
%      else
%              current_pt =  distanceinfo{cursor, 1};
%         if distanceinfo{cursor, 3} == 0
% 
%         % build primitive from the 50 nearest neighbor of the starting point
%         [A,B,C,D,a,b,c] = buildprimitive_interlock_fast(distanceinfo{cursor, 2}, current_pt,pos);
% 
% 
%         if ~isequal(A, -1)
%             % niggli reduction
%             [v1, v2, v3, v4, v5, v6, x] = niggliReduce_fromThePaper(a, b, c);
% 
% %             if isEqual(v1,v2,x) && isEqual(v2, v3,x)
% %                 disp('ri');
% %             end
%             % determine bravais type
%             str = niggliToLattice(v1, v2, v3, v4, v5, v6, x*1000);
% 
%             % generate 6 neighbors of the starting point
%             neighbor = gen6(A, a, b, c);
% 
%             % check if all points in the neighbor are in the data 
%             allNeighborsInData = 1;
%             for i = 1:6
%                 point = neighbor(i,:);
%                 [garbage,D] = dsearchn(pos, point);
%                 if D>0.5
%                     allNeighborsInData = 0;
%                     break;
%                 end
%             end
% 
%             if allNeighborsInData
%                 % show bases and A,B,C,D,E,F
%                 disp('vector');
%                 disp(a);
%                 disp(b);
%                 disp(c);
%                 disp('Niggli');
%                 disp(v1);
%                 disp(v2);
%                 disp(v3);
%                 disp(v4);
%                 disp(v5);
%                 disp(v6);
% 
%                 %do the projection
%                 [boundary, interior,region,perfect, distanceinfo] = projection_Xuchen_fast_interlocking(current_pt,a,b,c,pos,distanceinfo);
%                 sizeRegion = size(region);
%                 rowRegion = sizeRegion(1);
% 
%                 % mark these points as matched
%                 for k = 1: rowRegion
%                     distanceinfo{region(k, 1),3} = 1;
%                 end
%                 exist = 0;
% %                 for k = 1:rowRegion
% %                     index = random('unid', rowRegion);
% %                     order = region(index);
% %                     point = distanceinfo{index, 1};
% %                     for q = 1:numregion
% %                         in = inhull(point, info{q,7});
% %                         if in == 1;
% %                             exist = 1;
% %                             break;
% %                         end
% %                     end
% %                     if exist == 1
% %                         break;
% %                     end
% %                 end
%                 count  = 0;
%                 for q = 1:numregion
%                     in = inhull(perfect, info{q,7});
%                     for p = 1:rowRegion
%                         if in(p) == 1
%                             count = count + 1;
%                         end
%                     end
%                     if count/rowRegion >0.2
%                         exist = 1;
%                         break;
%                     end
%                     count = 0;
%                 end
% 
%                 disp('Boundary');
%                 disp(boundary);
%                 disp('Interior');
%                 disp(interior);
%                 disp('Region');
%                 disp(region);
%                 if exist == 1
%                     info{q,4} = vertcat(info{q,4}, region);
%                     info{q,7} = vertcat(info{q,7}, perfect);
%                 else
%                     numregion = numregion + 1;
%                     info{numregion,1} = numregion;
%                     info{numregion,2} = interior;
%                     info{numregion,3} = boundary;
%                     info{numregion,4} = region;
%                     info{numregion,5} = str;
%                     info{numregion,6} = [a;b;c];
%                     info{numregion,7} = perfect;
%                 end
% 
%             end
%         end
%         end
%         cursor = cursor + 1;
%      end
%     
%     
%     
%     
%     
% end
% 
% 
% 
% 
% 
% 
% 
% 
% %Here's where we check all the points that are still unmatched. 
% % I'm assuming that M is our matrix of unmatched points. I'm worried that
% % this might not actually be the case, but I'll test this assumption after
% % finishing this code. 
% cursor = 1;
% doneSearching = 1;
% while cursor <= row 
%     
%     if distanceinfo{cursor, 3} == 1
%         cursor = cursor + 1;
%     else
%         current_pt = pos(cursor, :);
%         M = distanceinfo{cursor,2};
%         near6idx = zeros(1,7);
%         for j = 1:7
%             near6idx(j) = M(j);
%         end
% 
%         found = 0;
%         for i = 2:7
%             current_neighbor = near6idx(1,i);
%             for j = 1:numregion
%                 order = dsearchn(info{j,4}, current_neighbor);
%                 matrix = info{j,4};
%                 match = matrix(order, 1);
%                 if match == current_neighbor
%                     abc = info{j, 6};
%                     a = abc(1,:);
%                     b = abc(2,:);
%                     c = abc(3,:);
%                     adj = gen6(distanceinfo{match, 1}, a, b, c);
%                     
%                     for k = 1:6
%                         if is_same(current_pt, adj(k,:))
%                             if ~isequal(distanceinfo{match,4},[])
%                                 adjPerfect = gen6(distanceinfo{match,4},a,b,c);
%                                 info{j, 7} = push(adjPerfect(k,:), info{j, 7});
%                                 distanceinfo{cursor,4} = adjPerfect(k,:);
%                             end
%                             info{j, 4} = push(cursor, info{j, 4});
%                             info{j, 3} = push(cursor, info{j, 3});
%                             
%                             distanceinfo{cursor,3} = 1;
%                             
%                             doneSearching = 0;
%                             found = 1;
%                         break;
%                         end
%                     end
%                 end
%                 if found ==1
%                     break;
%                 end
%             end
%             
%             if found ==1
%                 break;
%             end
%             
%         end
%         cursor = cursor+1;
%         if cursor > row && doneSearching == 0
%             cursor = 1;
%             doneSearching = 1; 
%         end
%     end
% 
%         
% end
% 
% 
% % miller index
% 
% plot_structure(name, info, distanceinfo);
% 
%         
% 
%  
%  
%  
%  
