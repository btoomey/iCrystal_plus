function rdf = rdf4(pos1,pos2, V, dr,rmax,rmin)

    %Assume non periodic boundary condition
    if dr<0
        dr = 0.01;
    end
    rdf = cell(2,1);
    [num1,gar]=size(pos1);
    [num2,gar]=size(pos2);
    [idx, dist] = knnsearch(pos1,pos2, 'K', num1);
    num = num1+num2;
    if rmax<0
        rmax = max(max(dist));
    end
    Rs = rmin:dr:rmax;
    lrs = length(Rs);
    counters = zeros(1,lrs);
    for i = 1:num2
        for j = 1:num1
            temp = dist(i,j);
            if temp~=0
                ind = (temp)/dr;
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
    rho = num/V;
    gr = counters./(4*pi*(Rs.^2)*dr*rho);
	rdf{1,1} = Rs;
    rdf{2,1} = gr;
end

function isZero = isZero(a, tol)
    isZero = 0;
    if abs(a)<tol
        isZero = 1;
    end
end