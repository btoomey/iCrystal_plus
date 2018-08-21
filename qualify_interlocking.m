function [ bool ] = qualify_interlocking(P, a,b,c, M)
% function qualify determines whether a point is at boundary
bool = 1;
[A1, B1, C1, D1, a1, b1, c1] = buildprimitive_interlocking(M, P);


if isequal(A1, 0) && isequal(B1, 0) && isequal(C1, 0) && isequal(D1, 0)
    bool = 0;
else
    vol = abs(dot(c, cross(a,b)));
    vol1 = abs(dot(c1, cross(a1,b1)));

    if ~isEqual(vol, vol1, vol/10)
        bool = 0;
    end

    A1 = P +a;
    if searchPoint(M, A1) == 0;
        bool = 0;
    end
    A2 = P -a;
    if searchPoint(M, A2) == 0;
        bool = 0;
    end
    B1 = P +b;
    if searchPoint(M, B1) == 0;
        bool = 0;
    end
    B2 = P -b;
    if searchPoint(M, B2) == 0;
        bool = 0;
    end
    C1 = P +c;
    if searchPoint(M, C1) == 0;
        bool = 0;
    end
    C2 = P -c;
    if searchPoint(M, C2) == 0;
        bool = 0;
    end
end
end

