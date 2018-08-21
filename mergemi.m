function [ A1,b1 ] = mergemi( A,b )
%This function eliminates duplicate points. 
global tol1 tol2 tol3 tol4 tol5
A1 = A;
b1 = b;
[m,n] =size(A);
count =1;
while count<m
    check = A1(count+1,:);
    area = A1(1:count,:);
    [gar, d] = dsearchn(area,check);
    if d<tol2
        A1(count+1,:)=[];
        b1(count+1,:) = [];
        [m,n] =size(A1);
        continue
    else
        count = count +1 ;
    end
end

