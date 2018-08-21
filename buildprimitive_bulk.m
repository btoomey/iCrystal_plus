function [a,b,c ] = buildprimitive_bulk(P,distanceinfo)
%buildprimitive builds the primitive cell for bulk structures
global tol1 tol2 tol3 tol4 tol5
[max, garbage] = size(distanceinfo);
%We initially planned on using 2000 neighbors, but we increased the number
%to 10000 in order to accomodate larger zeolite unit cells. Again, we take
%the minimum of 10000 and the number of atoms in order to ensure that we
%stay within the range of the sample. 
twoThousand  = min(10000, max);
startPoint = distanceinfo{P,1};
orders = distanceinfo{P,2};
orders = orders(:,2:twoThousand);
orders = orders';
points = zeros(twoThousand - 1,3);
count = 1;
foundBasis = 0;
basis = zeros(3,3);
matchlist = [];
for i = 1: twoThousand - 1
    points(i,:) = distanceinfo{orders(i),1};
end
twoHundred = min(1500,max);
for vectorFinder = 1:twoHundred-1
    endPoint = points(vectorFinder, :);
    vector = endPoint - startPoint;
    match = shiftAndMatch(vector, points);
    if match
        matchlist = push(vector, matchlist);
    end
end
    [row, gar] = size(matchlist);
    if row<3
        a = -1;
        b = -1;
        c = -1;
    else
        
        matchlist = sortlength(matchlist);
        nextpos = 4;
        a = matchlist(1,:);
        b = matchlist(2,:);
        c = matchlist(3,:);
        theta = 180 * acos(dot(a,b)/(norm(a)*norm(b))) / pi;
        while (abs(theta)<tol1)||(isEqual(theta, 180, tol1))
            if nextpos > row
                a = -1;
                b = -1;
                c = -1;
                break
            end
            b = c;  %if a and b are parallel change b to c
            c = matchlist(nextpos,:);
            nextpos = nextpos+1;
            theta = 180 * acos(dot(a,b)/(norm(a)*norm(b))) / pi;
        end
        if isequal(a,-1)||isequal(b,-1)||isequal(c,-1)
            return
        end
        while iscoplanar(a,b,c) == 1
        if nextpos > row
            a = -1;
            b = -1;
            c = -1;
            break
        end
        % if coplanar, change c to the next shortest vector
        c = matchlist(nextpos,:);
            nextpos = nextpos+1;
        end
    end
end

    
function [sorted] = sortlength(unsorted)
[m,n] = size(unsorted);
length = zeros(m,2);
sorted = zeros(m,3);
for i=1:m
    length(i,1) = i;
    length(i,2) = norm(unsorted(i,:));
end
sortedlength = sortrows(length,2);
for i = 1:m
    order = sortedlength(i,1);
    sorted(i,:) = unsorted(order,:);
end

end


function [ bool ] = shiftAndMatch(vector, points)
global tol1 tol2 tol3 tol4 tol5
nonMatch = 0;
[row, gar] = size(points);
fifty = min(15, row);
shiftingPoints = points(1:fifty, :);
shift = repmat(vector, fifty, 1);
shiftedPoints = shiftingPoints + shift;


[IDX, D] = knnsearch(points, shiftedPoints);
for i = 1:fifty
    if D(i)> tol2
        nonMatch = nonMatch + 1;
    end
end
if nonMatch > 1
    bool = 0;
else 
    bool = 1;
end
end
