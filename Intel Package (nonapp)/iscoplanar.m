function copl=iscoplanar(x,y,z)
global tol1 tol2 tol3 tol4 tol5
copl = 1;

% if the dimension of the vectors are wrong, return errormsg -1
if length(x)~=length(y) || length(y)~=length(z)
    copl = -1;
end

% Let vectors x and y determine the test plane:
crossprod = cross(x,y);

% The triple product z.cross(x,y) vanishes iff vectors x,y, and z are coplanar
alpha = 180*acos(dot(crossprod,z)/(norm(crossprod)*norm(z)))/pi;


if abs(90-alpha) > tol1  % the choice 3 is arbitary, might need sth more sophisticated to account for noise
      copl = 0;
end
return;
