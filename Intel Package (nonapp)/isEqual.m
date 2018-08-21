
function [bool] = isEqual(a,b,e)
if ~((a < b - e) || (b < a -e))
    bool = 1;
else
    bool = 0;
end

end