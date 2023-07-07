function [labeled_image, current_label] = My_BWlabel(y, x, binary_image, labeled_image, current_label)

    max_y = size(binary_image, 1);
    max_x = size(binary_image, 2);
    
    all_neighbours = [y-1,x-1;
                      y-1,x  ;
                      y-1,x+1;
                      y  ,x-1;
                      y  ,x  ;
                      y  ,x+1;
                      y+1,x-1;
                      y+1,x  ;
                      y+1,x+1;];
     
    %select valid neighbours
    neighbours = [];
    for i=1 : 9
        cell = all_neighbours(i, :);
        if cell(1) > 0 && cell(1) <= max_y && cell(2) > 0 && cell(2) <= max_x
            if binary_image(cell(1),cell(2)) == 1 && labeled_image(cell(1), cell(2)) == 0
                neighbours(size(neighbours,1)+1, : ) = cell;
            end
        end
    end
    
    labeled_image(y, x) = current_label;

    for k=1 : size(neighbours,1)
        next = neighbours(k,:);
        [labeled_image, current_label] = My_BWlabel(next(1),next(2),binary_image,labeled_image,current_label);
    end

end
