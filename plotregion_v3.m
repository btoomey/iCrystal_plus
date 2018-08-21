function miller = plotregion_v3(A,b,lb,ub,c,transp,points,linetyp,start_end)
% The function plotregion plots closed convex regions in 2D/3D. The region
% is formed by the matrix A and the vectors lb and ub such that Ax>=b
% and lb<=x<=ub, where the region is the set of all feasible x (in R^2 or R^3).
% An option is to plot points in the same plot.
%
% Usage:   plotregion(A,b,lb,ub,c,transp,points,linetyp,start_end)
%
% Input:
%
% A - matrix. Set A to [] if no A exists
% b - vector. Set b to [] if no b exists
% lb - (optional) vector. Set lb to [] if no lb exists
% ub - (optional) vector. Set ub to [] if no ub exists
% c - (optional) color, example 'r' or [0.2 0.1 0.8], {'r','y','b'}.
%       Default is a random colour.
% transp - (optional) is a measure of how transparent the
%           region will be. Must be between 0 and 1. Default is 0.5.
% points - (optional) points in matrix form. (See example)
% linetyp - (optional) How the points will be marked.
%           Default is 'k-'.
% start_end - (optional) If a special marking for the first and last point
%              is needed.
%
% If several regions must be plotted A ,b, lb, ub and c can be stored as a cell array {}
% containing all sub-set information (see example1.m and example3.m). 
%
% Written by Per Bergström 2006-01-16
miller = {};
global tol1 tol2 tol3 tol4 tol5
tol = tol5;
arealist=[];
largestarea =0;
tlist = {};
patchlist ={};
tcount = 0;
if nargin<2
    error('Too few arguements for plotregion');
elseif nargin<6
    transp=0.8;
end


if isempty(A)
    m=0;
    n=max(length(lb),length(ub));
else
    [m,n]=size(A);
end

if size(b,1)==1
    b=b';
end

if nargin>2
    if not(isempty(lb))
        if size(lb,1)==1
            lb=lb';
        end
        A=[A;eye(n)];
        b=[b;lb];
        m=m+n;
    end
end
if nargin>3
    if not(isempty(ub))
        if size(ub,1)==1
            ub=ub';
        end
        
        A=[A;-eye(n)];
        b=[b;-ub];
        m=m+n;
    end
end

if nargin<5
    c=[rand rand rand];
end

if nargin>=5
    if isempty(c);
        c=[rand rand rand];
    end
end

warning off
testhex = A(1,:);

if norm(testhex)>99999999
    hex = 1;
    A(1,:) = [];
else
    hex = 0;
end
[d1, d2] = size(A);
abc = zeros(3,3);
abc(1,:) = A(d1-2,:);
abc(2,:) = A(d1-1,:);
abc(3,:) = A(d1, :);
A(d1, :)=[];
A(d1-1,:)=[];
A(d1-2,:)=[];

if n==3
    eq=zeros(3,1);
    X=zeros(3,1);
    
    for i=1:(m-2)
        for j=(i+1):(m-1)
            for k=(j+1):m
                try
                    x=A([i j k],:)\b([i j k]);
                    if and(min((A*x-b))>-1e-6,min((A*x-b))<Inf)
                        X=[X,x];
                        eq=[eq,[i j k]'];
                    end
                    
                end
            end
        end
    end
    xmi=min(X(1,2:end));
    xma=max(X(1,2:end));
    ymi=min(X(2,2:end));
    yma=max(X(2,2:end));
    zmi=min(X(3,2:end));
    zma=max(X(3,2:end));
    
    if nargin>=7
        xmi2=min(points(1,:));
        xma2=max(points(1,:));
        ymi2=min(points(2,:));
        yma2=max(points(2,:));
        zmi2=min(points(3,:));
        zma2=max(points(3,:));
        
        xmi=min(xmi,xmi2);
        xma=max(xma,xma2);
        ymi=min(ymi,ymi2);
        yma=max(yma,yma2);
        zmi=min(zmi,zmi2);
        zma=max(zma,zma2);
    end
    
    axis([(xmi-0.1) (xma+0.1) (ymi-0.1) (yma+0.1) (zmi-0.1) (zma+0.1)]);
    
    if nargin==7
        plot3(points(1,:)',points(2,:)',points(3,:)','k-');hold on;
    elseif nargin==8
        plot3(points(1,:)',points(2,:)',points(3,:)',linetyp);hold on;
    elseif nargin==9
        plot3(points(1,:)',points(2,:)',points(3,:)',linetyp);hold on;
        if length(start_end)==2
            plot3(points(1,1)',points(2,1)',points(3,1)',start_end);hold on;
            plot3(points(1,end)',points(2,end)',points(3,end)',start_end);hold on;
        elseif length(start_end)==4
            plot3(points(1,1)',points(2,1)',points(3,1)',start_end(1:2));hold on;
            plot3(points(1,end)',points(2,end)',points(3,end)',start_end(3:4));hold on;
        end
    end
    
	count = 1;
    for i=1:m
        [ind1,ind2]=find(eq==i);
        lind2=length(ind2);
        if lind2>0
            xm=mean(X(:,ind2),2);
            Xdiff=X(:,ind2);
            for j=1:lind2
                Xdiff(:,j)=Xdiff(:,j)-xm;
                Xdiff(:,j)=Xdiff(:,j)/norm(Xdiff(:,j));
            end
            costhe=zeros(lind2,1);
            
            for j=1:lind2
                costhe(j)=Xdiff(:,1)'*Xdiff(:,j);
            end
            
            [cc,ind]=min(abs(costhe));
            ref2=Xdiff(:,ind(1))-(Xdiff(:,ind(1))'*Xdiff(:,1))*Xdiff(:,1);
            ref2=ref2'/norm(ref2);
            
            for j=1:lind2
                if ref2*Xdiff(:,j)<0
                    costhe(j)=-2-costhe(j);
                end
            end
            [sooo,ind3]=sort(costhe);
            Xs = X(1,ind2(ind3))';
            Ys = X(2,ind2(ind3))';
            Zs = X(3,ind2(ind3))';
            face = [Xs, Ys, Zs];
            newF = eli_dup(face);
%             rowF = size(newF, 1);
%             for j = rowF
%                 if newF(j,1)<0
%                     disp(newF)
%                 end
%             end
            
            [row col] = size(newF);
            if row <3
%                 error('no plane formed with less than three points');
            count = count - 1;
            else
                xyz = newF;
                shiftZ = abc(1,:) + abc(2,:) + abc(3,:);
                change = 1;
                spot = 1;
                while  change == 1 
                    for q = 1:3
                        if isEqual(shiftZ(q),0,0.001)
                            if spot == 1
                                shiftZ = 2*abc(1,:) + abc(2,:) + abc(3,:);
                            elseif spot == 2
                                 shiftZ = abc(1,:) + 2*abc(2,:) + abc(3,:);
                            elseif spot == 3
                                 shiftZ = abc(1,:) + abc(2,:) + 3*abc(3,:);
                            end
                            break; 
                        end
                    end
                    if isEqual(shiftZ(1),0,0.001)||isEqual(shiftZ(2),0,0.001)||isEqual(shiftZ(3),0,0.001)
                        change = 1;
                        spot = spot +1;
                    else
                        change = 0;
                    end
                    if spot > 4
                        break;
                    end
                end
                    
                
                shiftZ = repmat(shiftZ,[size(newF, 1), 1]);
                for j = 1:row
                    if isSimilar(newF(j,:),[0, 0, 0])||isEqual(det(newF(1:3,:)),0, 0.01)
                        xyz = newF + shiftZ;
                        break
                    end
                end
                vertices = xyz;
                xyz = xyz(1:3, :);
                a1 = xyz(1,:);
                b1 = xyz(2,:);
                c1 = xyz(3,:);
                na = abc*a1';
                nb = abc*b1';
                nc = abc*c1';
                xyz = [na';nb';nc'];
                M = xyz\[1;1;1];
                % find the area
                v1 = (b1-a1);
                v1 = v1/(norm(v1));
                v2 = c1-a1;
                v2 = v2/(norm(v2));
                v2 = v2-dot(v1,v2)*v1;
                v2 = v2/(norm(v2));
                v3 = cross(v1,v2);
                changev = [v1;v2;v3];
                changev = changev';
                changev = inv(changev);
                xyzInNew = changev*vertices';
                xyzInNew = xyzInNew';
                xyInNew = horzcat(xyzInNew(:,1),xyzInNew(:,2));
                [gar,area]=convhull(xyInNew);
                if area>largestarea
                    largestarea = area;
                end
                arealist = vertcat(arealist,area);
                tol = tol5; % This is the tolerence for rat(); if it is too small, it is possible to result in very big Miller Index.
                while norm(M)>100000
                    M = M/100000;
                end
                
                
                if length(find(abs(M)<0.0002)) == 2
                    i1 = find(abs(M)<0.0002);
                    i3 = find(abs(M)>0.0002);
                    M(i1(1)) = 0;
                    M(i1(2)) = 0;
                    M(i3) = 1;
                elseif length(find(abs(M)<0.0002)) == 1
                    i1 = find(abs(M)<0.0002);
                    M(i1) = 0;
                    i2 = find(abs(M)>0.0002);
                    [N, D] = rat(abs(M(i2(1)))/abs(M(i2(2))), tol);
                    M(i2(1)) = sign(M(i2(1)))*N;
                    M(i2(2)) = sign(M(i2(2)))*D;
                else
                    [minM, indm]= min(abs(M));
                    temp = [];
                    for i = 1:3
                        if i~=indm
                            [N, D] = rat(abs(M(i))/minM, tol);
                            temp = [temp;[N,D,i]];
                        end
                    end
                    if abs(temp(1,2)) ~= abs(temp(2,2))
                        lcm2 = lcm(temp(1,2), temp(2, 2));
                        M(indm) = sign(M(indm))*lcm2;
                        M(temp(1,3)) = sign(M(temp(1,3)))*lcm2/temp(1,2)*temp(1,1);
                        M(temp(2,3)) = sign(M(temp(2,3)))*lcm2/temp(2,2)*temp(2,1);
                    else
                        M(indm) = sign(M(indm))*temp(1,2);
                        M(temp(1,3)) = sign(M(temp(1,3)))*temp(1,1);
                        M(temp(2,3)) = sign(M(temp(2,3)))*temp(2,1);
                    end
                end
                if hex 
                    temp = zeros(4,1);
                    temp(1) = M(1);
                    temp(2) = M(2);
                    temp(3) = -(M(1) + M(2));
                    temp(4) = M(3);
                    M = temp;
                end
            
            tx = 0.5*(min(newF(:,1))+max(newF(:,1)));
            ty = 0.5*(min(newF(:,2))+max(newF(:,2)));
            tz = 0.5*(min(newF(:,3))+max(newF(:,3)));
            t = [tx;ty;tz];
            tcount = tcount +1;
            tlist{tcount,1} = t;
            patch1{1,1} = X(1,ind2(ind3))';
            patch1{2,1} = X(2,ind2(ind3))';
            patch1{3,1} = X(3,ind2(ind3))';
            patchlist{tcount,1}=patch1;
%             if area>10
%             text(tx, ty, tz, num2str(M'), 'Color','k','FontSize',18, 'FontWeight', 'bold');
%             hold on
%             set(patch(X(1,ind2(ind3))',X(2,ind2(ind3))',X(3,ind2(ind3))',c),'FaceAlpha',transp);
%             end
            miller{count,1}=count;
            miller{count,2}=M';
            miller{count,3}= vertices;
            end
            count = count +1;
        end
    end
else
    error('Your region must be in 2D or 3D!');
end

count = count -1;
ccount = 1;
for i=1:count
    
    if arealist(i)>0.1*largestarea
        t = tlist{i,1};
        tx = t(1,:);
        ty = t(2,:);
        tz = t(3,:);
        M = miller{i,2};
        clear patch;
        text(tx, ty, tz, num2str(M), 'Color','k','FontSize',14, 'FontWeight', 'bold');
        hold on
        
    end
        patch1 = patchlist{i,1};
        x = patch1{1,1};
        y = patch1{2,1};
        z = patch1{3,1};
        set(patch(x,y,z,c),'FaceAlpha',transp);
end
end




