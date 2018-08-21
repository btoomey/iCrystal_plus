load('rdf_npbc_data.mat');
if isempty(regionIndexCheckbox)
    regionIndexCheckbox = 0;
end
if isempty(userBox)
    userBox = 0;
end
if isempty(center_npbc)
    center_npbc = [0 0 0];
end
if isempty(dimX_npbc)
    dimX_npbc = 10;
end
if isempty(dimY_npbc)
    dimY_npbc = 10;
end
if isempty(dimZ_npbc)
    dimZ_npbc = 10;
end
if isempty(dr_npbc)
    dr_npbc = 0.01;
end
if isempty(rmin_npbc)
    rmin_npbc = 0;
end
if isempty(rmax_npbc)
    rmax_npbc = -1;
end
if isempty(numregion)
    numregion = 1;
end
load('infos.mat');
[numberofregion,gar] = size(info);
if numregion<=numberofregion
    if (regionIndexCheckbox == 1)

        [gar,n] = size(numregion);
        rdfCell1 = {};
        for i = 1:n
            rdfCell0 = RDFNonPBCRegion(numregion, distanceinfo,info,posForFurtherUse,rmax_npbc,rmin_npbc,dr_npbc,elem1_npbc,elem2_npbc);
            number = num2str(numregion);
            str = strcat('Region ',number);
            if ~isempty(rdfCell0)
                RDFPlot(rdfCell0,str);
            end
        end

    end

    if (userBox == 1)
        rdfCell2 = RDFNonPBCBox(center_npbc, dimX_npbc,dimY_npbc,dimZ_npbc,distanceinfo,info,posForFurtherUse,rmax_npbc,rmin_npbc, dr_npbc,elem1_npbc,elem2_npbc);
        centerstring = num2str(center_npbc);
        xstring = num2str(dimX_npbc);
        ystring = num2str(dimY_npbc);
        zstring = num2str(dimZ_npbc);
        str1 = strcat('Center: ',centerstring,' X: ',xstring,' Y: ',ystring,' Z: ',zstring);
        if ~isempty(rdfCell2)
            RDFPlot(rdfCell2,str1);
        end
    end
end

