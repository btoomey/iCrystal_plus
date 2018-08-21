[num, gar] = size(info);
load('path.mat');
load('infos.mat');
if isempty(savepath)
    de = userpath;
    len = length(de);
    savepath = de(1:len-1);
end
for i = 1:num-1
% type and number of atoms
    cellmom = {};
    numatoms = info{i,8};
    type = info{i,5};
    cell1 = cell(3,3);
    cell1{1,1} = 'number of atoms';
    cell1{1,2} = 'Lattice type';
    cell1{2,1} = numatoms;
    cell1{2,2} = type;
    cell1{3,1} =' ';
    cellmom = vertcat(cellmom,cell1);
% interior
    interior = getPos(info{i,2},distanceinfo);
    sizeI = size(interior);
    m = sizeI(1);
    dim = zeros(1,m);
    for j = 1:m
        dim(j) = 1;
    end
    cell1 = mat2cell(interior,dim,[1,1,1]);
    cell0 = cell(1,3);
    cell0{1,1} = 'Interior Points';
    cellz = cell(1,3);
    cellmom = vertcat(cellmom,cell0,cell1,cellz);

% boundary
    boundary = getPos(info{i,3},distanceinfo);
    sizeB = size(boundary);
    m = sizeB(1);
    dim = zeros(1,m);
    for j = 1:m
        dim(j) = 1;
    end
    cell0{1,1} = 'Boundary Points';
    cell2 = mat2cell(boundary,dim,[1,1,1]);
    cellmom = vertcat(cellmom,cell0,cell2,cellz);

% region points
    cell0{1,1} = 'Region Points';
    cell3 = vertcat(cell1, cell2);
    cellmom = vertcat(cellmom,cell0,cell3,cellz);
    
% Coordinates
    co = info{i,10};
    co = mat2cell(co, [1,1,1],[1,1,1]);
    cell0{1,1} = 'Coordinates for Miller Index'; 
    cellmom = vertcat(cellmom,cell0,co,cellz);

% Miller Index 
    MICell = info{i,12};
    [m,gar] = size(MICell);
    for j = 1:m
        MI = MICell{j,2};
        points = MICell{j,3};
        MI = mat2str(MI);
        [n,gar] = size(points);
        dim = zeros(1,n);
        for k = 1:n
            dim(k) = 1;
        end
        points = mat2cell(points,dim,[1,1,1]);
        cell1 = cell(1,3);
        cell1{1,1} = 'Index';
        cell1{1,2} = MI;
        cell1 = vertcat(cell1,points);
        cellmom = vertcat(cellmom,cell1,cellz);
    end
    
    str = num2str(i);
    filename = strcat(savepath, '\region',str,'.txt');
    dlmcell(filename,cellmom,'                ');
end

i = num;
cellz = cell(1,3);
% type and number of atoms
cellmom = {};
numatoms = info{i,8};
if numatoms>0
    type = info{i,5};
    cell1 = cell(3,3);
    cell1{1,1} = 'number of atoms';
    cell1{1,2} = 'Lattice type';
    cell1{2,1} = numatoms;
    cell1{2,2} = type;
    cell1{3,1} =' ';
    cellmom = vertcat(cellmom,cell1);
    % region points
    cell0=cell(1,3);
    cell0{1,1} = 'Region Points';
    co = info{i,7};
    dim = ones(size(co,1),1);
    cell2 = mat2cell(co,dim,[1,1,1]);
    cellmom = vertcat(cellmom,cell0,cell2);
    str = num2str(i);
    filename = strcat(savepath, '\region',str,'.txt');
    dlmcell(filename,cellmom,'                ');
end