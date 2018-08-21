
function rdfCell = RDFDefault(distanceinfo,info,posForFurtherUse,dr,rmax,rmin,e1,e2)
%RDF default
%initialization

rdfCell = {};
% the all-in-one rdf
[gar, V] = convhull(posForFurtherUse);
% if rmax is undefined, initialize it to be -1

rdf = rdf4(posForFurtherUse,posForFurtherUse,V,dr,rmax,rmin);
rdfCell{1,1} = rdf;
rdfCell{1,2} = 'All-in-one';


% the smallest and the largest region
[numregion,gar] = size(info);
if numregion>1
    for i = 1:numregion
    if i == 1
        [numsmall,gar] = size(info{i,4});
        [numbig, gar] = size(info{i,4});
        small = 1;
        big = 1;
    end
    [num,gar] = size(info{i,4});
    if num < numsmall
        numsmall = num;
        small = i;
    elseif num > numbig
        numbig = num;
        big = i;
    end
    end
    rdfCell1 =  RDFNonPBCRegion(big,distanceinfo,info,posForFurtherUse,rmax,rmin,dr,e1,e2);
    rdfCell = vertcat(rdfCell, rdfCell1);
    if big~=small
        rdfCell1 =  RDFNonPBCRegion(small,distanceinfo,info,posForFurtherUse,rmax,rmin,dr,e1,e2);
        rdfCell = vertcat(rdfCell, rdfCell1);
    end
end

end    
