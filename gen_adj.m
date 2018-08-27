function [adj] = gen_adj(A, a, b, c)
% gen_adj finds the predicted 26 nearest neighbors of a point A using the primitive
% vectors a,b and c. 
adj = zeros(26,3);
next = 1;
for i = [-1, 0, 1]
    for j = [-1, 0, 1]
        for k = [-1, 0, 1]
            pt = A +i*a+j*b+k*c;
            if (~(isequal(pt, A))) 
                adj(next,:) = pt;
                next = next + 1;
            end
        end
    end
end
end