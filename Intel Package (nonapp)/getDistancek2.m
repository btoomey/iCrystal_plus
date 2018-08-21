function [ distanceinfo,tenThousand ] = getDistancek2( pos)
% getDistance gets the nearest neighbor of each point in the data
% the first column is the position of the data
% the second is the 50 nearest points
% the third is a logical value of whether or not this point has been
% identified



sizepos = size(pos);
row = sizepos(1);
tenThousand = min(10000, row);
idx = knnsearch(pos, pos, 'k', tenThousand);
distanceinfo = cell(row, 5);
for i = 1:row 
    distanceinfo{i,1} = pos(i,:);
    distanceinfo{i,2} = idx(i, :);
    distanceinfo{i,3} = 0;
end

end

