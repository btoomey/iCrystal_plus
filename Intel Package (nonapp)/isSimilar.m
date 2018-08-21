function isS = isSimilar(A, B)
    isS = 0;
    if abs(A(1)-B(1))<1E-2 && abs(A(2)-B(2))<1E-2 && abs(A(3)-B(3))<1E-2
        isS = 1;
    end
end