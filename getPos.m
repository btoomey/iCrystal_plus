function pos = getPos(idx, distanceinfo)

[m,gar] = size(idx);
pos = zeros(m,3);
for i = 1:m
    pos(i,:) = distanceinfo{idx(i),1};
end