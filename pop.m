function [P, N] = pop(M)
% function 'pop' pops out the last point in the matrix
%   
sizepop = size(M);
rowpop = sizepop(1);
P = M(rowpop, :);
N = M;
N(rowpop, :) = [];

end

