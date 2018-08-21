function [bool] = isSmaller(a,b,e )
if a < b - e
    bool = 1;
else
    bool = 0;
end

end