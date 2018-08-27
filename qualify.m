function [ bool ] = qualify(P, a,b,c, distanceinfo, pos, Point4)
% function qualify determines whether a point is at boundary
global tol1 tol2 tol3 tol4 tol5
bool = 1;
[m,n] = size(pos);
twoFiveSix = min(256,m);
M = distanceinfo{Point4, 2};
        points = zeros(twoFiveSix, 3);
        for j = 1:twoFiveSix
            points(j,:) = pos(M(j), :);
        end

[A1, B1, C1, D1, a1, b1, c1] = buildprimitive(M, P, pos);

vol = abs(dot(c, cross(a,b)));
vol1 = abs(dot(c1, cross(a1,b1)));

if ~isEqual(vol, vol1, vol*tol4)
    bool = 0;
    return;
end


A1 = P +a;
[numA1,D] = dsearchn(points, A1);
if D > tol2
    bool = 0;
    return;
end

A2 = P -a;
[numA2,D] = dsearchn(points, A2);
if D>tol2
    bool = 0;
    return;
end
B1 = P +b;
[numB1,D] = dsearchn(points, B1);
if D>tol2
    bool = 0;
    return;
end
B2 = P -b;
[numB2,D] = dsearchn(points, B2);
if D>tol2
    bool = 0;
    return;
end
C1 = P +c;
[numC1,D] = dsearchn(points, C1);
if D>tol2
    bool = 0;
    return;
end
C2 = P -c;
[numC2,D] = dsearchn(points, C2);
if D>tol2
    bool = 0;
end

end

