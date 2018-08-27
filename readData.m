function [name ,num_of_each, positions] = readData(file_name)
    fid = fopen(file_name);
    count = 1;
    
    tline = fgetl(fid);
    while ischar(tline)
        if count ==1
            % first line is the name of crystal
            name = tline;
        end
        if count == 6
            % 6th line gives the number of atoms of each element
            num_of_each = str2num(tline);
            num_atom = sum(num_of_each);
            positions = zeros(num_atom,3);
        end
        if count >=8
            % 8th lines and after give the positions of atoms
            temp3 = str2num(tline);
            positions(count-7, :) = temp3;
        end
        count = count+1;
        tline = fgetl(fid);
    end
    fclose(fid);
end