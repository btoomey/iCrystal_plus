function [M ] = push( P, M )
% function 'push' pushes the point P to the first row of the matrix M
%   
M = vertcat(P, M);

end

