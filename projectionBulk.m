function [region, perfect, distanceinfo] = projectionBulk(A, a,b,c, positions,distanceinfo,tenThousand)
% This function projects the bases to the entire space

% % To start with, the only point in checklist is our starting point A
% % checklist is a queue, and it contains the point number
% This function is similar to projection. But instead of checking single
% points as projection does, it checkes boxes of points.
global tol1 tol2 tol3 tol4 tol5
start = dsearchn(positions, A);


% find all points in the large box
tol = 1.0001;

hull = [A;A+tol*a;A+tol*b;A+tol*c;A+tol*a+tol*b;A+tol*b+tol*c;A+tol*a+tol*c;A+tol*a+tol*b+tol*c];
orders = distanceinfo{start,2};
testpts = zeros(tenThousand,3);
for i = 1:tenThousand
    testpts(i,:) = distanceinfo{orders(i),1};
end
inbox = inhull(testpts, hull);
pointsInBox = zeros(tenThousand,3);
count = 1;
for i = 1:tenThousand
    if inbox(i)
        pointsInBox(count, :) = testpts(i,:);
        count = count +1;
    end
end
pointsInBox(count:tenThousand,:) = [];
[numOfPoints, garbage] = size(pointsInBox);
checklist = pointsInBox;
ref = start;
region = [];
perfect = [];
further = [];
furtherref=[];
while ~isempty(checklist)
    [refNum,ref] = pop(ref);
    [pointsInBox,checklist] = popBulk(checklist,numOfPoints);
    region = push(pointsInBox, region);
    neighborBox = genNeighborBox(pointsInBox, a, b, c,distanceinfo,refNum,tenThousand);
    for i = 1:26
        inChecklist = alreadyIn(neighborBox{i,1},checklist);
        inRegion = alreadyIn(neighborBox{i,1},region);
        if ~inChecklist && ~inRegion
            completelyInData = allInData(neighborBox{i,1}, neighborBox{i,2},distanceinfo,positions,tenThousand);
            if completelyInData
                checklist = push(neighborBox{i,1}, checklist);
                ref = push(neighborBox{i,2}, ref);
            else
                if isempty(further)
                    inFurther = 0;
                else
                    inFurther = alreadyIn(neighborBox{i,1},further);
                end
                if ~inFurther
                    further = push(neighborBox{i,1}, further);
                end
                furtherref = push(neighborBox{i,2}, furtherref);
                match = findMatch(neighborBox{i,1},neighborBox{i,2},distanceinfo,positions,tenThousand);
                region = push(match, region);
            end
        end
    end
end
r = unique(region, 'rows');
        region = merge(r); 
        
while ~isempty(further)
    [refNum,furtherref] = pop(furtherref);
    [pointsInBox,further] = popBulk(further,numOfPoints);
    neighborBox = genNeighborBox(pointsInBox, a, b, c,distanceinfo,refNum,tenThousand);
    for i = 1:26
        match = findMatch(neighborBox{i,1},neighborBox{i,2},distanceinfo,positions,tenThousand);
        region = push(match, region);
    end
end
end


function [in] = alreadyIn(test, xyz)
[garbage, d] = knnsearch(xyz,test);

if norm(d) > 5
    in = 0;
else 
    in = 1;
end
[m,n] =size(test);
[p,q] = size(xyz);
if m>p
    in = 0;
end
end


function [points, newlist] = popBulk(list, num)
sizepop = size(list);
rowpop = sizepop(1);
points = list(rowpop-num+1 : rowpop, :);
newlist = list;
newlist(rowpop-num+1 : rowpop, :) = [];
end



function [match] = findMatch(testpts,refNum,distanceinfo, positions, tenThousand)
global tol1 tol2 tol3 tol4 tol5
orders = distanceinfo{refNum, 2};
points = zeros(tenThousand,3);
for i = 1:tenThousand
    points(i,:) = distanceinfo{orders(i),1};
end
[garbage, d] = knnsearch(points,testpts);
[m, n] = size(d);

match = [];
for j = 1:m
    if d(j) < tol2/2
        match = push(testpts(j,:), match);
    end
end

end