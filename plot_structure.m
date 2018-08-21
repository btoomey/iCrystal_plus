function info = plot_structure(name, info,distanceinfo)
% This function takes the output of read_xyz() and plot the atom positions
% in 3D. It also draws the faces of the polyhedron of the whole crystals.
% This function used two helper functions, vert2lcon and plotregion,
% written by Matt J and Per Bergstr�m respectively. Licenses are included.
load('tol.mat');
set(handles.figure1, 'HandleVisibility', 'off');
close all;
set(handles.figure1, 'HandleVisibility', 'on');
% This gives minimum values of x,y,z and max values of x,y,z to determine
% the boundary of the plot
%[min_x, max_x, min_y, max_y, min_z, max_z] = find_maxs(positions);
color_list = ['r' 'b' 'y' 'c' 'g' 'm'];
color_list = jet(6);
% The counter for index of diff elements
% The counter for color list so diff. elements has diff color
ccounter = 1; 
% Another counter for color list; need to modify this later
[m, n] = size(info);

figure (1)

for i = 1:m
    temp = info{i,7};
    color = color_list(ccounter,:);
    % plot the atomic positions in 3D
    if size(temp,1)>1
        scatter3(temp(:,1), temp(:,2), temp(:,3), 30, color, 'fill')
    end
    if i ~=m
        [a,b,c,p] = findCoord(info, i, distanceinfo);
        abc = [a;b;c];
        info{i,9} = p;
        info{i,10} = abc;
        abc = abc';
        abc = inv(abc);
        if ~(max(max(abc))>1E5 || min(min(abc))<-1E5)
            % Draw the faces of the crystal
            [A,b,Aeq,beq] = vert2lcon(temp);
            A = -A;
            [A,b] = mergemi(A,b);
            A = vertcat(A,abc);
            if strcmpi(info{i, 5},'primitive hexagonal') || strcmpi(info{i, 5},'rhombohedral')
                A = vertcat([99999999,99999999, 99999999],A);
            end


            if size(A,1)>7
                miller = plotregion_v3(A,-b,Aeq,beq,color);
                info{i,12} = miller;
            end

            if ccounter == 6
                ccounter = 1;
            else
                ccounter = ccounter +1;
            end
            hold on
        end
    end
end

box on
%grid off
%axis(2*[min_x, max_x, min_y, max_y, min_z, max_z]); 
axis equal
rotate3d on
font = 25;
xlabel('x axis', 'fontsize',font,'fontweight','b');
ylabel('y axis', 'fontsize',font,'fontweight','b');
zlabel('z axis', 'fontsize',font,'fontweight','b');
title(name, 'fontsize',font,'fontweight','b');

end

