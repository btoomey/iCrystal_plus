function [ bool ] = qualify(P, a,b,c, distanceinfo, pos)
% function qualify determines whether a point is at boundary
bool = 1;
num = dsearchn(pos, P);
M = distanceinfo{num, 2};
[A1, B1, C1, D1, a1, b1, c1] = buildprimitive(M, P, pos);

vol = abs(dot(c, cross(a,b)));
vol1 = abs(dot(c1, cross(a1,b1)));

if ~isEqual(vol, vol1, vol/10)
    bool = 0;
end

A1 = P +a;
[numA1,D] = dsearchn(pos, A1);
if D > 0.1
    bool = 0;
end
A2 = P -a;
[numA2,D] = dsearchn(pos, A2);
if D>0.1
    bool = 0;
end
B1 = P +b;
[numB1,D] = dsearchn(pos, B1);
if D>0.1
    bool = 0;
end
B2 = P -b;
[numB2,D] = dsearchn(pos, B2);
if D>0.1
    bool = 0;
end
C1 = P +c;
[numC1,D] = dsearchn(pos, C1);
if D>0.1
    bool = 0;
end
C2 = P -c;
[numC2,D] = dsearchn(pos, C2);
if D>0.1
    bool = 0;
end

end

