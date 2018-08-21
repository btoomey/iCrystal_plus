function [neighborBox] = genNeighborBox(pointsInBox, a, b, c,distanceinfo,refNum,tenThousand)

neighborBox = cell(26,2);
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
neighborBox{15,1} = moveBox(pointsInBox, +a+b);
neighborBox{16,1} = moveBox(pointsInBox, +a-b);
neighborBox{17,1} = moveBox(pointsInBox, -a+b);
neighborBox{18,1} = moveBox(pointsInBox, -a-b);
neighborBox{19,1} = moveBox(pointsInBox, +a-c);
neighborBox{20,1} = moveBox(pointsInBox, +a+c);
neighborBox{21,1} = moveBox(pointsInBox, +b+c);
neighborBox{22,1} = moveBox(pointsInBox, +b-c);
neighborBox{23,1} = moveBox(pointsInBox, -a+c);
neighborBox{24,1} = moveBox(pointsInBox, -a-c);
neighborBox{25,1} = moveBox(pointsInBox, -b+c);
neighborBox{26,1} = moveBox(pointsInBox, -b-c);

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
[idx,garbage] = dsearchn(points, (refPoint+a+b));
neighborBox{15,2} = orders(idx);
[idx,garbage] = dsearchn(points, (refPoint+a-b));
neighborBox{16,2} = orders(idx);
[idx,garbage] = dsearchn(points, (refPoint-a+b));
neighborBox{17,2} = orders(idx);
[idx,garbage] = dsearchn(points, (refPoint-a-b));
neighborBox{18,2} = orders(idx);
[idx,garbage] = dsearchn(points, (refPoint+a-c));
neighborBox{19,2} = orders(idx);
[idx,garbage] = dsearchn(points, (refPoint+a+c));
neighborBox{20,2} = orders(idx);
[idx,garbage] = dsearchn(points, (refPoint+b+c));
neighborBox{21,2} = orders(idx);
[idx,garbage] = dsearchn(points, (refPoint+b+c));
neighborBox{22,2} = orders(idx);
[idx,garbage] = dsearchn(points, (refPoint-a+c));
neighborBox{23,2} = orders(idx);
[idx,garbage] = dsearchn(points, (refPoint-a-b));
neighborBox{24,2} = orders(idx);
[idx,garbage] = dsearchn(points, (refPoint+b-c));
neighborBox{25,2} = orders(idx);
[idx,garbage] = dsearchn(points, (refPoint-a-b));
neighborBox{26,2} = orders(idx);


end