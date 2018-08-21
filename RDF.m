function rdfCell = RDFNonPBCRegion(numregion,distanceinfo,info,posForFurtherUse)
%RDF nonPBC region
% numregion is a user input
% dr is a user input
i = numregion;
callnum = info{i,4};
[n,gar] = size(callnum);
elementType = {};
l = 1;
for j=1:n
    if l ==1
        elementType{l,1} = distanceinfo{callnum(j),6};
        l = l+1;
    end
    for p = 1:l-1
        k = strfind(distanceinfo{callnum(j),6},elementType{p,1});
        if ~isempty(k)
            break
        end
    end
    if isempty(k)
        elementType{l,1} = distanceinfo{callnum(j),6};
        l = l+1;
    end
end
info{i, 13} = elementType;
[numElement,gar] = size(elementType);
l = numElement;
rowCell =cell(1,1);
count1 = 1;
rdfCell = cell(1,1);
count2 = 1;
for j = 1:numElement
    for k = 1:numElement + 1 -j
        entry1 = elementType{j,1};
        entry2 = elementType{numElement-k+1,1};
        rowCell{count1,1} = {entry1,entry2};
        count1 = count1+1;
        listOfPoints1 = [];
        for p = 1:n
            if strcmp(entry1, distanceinfo{callnum(p),6})
                listOfPoints1 = push(distanceinfo{callnum(p),1},listOfPoints1);
            end
        end
        listOfPoints2 = [];
        for p = 1:n
            if strcmp(entry2, distanceinfo{callnum(p),6})
                listOfPoints2 = push(distanceinfo{callnum(p),1},listOfPoints2);
            end
        end
        points = vertcat(listOfPoints1,listOfPoints2);
        [gar, V] = convhull(points);
        dr = 0.01;
        rdf = rdf4(listOfPoints1,listOfPoints2,V,dr);
        rdfCell{count2,1} = rdf;
        rdfCell{count2,2} = rowCell{count2,1};
        count2 = count2 + 1;
    end
end
if l>1
    listOfPoints=[];
    for p = 1:n
        listOfPoints = push(distanceinfo{callnum(p),1},listOfPoints);
    end
    [gar, V] = convhull(listOfPoints);
    dr = 0.01;
    rdf = rdf4(listOfPoints1,listOfPoints2,V,dr);
    rdfCell{count2,1} = rdf;
    rdfCell{count2,2} = elementType;
end
% info{i,11} = rdfCell;
end



function rdfCell = RDFPBCBox(startpoint,x,y,z,disntaceinfo,info,posForFurtherUse)
%RDF PBC BOX
%startpoint
%x
%y
%z
%dr
dim =[x;y;z];
rmin = 0;
rmax = sqrt(x^2+y^2+z^2);
A = startpoint;
a = [x/2, 0, 0];
b = [0, y/2, 0];
c = [0, 0, z/2];
vertices = [A+a+b+c;A+a+b+c;A+a-b+c;A+a-b-c;A-a+b+c;A-a+b-c;A-a-b+c;A-a-b-c];
in = inhull(posForFurtherUse,vertices);
[m,gar] = size(distanceinfo);
callnum = [];
for j = 1:m
    if in(j) == 1
        callnum = push(j,callnum);
    end
end
[n,gar] = size(callnum);
elementType = {};
l = 1;
k=0;
for j=1:n
    if l ==1
        elementType{l,1} = distanceinfo{callnum(j),6};
        l = l+1;
    else
        for p = 1:l-1
            k = strfind(distanceinfo{callnum(j),6},elementType{p,1});
            if ~isempty(k)
                break;
            end
        end
    end
    if isempty(k)
        elementType{l,1} = distanceinfo{callnum(j),6};
        l = l+1;
    end
end
% info{i, 13} = elementType;
[numElement,gar] = size(elementType);
l = numElement;
rowCell =cell(1,1);
count1 = 1;
rdfCell = cell(1,1);
count2 = 1;
for j = 1:numElement
    for k = 1:numElement + 1 -j
        entry1 = elementType{j,1};
        entry2 = elementType{numElement-k+1,1};
        rowCell{count1,1} = {entry1,entry2};
        count1 = count1+1;
        listOfPoints1 = [];
        for p = 1:n
            if strcmp(entry1, distanceinfo{callnum(p),6})
                listOfPoints1 = push(distanceinfo{callnum(p),1},listOfPoints1);
            end
        end
        listOfPoints2 = [];
        for p = 1:n
            if strcmp(entry2, distanceinfo{callnum(p),6})
                listOfPoints2 = push(distanceinfo{callnum(p),1},listOfPoints2);
            end
        end
        points = vertcat(listOfPoints1,listOfPoints2);
%         dr = 0.01;
        rdf = rdf2_pbc_v2(listOfPoints1,listOfPoints2,dim,rmin,rmax,dr);
        rdfCell{count2,1} = rdf;
        rdfCell{count2,2} = rowCell{count2,1};
        count2 = count2 + 1;
    end
end
if l >1
    listOfPoints=[];
    for p = 1:n
        listOfPoints = push(distanceinfo{callnum(p),1},listOfPoints);
    end
    % dr = 0.01;
    rdf = rdf2_pbc_v2(listOfPoints,listOfPoints,dim,rmin,rmax,dr);
    rdfCell{count2,1} = rdf;
    rdfCell{count2,2} = 'Total';
end
% info{i,11} = rdfCell;
end




function rdfCell = RDFNonPBCBox(startpoint,x,y,z,disntaceinfo,info,posForFurtherUse)
%RDF nonPBC BOX
%startpoint
%x
%y
%z
%dr
dim =[x;y;z];
rmin = 0;
rmax = sqrt(x^2+y^2+z^2);
A = startpoint;
a = [x/2, 0, 0];
b = [0, y/2, 0];
c = [0, 0, z/2];
vertices = [A+a+b+c;A+a+b+c;A+a-b+c;A+a-b-c;A-a+b+c;A-a+b-c;A-a-b+c;A-a-b-c];
in = inhull(posForFurtherUse,vertices);
[m,gar] = size(distanceinfo);
callnum = [];
for j = 1:m
    if in(j) == 1
        callnum = push(j,callnum);
    end
end
[n,gar] = size(callnum);
elementType = {};
l = 1;
for j=1:n
    if l ==1
        elementType{l,1} = distanceinfo{callnum(j),6};
        l = l+1;
    end
    for p = 1:l-1
        k = strfind(distanceinfo{callnum(j),6},elementType{p,1});
    end
    if isempty(k)
        elementType{l,1} = distanceinfo{callnum(j),6};
        l = l+1;
    end
end
% info{i, 13} = elementType;
[numElement,gar] = size(elementType);
l = numElement;
rowCell =cell(1,1);
count1 = 1;
rdfCell = cell(1,1);
count2 = 1;
for j = 1:numElement
    for k = 1:numElement + 1 -j
        entry1 = elementType{j,1};
        entry2 = elementType{numElement-k+1,1};
        rowCell{count1,1} = {entry1,entry2};
        count1 = count1+1;
        listOfPoints1 = [];
        for p = 1:n
            if strcmp(entry1, distanceinfo{callnum(p),6})
                listOfPoints1 = push(distanceinfo{callnum(p),1},listOfPoints1);
            end
        end
        listOfPoints2 = [];
        for p = 1:n
            if strcmp(entry2, distanceinfo{callnum(p),6})
                listOfPoints2 = push(distanceinfo{callnum(p),1},listOfPoints2);
            end
        end
        points = vertcat(listOfPoints1,listOfPoints2);
%         dr = 0.01;
        rdf = rdf4(listOfPoints1,listOfPoints2,x*y*z,dr);
        rdfCell{count2,1} = rdf;
        rdfCell{count2,2} = rowCell{count2,1};
        count2 = count2 + 1;
    end
end
if l >1
    listOfPoints=[];
    for p = 1:n
        listOfPoints = push(distanceinfo{callnum(p),1},listOfPoints);
    end
    % dr = 0.01;
    rdf = rdf4(listOfPoints,listOfPoints,x*y*z,dr);
    rdfCell{count2,1} = rdf;
    rdfCell{count2,2} = 'Total';
end
% info{i,11} = rdfCell;
end





function RDFPlot(rdfCell)
%RDF plot
[numOfGraph,gar] = size(rdfCell);
for graphCount = 1:numOfGraph;
    element = rdfCell{graphCount,2};
    s=size(element);
    if ~isequal(s, [2,2])
        
    else
        element1 = element{1,1};
        element2 = element{1,2};
        element = strcat(element1,'-', element2);
    end
    rdf = rdfCell{graphCount,1};
    Rs = rdf{1,1};
    gr = rdf{2,1};
    figure(graphCount);
    plot(Rs,gr);
    title(element);
    xlabel('r');
    ylabel('g(r)');
end
end






function rdfCell = RDFDefault(distanceinfo,info,posForFurtherUse)
%RDF default
%initialization
rdfCell = {};
% the all-in-one rdf
[gar, V] = convhull(posForFurtherUse);
rdf = rdf4(posForFurtherUse,posForFurtherUse,V,dr);
rdfCell{1,1} = rdf;
rdfCell{1,2} = 'All-in-one';

% the smallest and the largest region
[numregion,gar] = size(info);
for i = 1:numregion
if i == 1
    [numsmall,gar] = size(info{i,4});
    [numbig, gar] = size(info{i,4});
    small = 1;
    big = 1;
end
num = size(info{i,4});
if num < numsmall
    numsmall = num;
    small = i;
elseif num > numbig
    numbig = num;
    big = i;
end
end
rdfCell1 =  RDFNonPBCRegion(big,distanceinfo,info,posForFurtherUse);
rdfCell = vertcat(rdfCell, rdfCell1);
rdfCell1 =  RDFNonPBCRegion(small,distanceinfo,info,posForFurtherUse);
rdfCell = vertcat(rdfCell, rdfCell1);

end    






% 
% 
% 
% 
% %RDF user input
% %startpoint
% %x
% %y
% %z
% %dr
% A = startpoint;
% a = [x/2, 0, 0];
% b = [0, y/2, 0];
% c = [0, 0, z/2];
% vertices = [A+a+b+c;A+a+b+c;A+a-b+c;A+a-b-c;A-a+b+c;A-a+b-c;A-a-b+c;A-a-b-c];
% in = inhull(posForFurtheruse,vertices);
% [m,gar] = size(distanceinfo);
% callnum = [];
% for j = 1:m
%     if in(j) == 1
%         callnum = push(j,callnum);
%     end
% end
% first = A+a+b+c;
% last = A-a-b-c;
% diam = norm(first-last);
% rmax = diam;
% 
% 
% 
% 
% 
% 
% 
% 
% 
% if PBC == 1;
%     rmin = 0;
%     dim = [x;y;z];
%     rdf = rdf2_pbc_v2(points,dim,rmin,rmax,dr);
%     info{i,11} = rdf;
% else
%     V = x*y*z;
%     [n,gar] = size(points);
%     rdf = rdf3(points,V,rmax,dr);
%     info{i,11} = rdf;
% end
% 
    