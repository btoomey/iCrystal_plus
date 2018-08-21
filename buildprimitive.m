function [A, B, C, D, a, b, c] = buildprimitive(callnum, P, pos)
% Given a dataset, this function builds a primitive cell starting at the
% first point in the data set with three shortest noncoplanar vectors
% M is the list of call numbers of potential end points of primitive
% vectors
global tol1 tol2 tol3 tol4 tol5
% initial errormsg to 0
errormsg = 0;

% pick 27 nearest neighbors of the starting point if the sample has at
% least 27 points
[m,gar] = size(pos);
NUM = min(27,m);

% A is the starting point
A = P;

Abulk = repmat(A,NUM -1,1);
points = zeros(NUM -1, 3);
for i = 1:NUM -1
points(i,:) = pos(callnum(i+1), :);
end

% vector is a 26x3 matrix containing the shortest 27 vectors eminatiung
% from point A
vector = points-Abulk;
if size(vector,1) < 4
	a = -1;
	b = -1;
	c = -1;
	A = -1;
	return
end

% let a,b,c be the three shortest vectors
a = vector(1,:);
b = vector(2,:);
c = vector(3,:);

% nextpos keeps track of the position in the matrix 'vector'
nextpos = 4;


% check if a and b are parallel
coline = 1;
while coline == 1  
    
    % if all vectors are coline, send error msg
    if nextpos >= NUM
        errormsg = -1;
        break;
    end
    
    % theta is the angle (in degree) between a and b.
    theta = 180 * acos(dot(a,b)/(norm(a)*norm(b))) / pi;
    
    % rule a&b as coline if they are withing 3 degrees of being parallel
    if (abs(theta)<tol1)||(isEqual(theta, 180, tol1))     
        b = c;  %if a and b are parallel change b to c
        c = vector(nextpos,:); % c to the next vector
        nextpos = nextpos+1; % increment nextpos
    else
        coline = 0;
    end
end


if errormsg ~= -1
% check if a, b, c are coplanar
    % if all vectors are coline, send error msg
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

% if there is an error, send the error to outer functions.
if errormsg == -1
    A = -1;
    B = -1;
    C = -1;
    D = -1;
end

% B,C,D are the end points of the primitive vectors
B = A + a;
C = A + b;
D = A + c;

return ;

    



