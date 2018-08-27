function [ A, B, C, xi, eta, zeta] = niggliReduce(a, b, c)
%   niggli reduces a primitive cell with three primitive vectors to a 2x3
%   niggli form
%
%   This function follows the algorithm from 'A Unified Algorithm for
%   Determining the Reduced (Niggli) Cell'
%
%   e is the error suggested in the paper "Numerically stable algorithm"

e = (10^(-5))*abs(dot(c, (cross(a, b))))^(1/3);
% step 0
A = norm(a)^2;
B = norm(b)^2;
C = norm(c)^2;
xi = 2*dot(b,c);
eta = 2*dot(a,c);
zeta = 2*dot(a,b);



% signal to continue looping
loop = 1;
while loop
  % step 1
    if (isLarger(A,B,e)) || ((isEqual(A,B,e))&& (isLarger(abs(xi), abs(eta), e)))
        temp = A;
        temp2 = xi;
        A = B;
        xi = eta;
        B = temp;
        eta = temp2;
    end

    % step 2
    if (isLarger(B,C,e)) ||((isEqual(B,C,e))&& (isLarger(abs(eta), abs(zeta), e)))
        temp = B;
        temp2 = eta;
        B = C;
        eta = zeta;
        C = temp;
        zeta = temp2;
        continue;  
    end
    
    % step 3 & 4
    if isLarger(xi*eta*zeta, 0, e)
        xi = abs(xi);
        eta = abs(eta);
        zeta = abs(zeta);
    else
        xi = -abs(xi);
        eta = -abs(eta);
        zeta = -abs(zeta);
    end
    
    % step 5
    if isLarger(abs(xi) , B, e) || (isEqual( xi,B,e) && (isSmaller(2*eta ,zeta,e))) || ( isEqual( xi, -B, e)&& isSmaller(zeta, 0, e))
        C = B + C - xi*sign(xi);
        eta = eta - zeta*sign(xi);
        xi = xi - 2*B*sign(xi);
        continue;
    end
    
    % step 6
    if isLarger(abs(eta) , A, e) || (isEqual(eta,A,e) && (isSmaller(2*xi , zeta,e)))||( isEqual(eta, -A, e)&& isSmaller(zeta, 0, e))
        C = A + C - eta*sign(eta);
        xi = xi - zeta * sign(eta);
        eta = eta - 2*A* sign(eta);
        continue;
    end
    
    % step 7
    if isLarger(abs(zeta) , A, e) || (isEqual(zeta,A,e) && (isSmaller(2*xi , eta,e)))||( isEqual(zeta, -A, e)&& isSmaller(eta, 0, e))
        B = A + B - zeta* sign(zeta);
        xi = xi - eta* sign (zeta);
        zeta = zeta - 2*A * sign(zeta);   
        continue;
    end
    
    % step 8
    if isSmaller(xi + eta + zeta + A + B , 0, e) ||((isEqual(xi + eta + zeta + A + B ,0, e)) && (isLarger(2*(A + eta)+ zeta , 0, e)))
        C = A + B + C + xi + eta + zeta;
        xi = 2*B + xi + zeta;
        eta = 2*A + eta + zeta;
        continue;
    end
    % finish looping
    loop = 0;
end
xi = 0.5 * xi;
zeta = 0.5 * zeta;
eta = 0.5 * eta;
end


  
        









