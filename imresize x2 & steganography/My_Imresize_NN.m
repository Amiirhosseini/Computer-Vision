function Output_Image = My_Imresize_NN(Input_Image, Resizing_Factor)
row_size=size(Input_Image,1);
column_size=size(Input_Image,2);

Output_Image = zeros(ceil(row_size*Resizing_Factor), ceil(column_size*Resizing_Factor));

for i = 1: size(Output_Image, 1)
    for j = 1: size(Output_Image, 2)

        i_estimated = ceil(i/Resizing_Factor);
        j_estimated = ceil(j/Resizing_Factor);

        if(i_estimated < 0.5)
            i_estimated = round(i_estimated);
        else
            i_estimated = ceil(i_estimated);
        end

        if(j_estimated < 0.5)
            j_estimated = round(j_estimated);

        else
            j_estimated = ceil(j_estimated);
        end

        %for exeption handling
        if (i_estimated>row_size || j_estimated>column_size)
            break;
        end
        
        Output_Image(i, j) = Input_Image(i_estimated, j_estimated);

    end
end
end