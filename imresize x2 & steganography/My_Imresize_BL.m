function Output_Image = My_Imresize_BL(Input_Image, Resizing_Factor)
row_size=size(Input_Image,1);
column_size=size(Input_Image,2);

Output_Image = zeros(ceil(row_size*Resizing_Factor), ceil(column_size*Resizing_Factor));

for i = 1: size(Output_Image, 1)
    for j = 1: size(Output_Image, 2)
        x = abs(i/Resizing_Factor - floor(i/Resizing_Factor));
        y = abs(j/Resizing_Factor - floor(j/Resizing_Factor));

        i_estimated = ceil(i/Resizing_Factor);
        j_estimated = ceil(j/Resizing_Factor);

        %for exeption handling
        if (i_estimated>=row_size || j_estimated>=column_size)
            break;
        end
        
        %find a
        if(i_estimated == 1 && j_estimated == 1)
            a = Input_Image(1, 1);
        elseif(i_estimated == 1)
            a = Input_Image(1, j_estimated-1);
        elseif(j_estimated==1)
            a = Input_Image(i_estimated,1);
        elseif(i_estimated ~= 1 && j_estimated ~=1)
            a = Input_Image(i_estimated-1, j_estimated-1);
        end
        
        %find b
        if(i_estimated == 1)
            b = Input_Image(1, j_estimated);
        else
            b = Input_Image(i_estimated-1, j_estimated);
        end

        %find c
        if(j_estimated == 1)
            c = Input_Image(i_estimated, 1);
        else
            c = Input_Image(i_estimated, j_estimated-1);
        end
        d = Input_Image(i_estimated, j_estimated);

        e=a+(b-a)*x+(c-a)*y+(a-b-c+d)*x*y;

        Output_Image(i, j) = e;
    end
end

end