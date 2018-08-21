function rdf = rdf2_pbc_v2(pos1,pos2, dim, rmin, rmax, dr)
    %Assume periodic boundary condition
    X = dim(1);
    Y = dim(2);
    Z = dim(3);
    num1 = size(pos1, 1);
    Xs1 = pos1(:,1);
    Ys1 = pos1(:,2);
    Zs1 = pos1(:,3);
    Xs1 = mod(Xs1, X);
    Ys1 = mod(Ys1, Y);
    Zs1 = mod(Zs1, Z);
    Xs1 = Xs1 - X/2;
    Ys1 = Ys1 - Y/2;
    Zs1 = Zs1 - Z/2;
    newPos1 = [Xs1,Ys1,Zs1];
    num2 = size(pos2, 1);
    Xs2 = pos2(:,1);
    Ys2 = pos2(:,2);
    Zs2 = pos2(:,3);
    Xs2 = mod(Xs2, X);
    Ys2 = mod(Ys2, Y);
    Zs2 = mod(Zs2, Z);
    Xs2 = Xs2 - X/2;
    Ys2 = Ys2 - Y/2;
    Zs2 = Zs2 - Z/2;
    newPos2 = [Xs2,Ys2,Zs2];
    dist = pdist2(newPos1, newPos2, @(X,Y) distfun(X,Y, dim));
    Rs = rmin:dr:rmax;
    lrs = length(Rs);
    counters = zeros(1,lrs);
    for i = 1:num1
        for j = 1:num2
            temp = dist(i,j);
            if temp>1E-6
                ind = (temp-rmin)/dr;
                if ind>=0
                    ind = ceil(ind);
                end
                if (ind >0) && (ind < lrs+1)
                    counters(ind) = counters(ind)+1;
                end
            end            
        end
    end
    counters = counters/2;
    V = X*Y*Z;
    rho = (num1+num2)/V;
    gr = counters./(4*pi*(Rs.^2)*dr*rho);
%     plot(Rs, gr)  
    rdf = cell(2,1);
    rdf{1,1} = Rs;
    rdf{2,1} = gr;
end

function D2 = distfun(ZI, ZJ, dim)
    %takingas arguments a 1-by-n vector ZI containinga single observation from X or Y,
    %an m2-by-n matrix ZJ containingmultiple observations from X or Y,and returning 
    %an m2-by-1 vector of distances D2,whose Jth element is the distance between the observations ZI and ZJ(J,:). 
    [row, col]= size(ZJ);
    XB = dim(1);
    YB = dim(2);
    ZB = dim(3);
    if col ~=3 || size(ZI,2)~=3
        error('This method only works for 3D points');
    end
    x = ZI(1);
    y = ZI(2);
    z = ZI(3);
    D2 = zeros(row,1);
    for i = 1:row
        X = ZJ(i, 1);
        Y = ZJ(i, 2);
        Z = ZJ(i, 3);
        distX = X-x;
        distY = Y-y;
        distZ = Z-z;
        if abs(distX) > XB/2
            distX = abs(abs(distX)-XB);
        end
        if abs(distY) > YB/2
            distY = abs(abs(distY)-YB);
        end
        if abs(distZ) > ZB/2
            distZ = abs(abs(distZ)-ZB);
        end
        D2(i) = sqrt(distX^2+distY^2+distZ^2);
    end
end
function isZero = isZero(a, tol)
    isZero = 0;
    if abs(a)<tol
        isZero = 1;
    end
end