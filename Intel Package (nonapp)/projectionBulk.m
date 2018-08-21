function [region, perfect, distanceinfo] = projectionBulk(A, a,b,c, positions,distanceinfo,tenThousand)
% This function projects the bases to the entire space

% % To start with, the only point in checklist is our starting point A
% % checklist is a queue, and it contains the point number
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
perfectChecklist = pointsInBox;
ref = start;
region = [];
perfect = [];

while ~isempty(checklist)
    [refNum,ref] = pop(ref);
    [pointsInBox,checklist] = popBulk(checklist,numOfPoints);
    region = push(pointsInBox, region);
    neighborBox = genNeighborBox(pointsInBox, a, b, c,distanceinfo,refNum,tenThousand);
    for i = 1:14
        inChecklist = alreadyIn(neighborBox{i,1},checklist);
        inRegion = alreadyIn(neighborBox{i,1},region);
        if ~inChecklist && ~inRegion
            completelyInData = allInData(neighborBox{i,1}, neighborBox{i,2},distanceinfo,positions,tenThousand);
            if completelyInData
                checklist = push(neighborBox{i,1}, checklist);
                ref = push(neighborBox{i,2}, ref);
            else
                match = findMatch(neighborBox{i,1},neighborBox{i,2},distanceinfo,positions,tenThousand);
                region = push(match, region);
            end
        end
    end
end
    

end


function [neighborBox] = genNeighborBox(pointsInBox, a, b, c,distanceinfo,refNum,tenThousand)

neighborBox = cell(26,1);
neighborBox{1,1} = moveBox(pointsInBox, a);
neighborBox{2,1} = moveBox(pointsInBox, -a);
neighborBox{3,1} = moveBox(pointsInBox, b);
neighborBox{4,1} = moveBox(pointsInBox, -b);
neighborBox{5,1} = moveBox(pointsInBox, c);
neighborBox{6,1} = moveBox(pointsInBox, -c);
neighborBox{7,1} = moveBox(pointsInBox, a+b+c);
neighborBox{8,1} = moveBox(pointsInBox, a+b-c);
neighborBox{9,1} = moveBox(pointsInBox, a-b+c);
neighborBox{10,1} = moveBox(pointsInBox, a-b-c);
neighborBox{11,1} = moveBox(pointsInBox, -a+b+c);
neighborBox{12,1} = moveBox(pointsInBox, -a+b-c);
neighborBox{13,1} = moveBox(pointsInBox, -a-b+c);
neighborBox{14,1} = moveBox(pointsInBox, -a-b-c);

orders = distanceinfo{refNum, 2};
points = zeros(tenThousand,3);
for i = 1:tenThousand
    points(i,:) = distanceinfo{orders(i),1};
end
refPoint = distanceinfo{refNum, 1};
[idx,garbage] = dsearchn(points, (refPoint + a));
neighborBox{1,2} = orders(idx);

[idx,garbage] = dsearchn(points, (refPoint - a));
neighborBox{2,2} = orders(idx);

[idx,garbage] = dsearchn(points, (refPoint + b));
neighborBox{3,2} = orders(idx);

[idx,garbage] = dsearchn(points, (refPoint-b));
neighborBox{4,2} = orders(idx);

[idx,garbage] = dsearchn(points, (refPoint + c));
neighborBox{5,2} = orders(idx);

[idx,garbage] = dsearchn(points, (refPoint-c));
neighborBox{6,2} = orders(idx);

[idx,garbage] = dsearchn(points, (refPoint+a+b+c));
neighborBox{7,2} = orders(idx);
[idx,garbage] = dsearchn(points, (refPoint+a+b-c));
neighborBox{8,2} = orders(idx);
[idx,garbage] = dsearchn(points, (refPoint+a-b+c));
neighborBox{9,2} = orders(idx);
[idx,garbage] = dsearchn(points, (refPoint+a-b-c));
neighborBox{10,2} = orders(idx);
[idx,garbage] = dsearchn(points, (refPoint-a+b+c));
neighborBox{11,2} = orders(idx);
[idx,garbage] = dsearchn(points, (refPoint-a+b-c));
neighborBox{12,2} = orders(idx);
[idx,garbage] = dsearchn(points, (refPoint-a-b+c));
neighborBox{13,2} = orders(idx);
[idx,garbage] = dsearchn(points, (refPoint-a-b-c));
neighborBox{14,2} = orders(idx);

end






function [newBox] = moveBox(pointsInBox, vector)
[p,q] = size(pointsInBox);
vectorBulk = repmat(vector, p,1);
newBox = pointsInBox + vectorBulk;
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

function [allin] = allInData(testpts,refNum,distanceinfo, positions, tenThousand)
global tol1 tol2 tol3 tol4 tol5
orders = distanceinfo{refNum, 2};
points = zeros(tenThousand,3);
for i = 1:tenThousand
    points(i,:) = distanceinfo{orders(i),1};
end

[garbage, d] = knnsearch(points,testpts);
[m, n] = size(d);
allin = 1;
count = 0;
for j = 1:m
    if d(j) > tol2
        allin = 0;
        break
    end
end
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
    if d(j) < tol2
        match = push(testpts(j,:), match);
    end
end

end