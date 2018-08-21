load('rdf_pbc_data.mat');
if isempty('center_pbc')
    center_pbc = [0 0 0];
end
if isempty(dimX_pbc)
    dimX_pbc = 10;
end
if isempty(dimY_pbc)
    dimY_pbc = 10;
end
if isempty(dimZ_pbc)
    dimZ_pbc = 10;
end
if isempty(dr_pbc)
    dr_pbc = 0.01;
end
if isempty(rmin_pbc)
    rmin_pbc = 0;
end
if isempty(rmax_pbc)
    rmax_pbc = -1;
end
if isempty(center_pbc)
    center_pbc = [0 0 0];
end
load('infos.mat');
rdfCell2 = RDFPBCBox(center_pbc,dimX_pbc,dimY_pbc,dimZ_pbc,dr_pbc,rmin_pbc,rmax_pbc,distanceinfo,info,posForFurtherUse,elem1_pbc,elem2_pbc);
centerstring = num2str(center_pbc);
xstring = num2str(dimX_pbc);
ystring = num2str(dimY_pbc);
zstring = num2str(dimZ_pbc);
str1 = strcat('Center: ',centerstring,' X: ',xstring,' Y: ',ystring,' Z: ',zstring);
if ~isempty(rdfCell2)
    RDFPlot(rdfCell2,str1);
end
