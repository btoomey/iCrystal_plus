function str = niggliToLattice(A,B,C,D,E,F)
% x is the tolerance
global tol1 tol2 tol3 tol4 tol5
x = tol3;
%Determine Type
T = F*D*E; 
if isLarger(T, 0, x)
    type = 1;
else
    type = 2;
end
str = 'no match';
%category 1 A=B=C
if (isEqual(A, B, x)) && (isEqual(B, C, x))
    if type ==1
        if (isEqual(D, (A/2), x)) && (isEqual(E, (A/2), x)) && (isEqual(F, (A/2), x))
            str = 'face-centered cubic';
        elseif isEqual(D, E, x) && isEqual(D, F, x)
            str = 'rhombohedral';
        end
    else
        if isEqual(D, 0, x) && isEqual(E, 0, x) && isEqual(F, 0, x)
            str = 'primitive cubic';
        elseif isEqual(D, (-A/3), x) && isEqual(D, E, x) && isEqual(E, F, x)
            str = 'body-centered cubic';
        elseif isEqual(D, E, x) && isEqual(E, F, x)
            str = 'rhombohedral';
        elseif isEqual(E, D, x) && (isEqual(2*abs(D+E+F), A+B, x))
            str = 'body-centered tetragonal';
        elseif isEqual(E, F, x) && (isEqual(2*abs(D+E+F), A+B, x))
            str = 'body-centered tetragonal';
        elseif (isEqual(2*abs(D+E+F), A+B, x));
            str = 'body-centered orthorhombic';
        end
    end

%category 2 A=B
elseif isEqual(A, B, x)
    if type == 1
        if isEqual(D, (A/2), x) && isEqual(F, (A/2), x) && isEqual(E, (A/2), x)
            str = 'rhombohedral';
        elseif isEqual(D, E, x) 
            str = 'base-centered monoclinic';
        end
    else
        if isEqual(D, 0, x) && isEqual(E, 0, x) && isEqual(F, 0, x)
            str = 'primitive tetragonal';
        elseif isEqual(D, 0, x) && isEqual(E, 0, x) && (isEqual(F, -A/2, x))
            str = 'primitive hexagonal';
        elseif isEqual(D, 0, x) && isEqual(E, 0, x);
            str = 'base-centered orthorhombic';
        elseif isEqual(D, -A/2, x) && isEqual(E, -A/2, x) && isEqual(F, 0, x)
            str = 'body-centered tetragonal';
        elseif isEqual(E, D, x) && (isEqual(2*abs(D+E+F), A+B, x))
            str = 'face-centered orthorhombic';
        elseif isEqual(D, E, x)
            str = 'base-centered monoclinic';
        elseif (isEqual(2*abs(D+E+F), A+B, x))
            str = 'base-centered monoclinic';
        end
    end
    
%category 3 B=C
elseif isEqual(B, C, x)
    if type == 1
        if isEqual(D, A/4, x) && isEqual(E, (A/2), x) && isEqual(F, (A/2), x)
            str = 'body-centered tetragonal';
        elseif isEqual(E, (A/2), x) && isEqual(F, (A/2), x)
            str = 'body-centered orthorhombic';
        elseif isEqual(E, F, x)
            str = 'base-centered monoclinic';
        end
    else
        if isEqual(D, 0, x) && isEqual(E, 0, x) && isEqual(F, 0, x)
            str = 'primitive tetragonal';
        elseif isEqual(D, -B/2, x) && isEqual(E, 0, x) && isEqual(F, 0, x)
            str = 'primitive hexagonal';
        elseif isEqual(E, 0, x) && isEqual(F, 0, x)
            str = 'base-centered orthorhombic';
        elseif isEqual(E, -A/3, x) && (isEqual(F, -A/3, x)) && (isEqual(2*abs(D+E+F), A+B, x))
            str = 'rhombohedral';
        elseif isEqual(E, F, x)
            str = 'base-centered monoclinic';
        end
    end
end
if strcmp(str, 'no match')      
    if (type==1)
        if (isEqual(D, A/4, x)) && (isEqual(E, F, x)) && (isEqual(F, (A/2), x))
            str = 'face-centered orthorhombic';
        elseif (isEqual(E, F, x)) && (isEqual(F, (A/2), x))
            str = 'base-centered monoclinic';
        elseif (isEqual(E, (A/2), x)) && (isEqual(F, 2*D, x))
            str = 'base-centered monoclinic';
        elseif (isEqual(F, (A/2), x)) && (isEqual(E, 2*D, x))
            str = 'base-centered monoclinic';
        elseif (isEqual(D, B/2, x)) && (isEqual(F, 2*E, x))
            str = 'base-centered monoclinic';
        else
            str = 'triclinic';
        end
    
    
    %Type 2 cases in Category 3
    else
        if (isEqual(D, 0, x)) && (isEqual(E, D, x)) &&(isEqual(F, D, x))
            str = 'primitive orthorhombic';
        elseif (isEqual(-B/2, D, x)) && (isEqual(E, 0, x)) && (isEqual(E, F, x))
            str = 'base-centered orthorhombic';
        elseif (isEqual(E, 0, x)) && (isEqual(E, F, x))
            str = 'primitive monoclinic';
        elseif (isEqual(D, 0, x)) && (isEqual(-A/2, E, x)) && (isEqual(F, 0, x))
            str = 'base-centered orthorhombic';
        elseif (isEqual(D, 0, x)) && (isEqual(F, 0, x))
            str = 'primitive monoclinic';
        elseif (isEqual(D, 0, x)) && (isEqual(E, 0, x)) && (isEqual(-A/2, F, x))
            str = 'base-centered orthorhombic';
        elseif (isEqual(D, 0, x)) && (isEqual(E, 0, x))
            str = 'primitive monoclinic';
        elseif (isEqual(-B/2, D, x)) && (isEqual(-A/2, E, x)) && (isEqual(F, 0, x))
            str = 'body-centered orthorhombic';
        elseif (isEqual(-B/2, D, x)) && (isEqual(F, 0, x))
            str = 'base-centered monoclinic';
        elseif (isEqual(-A/2, E, x)) && (isEqual(F, 0, x))
            str = 'base-centered monoclinic';
        elseif (isEqual(E, 0, x)) && (isEqual(-A/2, F, x))
            str = 'base-centered monoclinic';
        elseif (isEqual((2*D+F), B, x))
            str = 'base-centered monoclinic';
        else
            str = 'triclinic'; % it is possible that amorphourous will be recognized as triclinic, but we will add a step to differentiate these two
        end        
        
    end
end