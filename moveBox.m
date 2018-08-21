function [newBox] = moveBox(pointsInBox, vector)
[p,q] = size(pointsInBox);
vectorBulk = repmat(vector, p,1);
newBox = pointsInBox + vectorBulk;
end