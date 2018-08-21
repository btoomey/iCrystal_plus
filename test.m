function [ M ] = test( a,b,c )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
M  = zeros(343, 3);
count = 1;
for i = -3:3
    for j = -3:3
        for k = -3:3
            M(count,:) = i*a + j*b + k*c;
            count = count+1;
        end
    end
end
            

end

