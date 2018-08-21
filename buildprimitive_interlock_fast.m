function [A, B, C, D, a, b, c] = buildprimitive_interlock_fast(M, P, pos)
% Given a dataset, this function builds a primitive cell starting at the
% first point in the data set with three shortest noncoplanar vectors
% similar to norm build primitive
global tol1 tol2 tol3 tol4 tol5
errormsg = 0;
[m,gar] = size(pos);
NUM = min(m,48);
trynum = 1;
% assign starting point
A = P;

% build the matrix of the end points
Abulk = repmat(A,NUM -1,1);
points = zeros(NUM -1, 3);
for i = 1:NUM -1
points(i,:) = pos(M(i+1), :);
end

% build the matrix of potential primitive vectors
vector = points-Abulk;

nextpos = 4;

% pass indicates whether the primitive vectors passed the criteriors of
% being the actual lattice vectors
pass = 0;

while trynum+2<NUM 
    a = vector(trynum,:);
    b = vector(trynum+1,:);
    c = vector(trynum+2,:);
    % check if a and b are parallel
    coline = 1;
    while coline == 1  
        if nextpos >= NUM
            errormsg = -1;
            break;
        end

        theta = 180 * acos(dot(a,b)/(norm(a)*norm(b))) / pi;
        if (abs(theta)<tol1)||(isEqual(theta, 180, tol1))
            b = c;  %if a and b are parallel change b to c
            c = vector(nextpos,:);
            nextpos = nextpos+1;
        else
            coline = 0;
        end
    end

    if errormsg ~= -1
    % check if a, b, c are coplanar
        while iscoplanar(a,b,c) == 1

            if nextpos >= NUM
                errormsg = -1;
                break
            end
            % if coplanar, change c to the next shortest vector
            c = vector(nextpos,:);
                nextpos = nextpos+1;
        end
    end

    if errormsg == -1
        A = -1;
        B = -1;
        C = -1;
        D = -1;
    end
    
    
    % r1 r2 and r3 are the points in the directions of -a -b, -c
    % if a,b,c are lattice vectors, r1 r2 r3 would be in the sample
    % however, if a,b,c aren't lattice vectors, r1, r2 and r3 wouldn't be
    % in the sample
    r1 = A - a;
    r2 = A - b;
    r3 = A - c;

    % check whether r1 r2 and r3 are in the sample
    [garbage, d] = dsearchn(points, r1);
    criteriaA1 = (d < tol2);
    [garbage, d] = dsearchn(points, r2);
    criteriaA2 = (d < tol2);
    [garbage, d] = dsearchn(points, r3);
    criteriaA3 = (d < tol2);
    if (criteriaA1 && criteriaA2 && criteriaA3)
        pass = 1;
        break;
    else
        trynum = trynum +1;
    end

end
% if the correct primitive vectors are not found, send error msg
if pass == 0
    A = -1;
    B = -1;
    C = -1;
    D = -1;
else
    B = A + a;
    C = A + b;
    D = A + c;
end

end


    



