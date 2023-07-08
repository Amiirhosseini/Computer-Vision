function result = white_cropper(I,size_x,size_y)
    I = im2double(I);

    %find the edges of the image from above
    for ii = 1:1:size(I, 1)

        flag = 1;

        for jj = 1:1:size(I, 2)

            if (I(ii, jj) ~= 1)
                flag = 0;
                break;
            end

        end

        if (flag == 0)
            %crop the i'th row of the image
            I = I(ii:end, :);
            break;
        end

    end

    %find the edges of the image from bellow
    for iii = size(I, 1):-1:1

        flag = 1;

        for jjj = size(I, 2):-1:1

            if (I(iii, jjj) ~= 1)
                flag = 0;
                break;
            end

        end

        if (flag == 0)
            %crop the i'th row of the image
            I = I(1:iii, :);
            break;
        end

    end

    %find the edges of the image from left
    for jj = 1:1:size(I, 2)

        flag = 1;

        for ii = 1:1:size(I, 1)

            if (I(ii, jj) ~= 1)
                flag = 0;
                break;
            end

        end

        if (flag == 0)
            %crop the i'th row of the image
            I = I(:, jj:end);
            break;
        end

    end

    %find the edges of the image from right
    for jjj = size(I, 2):-1:1

        flag = 1;

        for iii = size(I, 1):-1:1

            if (I(iii, jjj) ~= 1)
                flag = 0;
                break;
            end

        end

        if (flag == 0)
            %crop the i'th row of the image
            I = I(:, 1:jjj);
            break;
        end

    end

    result = imresize(I, [size_x, size_y]);

end
