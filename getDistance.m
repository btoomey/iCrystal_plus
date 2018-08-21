function [ distanceinfo ] = getDistance( pos )
% getDistance gets the nearest neighbor of each point in the data
% the first column is the position of the data
% the second is the 50 nearest points
% the third is a logical value of whether or not this point has been
% identified
sizepos = size(pos);
row = sizepos(1);
distanceinfo = cell(row, 3);
for i = 1:row 
    poscopy = pos;
    distanceinfo{i,1} = pos(i,:);
    pos12 = zeros(12, 3);
    for j=1:12
        idx = dsearchn(poscopy,pos(i,:)); 
        pos12(j,:) = poscopy(idx, :);
        poscopy(idx, :) = [inf, inf, inf];
    end
    distanceinfo{i,2} = pos12;
    distanceinfo{i,3} = 0;
end
    
    



end

