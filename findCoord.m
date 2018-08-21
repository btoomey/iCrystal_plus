function [a,b,c,A] = findCoord(info, numRegion, distanceinfo)
% Find the basis vectors
%   Detailed explanation goes here
str = info{numRegion, 5};
interior = info{numRegion, 2};
sizeI = size(interior);
numOfInterior = sizeI(1);
abc= info{numRegion, 6};
tol = 0.1;
switch str
    case 'face-centered cubic'
    for count = 1:numOfInterior
        a = abc(1,:);
        b = abc(2,:);
        c = abc(3,:);
        len = norm(a);
        vector = replicate(a,b,c);
        [m n] = size(vector);

                
        found = 0;
        for i = 1:m
            a = vector(i,:);
            for j = i+1:m
                b = vector(j,:);
                for k = j+1:m
                    c = vector(k,:);
                    r1 = isEqual(dot(a,b),0,tol);
                    r2 = isEqual(dot(c,b),0,tol);
                    r3 = isEqual(dot(a,c),0,tol);
                    r4 = isEqual(norm(a),sqrt(2)*len,tol);
                    r5 = isEqual(norm(b),sqrt(2)*len,tol);
                    r6 = isEqual(norm(c),sqrt(2)*len,tol); 
                    
                    if r1&&r2&&r3&&r4&&r5&&r6
                        found = 1;
                    end
                    if found ==1
                        break;
                    end
                end
                if found ==1
                    break;
                end
            end
            if found ==1
                break;
            end
        end
        if found == 1
            break;
        end       
    end
    if found == 0
        error('failed to find correct bases');
    end
    
    % primitive cubic
    case 'primitive cubic'
         count = 1;
         a = abc(1,:);
         b = abc(2,:);
         c = abc(3,:);
    
    % body centered cubic
    case 'body-centered cubic'
        for count = 1:numOfInterior
            % a,b,c are primitive vectors
            a = abc(1,:);
            b = abc(2,:);
            c = abc(3,:);
            % len is the length of primitive vector
            len = norm(a);
            % vector is a matrix of vectors starting from the starting
            % point, which are a linear combination of a,b,c
            vector = replicate(a,b,c);
            % m is the number of vectors in 'vector'
            [m,gar] = size(vector);
            found = 0;
            for i = 1:m
                a = vector(i,:);
                for j = i+1:m
                    b = vector(j,:);
                    for k = j+1:m
                        c = vector(k,:);
                        r1 = isEqual(dot(a,b),0,tol);
                        r2 = isEqual(dot(c,b),0,tol);
                        r3 = isEqual(dot(a,c),0,tol);
                        r4 = isEqual(norm(a),len*2/sqrt(3),tol);
                        r5 = isEqual(norm(b),len*2/sqrt(3),tol);
                        r6 = isEqual(norm(c),len*2/sqrt(3),tol);            
                        if r1&&r2&&r3&&r4&&r5&&r6
                            found = 1;
                        end
                        if found ==1
                            break;
                        end
                    end
                    if found ==1
                        break;
                    end
                end
                if found ==1
                    break;
                end
            end
            if found == 1
                break;
            end       
        end
        if found == 0
            error('failed to find correct bases');
        end
        
        
    % Primitive Orthorhombic 
    case 'primitive orthorhombic' 
        count = 1;
        a = abc(1,:);
        b = abc(2,:);
        c = abc(3,:);
        
    % Body Centered Orthorhombic
    case 'body-centered orthorhombic'
        for count = 1:numOfInterior
            a = abc(1,:);
            b = abc(2,:);
            c = abc(3,:);
            vector = replicate(a,b,c);
            [m,gar] = size(vector);
            found = 0;
            for i = 1:m
                a = vector(i,:);
                for j = i+1:m
                    b = vector(j,:);
                    for k = j+1:m
                        c = vector(k,:);
                        r1 = isEqual(dot(a,b),0,tol);
                        r2 = isEqual(dot(c,b),0,tol);
                        r3 = isEqual(dot(a,c),0,tol);     
                        if r1&&r2&&r3
                            found = 1;
                        end
                        if found ==1
                            break;
                        end
                    end
                    if found ==1
                        break;
                    end
                end
                if found ==1
                    break;
                end
            end
            
            for i = 1:m
                a1 = vector(i,:);
                for j = i+1:m
                    b1 = vector(j,:);
                    for k = j+1:m
                        c1 = vector(k,:);
                        r1 = isEqual(dot(a1,b1),0,tol);
                        r2 = isEqual(dot(c1,b1),0,tol);
                        r3 = isEqual(dot(a1,c1),0,tol);        
                        if r1&&r2&&r3 && norm(a1) <= norm(a) && norm(b1) <= norm(b) && norm(c1) <= norm(c) 
                           a = a1;
                           b = b1;
                           c = c1;
                        end
                    end
                end
            end
            if found ==1
                break;
            end
        end   
        if found == 0
            error('failed to find correct bases');
        end
        
    % base centered orthoromhics
    case 'base-centered orthorhombic'
    for count = 1:numOfInterior
        a = abc(1,:);
        b = abc(2,:);
        c = abc(3,:);
        vector = replicate(a,b,c);
        [m,gar] = size(vector);
        found = 0;
        for i = 1:m
            a = vector(i,:);
            for j = i+1:m
                b = vector(j,:);
                for k = j+1:m
                    c = vector(k,:);
                    r1 = isEqual(dot(a,b),0,tol);
                    r2 = isEqual(dot(c,b),0,tol);
                    r3 = isEqual(dot(a,c),0,tol);     
                    if r1&&r2&&r3
                        found = 1;
                    end
                    if found ==1
                        break;
                    end
                end
                if found ==1
                    break;
                end
            end
            if found ==1
                break;
            end
        end

        for i = 1:m
            a1 = vector(i,:);
            for j = i+1:m
                b1 = vector(j,:);
                for k = j+1:m
                    c1 = vector(k,:);
                    r1 = isEqual(dot(a1,b1),0,tol);
                    r2 = isEqual(dot(c1,b1),0,tol);
                    r3 = isEqual(dot(a1,c1),0,tol);        
                    if r1&&r2&&r3 && norm(a1) <= norm(a) && norm(b1) <= norm(b) && norm(c1) <= norm(c) 
                       a = a1;
                       b = b1;
                       c = c1;
                    end
                end
            end
        end
        if found ==1
           break;
        end    
    end   
    if found == 0
        error('failed to find correct bases');
    end
        
    % face-centered orthorhomics
    case 'face-centered orthorhombic'
    for count = 1:numOfInterior
        a = abc(1,:);
        b = abc(2,:);
        c = abc(3,:);
        vector = replicate(a,b,c);
        [m,gar] = size(vector);
        found = 0;
        for i = 1:m
            a = vector(i,:);
            for j = i+1:m
                b = vector(j,:);
                for k = j+1:m
                    c = vector(k,:);
                    r1 = isEqual(dot(a,b),0,tol);
                    r2 = isEqual(dot(c,b),0,tol);
                    r3 = isEqual(dot(a,c),0,tol);     
                    if r1&&r2&&r3
                        found = 1;
                    end
                    if found ==1
                        break;
                    end
                end
                if found ==1
                    break;
                end
            end
            if found ==1
                break;
            end
        end

        for i = 1:m
            a1 = vector(i,:);
            for j = i+1:m
                b1 = vector(j,:);
                for k = j+1:m
                    c1 = vector(k,:);
                    r1 = isEqual(dot(a1,b1),0,tol);
                    r2 = isEqual(dot(c1,b1),0,tol);
                    r3 = isEqual(dot(a1,c1),0,tol);        
                    if r1&&r2&&r3 && norm(a1) <= norm(a) && norm(b1) <= norm(b) && norm(c1) <= norm(c) 
                       a = a1;
                       b = b1;
                       c = c1;
                    end
                end
            end
        end
        if found ==1
            break;
        end
    end   
    if found == 0
        error('failed to find correct bases');
    end
        
    % primitive tetragonal
    case 'primitive tetragonal'
        count = 1;
        a = abc(1,:);
        b = abc(2,:);
        c = abc(3,:);
        
    case 'body-centered tetragonal'
        for count = 1:numOfInterior
            a = abc(1,:);
            b = abc(2,:);
            c = abc(3,:);
            vector = replicate(a,b,c);
            [m,gar] = size(vector);
            [m n] = size(vector);
            found = 0;
            for i = 1:m
                a = vector(i,:);
                for j = i+1:m
                    b = vector(j,:);
                    for k = j+1:m
                        c = vector(k,:);
                        r1 = isEqual(dot(a,b),0,tol);
                        r2 = isEqual(dot(c,b),0,tol);
                        r3 = isEqual(dot(a,c),0,tol);     
                        if r1&&r2&&r3
                            found = 1;
                        end
                        if found ==1
                            break;
                        end
                    end
                    if found ==1
                        break;
                    end
                end
                if found ==1
                    break;
                end
            end
            
            for i = 1:m
                a1 = vector(i,:);
                for j = i+1:m
                    b1 = vector(j,:);
                    for k = j+1:m
                        c1 = vector(k,:);
                        r1 = isEqual(dot(a1,b1),0,tol);
                        r2 = isEqual(dot(c1,b1),0,tol);
                        r3 = isEqual(dot(a1,c1),0,tol);        
                        if r1&&r2&&r3 && norm(a1) <= norm(a) && norm(b1) <= norm(b) && norm(c1) <= norm(c) 
                           a = a1;
                           b = b1;
                           c = c1;
                        end
                    end
                end
            end
            if found ==1
                break;
            end
        end   
        if found == 0
            error('failed to find correct bases');
        end
        
%         case 'primitive monoclinic'
%         for count = 1:numOfInterior
%             a = abc(1,:);
%             b = abc(2,:);
%             c = abc(3,:);
%             len = norm(a);
%             vector = replicate(a,b,c);
%             [m,gar] = size(vector);
%             found = 0;
%             for i = 1:m
%                 a = vector(i,:);
%                 for j = i+1:m
%                     b = vector(j,:);
%                     for k = j+1:m
%                         c = vector(k,:);
%                         r1 = isEqual(dot(a,b),0,tol);
%                         r2 = isEqual(dot(c,b),0,tol);
%                         r3 = isEqual(dot(a,c),0,tol);       
%                         if (r1&&r2&&~r3)
%                             found = 1;
%                         elseif (r1&&r3&&~r2)
%                             found = 1;
%                             temp = a;
%                             a = b;
%                             b = temp;
%                         elseif (r2&&r3&&~r1)
%                             found = 1;
%                             temp = c;
%                             c = b;
%                             b = temp;
%                         end
%                         if found ==1
%                             break;
%                         end
%                     end
%                     if found ==1
%                         break;
%                     end
%                 end
%                 if found ==1
%                     break;
%                 end
%             end
% 
%             for i = 1:m
%                 a1 = vector(i,:);
%                 for j = 1:m
%                     b1 = vector(j,:);
%                     for k = 1:m
%                         c1 = vector(k,:);
%                         r1 = isEqual(dot(a1,b1),0,tol);
%                         r2 = isEqual(dot(c1,b1),0,tol);
%                         r3 = isEqual(dot(a1,c1),0,tol);
%                         r4 = (det([a1;b1;c1])~=0);
%                         if (r1&&r2&&~r3)
%                             replace = 1;
%                         elseif (r1&&r3&&~r2)
%                             replace = 1;
%                             temp = a1;
%                             a1 = b1;
%                             b1 = temp;
%                         elseif (r2&&r3&&~r1)
%                             replace = 1;
%                             temp = c1;
%                             c1 = b1;
%                             b1 = temp;
%                         else replace = 0;
%                         end
%                         if replace && norm(a1) <= norm(a) && norm(b1) <= norm(b) && norm(c1) <= norm(c) && r4
%                             a = a1;
%                             b = b1;
%                             c = c1;
%                         end
%                     end
%                 end
%             end
%             if found ==1
%                 break;
%             end
%         end
%         if found == 0
%             error('failed to find correct bases');
%         end
            
    case 'primitive monoclinic'
    for count = 1:numOfInterior

        call = interior(count);
        A = distanceinfo{call,1};
        region = info{numRegion, 4};
        [row, gar] = size(region);
        neighborpoints = zeros(row,3);
        for i = 1:row
            neighborpoints(i,:) = distanceinfo{region(i),1};
        end
        a = [999999, 99999, 99999];
        b = [999999, 99999, 99999];
        c = [999999, 99999, 99999];
        a2 = abc(1,:);
        b2 = abc(2,:);
        c2 = abc(3,:);
        len = norm(a);
        vector = replicate(a2,b2,c2);
        [m,gar] = size(vector);
        found = 0;
        for i = 1:m
            a1 = vector(i,:);
            for j = 1:m
                b1 = vector(j,:);
                r1 = isEqual(dot(a1,b1),0,tol);
                if ~r1
                    continue
                end
                for k = 1:m
                    c1 = vector(k,:);
                    r2 = isEqual(dot(a1,c1),0,tol);
                    if ~r2
                        continue
                    end
%                     [garbage, dis] = dsearchn(neighborpoints,(A+0.5*(a1+b1)));
%                     r3 = isEqual(dis, 0, tol);
                    r4 = (det([a1;b1;c1]) ~= 0);
                    if (r1&&r2&&r4)&& norm(a1) <= norm(a) && norm(b1) <= norm(b) && norm(c1) <= norm(c)
                        a = a1;
                        b = b1;
                        c = c1;
                        found = 1;
                    end
                end
            end
        end
        if found ==1
            break;
        end
    end
    if found == 0
            error('failed to find correct bases');
    end

    case 'base-centered monoclinic'
    for count = 1:numOfInterior

        call = interior(count);
        A = distanceinfo{call,1};
        region = info{numRegion, 4};
        [row, gar] = size(region);
        neighborpoints = zeros(row,3);
        for i = 1:row
            neighborpoints(i,:) = distanceinfo{region(i),1};
        end
        a = [999999, 99999, 99999];
        b = [999999, 99999, 99999];
        c = [999999, 99999, 99999];
        a2 = abc(1,:);
        b2 = abc(2,:);
        c2 = abc(3,:);
        len = norm(a);
        vector = replicate(a2,b2,c2);
        [m,gar] = size(vector);
        found = 0;
        for i = 1:m
            a1 = vector(i,:);
            for j = 1:m
                b1 = vector(j,:);
                r1 = isEqual(dot(a1,b1),0,tol);
                if ~r1
                    continue
                end
                for k = 1:m
                    c1 = vector(k,:);
                    r2 = isEqual(dot(a1,c1),0,tol);
                    if ~r2
                        continue
                    end
                    [garbage, dis] = dsearchn(neighborpoints,(A+0.5*(a1+b1)));
                    r3 = isEqual(dis, 0, tol);
                    r4 = (det([a1;b1;c1]) ~= 0);
                    if (r1&&r2&&r3&&r4)&& norm(a1) <= norm(a) && norm(b1) <= norm(b) && norm(c1) <= norm(c)
                        a = a1;
                        b = b1;
                        c = c1;
                        found = 1;
                    end
                end
            end
        end
        if found ==1
            break;
        end
    end
    if found == 0
            error('failed to find correct bases');
    end

    case 'triclinic'
        count = 1;
        a = abc(1,:);
        b = abc(2,:);
        c = abc(3,:);
    
    
    case 'rhombohedral'
    for count = 1:numOfInterior
        a = [999999, 99999, 99999];
        b = [999999, 99999, 99999];
        c = [999999, 99999, 99999];
        a2 = abc(1,:);
        b2 = abc(2,:);
        c2 = abc(3,:);
        len = norm(a);
        vector = replicate(a2,b2,c2);
        [m,gar] = size(vector);
        found = 0;
        for i = 1:m
            a1 = vector(i,:);
            for j = 1:m
                b1 = vector(j,:);
                for k = 1:m
                    c1 = vector(k,:);
%                     gamma = atan2(norm(cross(a1,b1)), dot(a1,b1));
%                     alpha = atan2(norm(cross(b1,c1)), dot(c1,b1));
%                     beta = atan2(norm(cross(a1,c1)), dot(a1,c1));
                    an = norm(a1);
                    bn = norm(b1);
                    cn = norm(c1);
%                     r1 = isEqual(gamma,pi/3,tol);
%                     r2 = isEqual(alpha,pi/3,tol);
%                     r3 = isEqual(beta,pi/3,tol);
                    r4 = isEqual(an, bn, tol);
                    r5 = isEqual(an, cn, tol);
                    r6 = isEqual(bn, cn, tol);
                    r1 = ~(isEqual(det([a1;b1;c1]),0,tol));
                    if (r1&&r4&&r5&&r6)&& norm(a1) < norm(a) && norm(b1) < norm(b) && norm(c1) < norm(c)
                        a = a1;
                        b = b1;
                        c = c1;
                        found = 1;
                    end
                end
            end
        end
        if found ==1
            break;
        end
    end
    if found == 0
            error('failed to find correct bases');
    end
    
    
    
    case 'primitive hexagonal'
    for count = 1:numOfInterior
        a = [999999, 99999, 99999];
        b = [999999, 99999, 99999];
        c = [999999, 99999, 99999];
        a2 = abc(1,:);
        b2 = abc(2,:);
        c2 = abc(3,:);
        len = norm(a);
        vector = replicates(a2,b2,c2);
        [m,gar] = size(vector);
        found = 0;
        for i = 1:m
            a1 = vector(i,:);
            for j = 1:m
                b1 = vector(j,:);
                for k = 1:m
                    c1 = vector(k,:);
                    gamma = atan2(norm(cross(a1,b1)), dot(a1,b1));
                    alpha = atan2(norm(cross(b1,c1)), dot(c1,b1));
                    beta = atan2(norm(cross(a1,c1)), dot(a1,c1));
                    an = norm(a1);
                    bn = norm(b1);
                    r1 = isEqual(gamma,pi*2/3,tol);
                    r2 = isEqual(alpha,pi/2,tol);
                    r3 = isEqual(beta,pi/2,tol);
                    r4 = isEqual(an, bn, tol);
                    if (r1&&r2&&r3&&r4)&& norm(a1) <= norm(a) && norm(b1) <= norm(b) && norm(c1) <= norm(c)
                        a = a1;
                        b = b1;
                        c = c1;
                        found = 1;
                    end
                end
            end
        end
        if found ==1
            break;
        end
    end    
    if found == 0
        error('failed to find correct bases');
    end
end
call = interior(count);
A = distanceinfo{call,1};
end









function [vector] = replicate(a,b,c)
vector = [];
for i = -2:2
    for j = -2:2
        for k = -2:2
            if (i == 0) &&(j == 0)&&(k==0)
                continue;
            end
            point = i*a + j*b + k*c;
            vector = push(point, vector);
        end
    end
end
end

function [vector] = replicates(a,b,c)
vector = [];
for i = -1:1
    for j = -1:1
        for k = -1:1
            if (i == 0) &&(j == 0)&&(k==0)
                continue;
            end
            point = i*a + j*b + k*c;
            vector = push(point, vector);
        end
    end
end
end
            
