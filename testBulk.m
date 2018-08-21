function [ M ] = testBulk(A, a1,b1,c1)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
M = [];
[m,n] = size(A);
a = repmat(a1, m, 1);
b = repmat(b1, m, 1);
c = repmat(c1, m, 1);
count = 1;
for i = -2:2
    for j = -2:2
        for k = -2:2
            newBulk = A +a.*i + b.*j + c.*k;
            M = vertcat(M, newBulk);
            count = count+1;
        end
    end
end
            

end

