function [bool] = isLarger(a,b,e )
if b < a - e
    bool = 1;
else
    bool = 0;
end

end