function allNeighborsInData = checkInterior(A,a,b,c,distanceinfo,cursor)

neighbor = gen6(A, a, b, c);
allNeighborsInData = 1;
for i = 1:6
    point = neighbor(i,:);
    M = distanceinfo{cursor,2};
    searchArea = zeros(48,3);
    for j = 1:48
        searchArea(j,:) = distanceinfo{M(j),1};
    end
    [garbage,D] = dsearchn(searchArea, point);
    if D>0.01
        allNeighborsInData = 0;
        break;
    end
end