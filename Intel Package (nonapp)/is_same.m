function boolP = is_same(P1, P2)
global tol1 tol2 tol3 tol4 tol5
boolP = 0;
if norm(P1-P2)< tol2
    boolP = 1;
end
end