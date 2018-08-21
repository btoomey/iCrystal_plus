function rdfCell = RDFPBCBox(startpoint,x,y,z,dr,rmin, rmax, distanceinfo,info,posForFurtherUse,elem1,elem2)
%RDF PBC BOX
%startpoint
%x
%y
%z
%dr
if isempty(elem1)||isempty(elem2)
    wronginput =1;
else
    wronginput = 0;
end
dim =[x;y;z];
if rmax == -1
    rmax = sqrt(x^2+y^2+z^2);
end
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
        if wronginput ~=1
            if ~((strcmpi(entry1,elem1)&&strcmpi(entry2,elem2))||(strcmp(entry1,elem2)&& strcmp(entry2,elem1)))
                continue
            end
        end
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
if l >1 && wronginput==1
    listOfPoints=[];
    for p = 1:n
        listOfPoints = push(distanceinfo{callnum(p),1},listOfPoints);
    end
    rdf = rdf2_pbc_v2(listOfPoints,listOfPoints,dim,rmin,rmax,dr);
    rdfCell{count2,1} = rdf;
    rdfCell{count2,2} = 'Total';
end
% info{i,11} = rdfCell;
end
