function [ distanceinfo ] = getDistancek(pos)
% getDistance gets the nearest neighbor of each point in the data
% the first column is the position of the data
% the second is the 300 nearest points
% the third is a logical value of whether or not this point has been
% identified

idx = knnsearch(pos, pos, 'k', 300);

sizepos = size(pos);
row = sizepos(1);
distanceinfo = cell(row, 5);
for i = 1:row 
    % the first column is the coordinate of the current point
    distanceinfo{i,1} = pos(i,:);
    % the second column is the call number of the 300 nearest neighbor of
    % the current point in the data.
    distanceinfo{i,2} = idx(i, :);
    % the initiallized the 'already identified?' logical value to 0.
    distanceinfo{i,3} = 0;
end




end

