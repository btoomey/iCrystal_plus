function rdf = rdf3(pos, V,rmax, dr)
    %Assume non periodic boundary condition
    rdf = cell(2,1);
    num = size(pos, 1);
    [idx, dist] = knnsearch(pos,pos, 'K', num);
    Rs = 0:dr:rmax;
    lrs = length(Rs);
    counters = zeros(1,lrs);
    for i = 1:num
        for j = 1:num
            temp = dist(i,j);
            if ~isZero(temp,1E-5)
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