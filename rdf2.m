function rdf2(pos, dim, rmin, rmax, dr)
    %Assume periodic boundary condition
    X = dim(1);
    Y = dim(2);
    Z = dim(3);
    num = size(pos, 1);
%     Xs = pos(:,1);
%     Ys = pos(:,2);
%     Zs = pos(:,3);
%     Xs = mod(Xs, X);
%     Ys = mod(Ys, Y);
%     Zs = mod(Zs, Z);
%     Xs = Xs - X/2;
%     Ys = Ys - Y/2;
%     Zs = Zs - Z/2;
%     newPos = [Xs;Ys;Zs];
    [idx, dist] = knnsearch(pos,pos, 'K', num);
    Rs = rmin:dr:rmax;
    lrs = length(Rs);
    counters = zeros(1,lrs);
    for i = 1:num
        for j = 1:num
            temp = dist(i,j);
            if ~isZero(temp,1E-5)
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
    rho = num/V;
    gr = counters./(4*pi*(Rs.^2)*dr*rho);
    plot(Rs, gr)
end

function isZero = isZero(a, tol)
    isZero = 0;
    if abs(a)<tol
        isZero = 1;
    end
end