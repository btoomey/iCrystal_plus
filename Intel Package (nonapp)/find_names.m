function elt_names = find_names(name)

%In general, this function takes in a string of words separated by spaces
%and outputs a column vector where each row is a single word. We're using
elt_names = {};
k = strfind(name, ' ');
%If there's only one element type, elt_names is just that element type. 
if isempty(k)
    elt_names(1,:) = cellstr(name);
%If there are multiple element types, we must proceed through all of them.
else
    l = 1;
    m = 1;
    len = length(name);
%As long as there continue to be space in the remaining set of characters,
%we still have multiple elements left in our list
    while ~isempty(k)
        elt_names(m,:) = cellstr(name(1:min(k - 1,len)));
        
        m = m+1;
        k = strfind(name(l:len), ' ');
        k = min(min(k));
        l = k+1;
        name = name(l:len);
        len = length(name);
    end
%There are no more spaces left after the last element type, so we must
%output it at the very end. 
    elt_names(m,:) = cellstr(name(l:length(name)));
    emptyCells = cellfun('isempty', elt_names); 
    elt_names(all(emptyCells,2),:) = [];
end
