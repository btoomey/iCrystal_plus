function newF = eli_dup(face)
    newF = [];
    rowF = size(face, 1);
    for i = 1:rowF
        flag = 0;
        if isempty(newF)
            newF = [newF;face(i, :)];
        else
            for j = 1:size(newF, 1)
                if isSimilar(face(i, :), newF(j,:))
                    flag = 1;
                    break
                end
            end
            if flag == 0
                newF = [newF;face(i, :)];
            end
        end
    end
end
 
 
