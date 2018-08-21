function [ q ] = merge( p )
%This function eliminates duplicate points. 
global tol1 tol2 tol3 tol4 tol5
q = p;
[m,n] =size(p);
count =1;
while count<m
    check = q(count+1,:);
    area = q(1:count,:);
    [gar, d] = dsearchn(area,check);
    if d<tol2
        q(count+1,:)=[];
        [m,n] =size(q);
        continue
    else
        count = count +1 ;
    end
end

