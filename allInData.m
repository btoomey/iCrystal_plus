function [allin] = allInData(testpts,refNum,distanceinfo, positions, tenThousand)
global tol1 tol2 tol3 tol4 tol5
orders = distanceinfo{refNum, 2};
points = zeros(tenThousand,3);
for i = 1:tenThousand
    points(i,:) = distanceinfo{orders(i),1};
end

[garbage, d] = knnsearch(points,testpts);
[m, n] = size(d);
count = 0;
for j = 1:m
    if d(j) > tol2
        count = count + 1;
    end
end
if count/m >0.05
    allin = 0;
    else 
    allin = 1;
end
end