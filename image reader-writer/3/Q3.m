% Amirreza Hosseini
%      9820363

%clear workspace and console
clc; clear; close all;

%main program
sample_path = find_path("sample.ppm");

I = im2double(image_read(sample_path));

%find the diameter of the image
diameter = sqrt(size(I, 1) ^ 2 + size(I, 2) ^ 2);
Framed = zeros(ceil(diameter) + 2, ceil(diameter) + 2, 3);
rowdif = ceil(diameter) - size(I, 1);
coldif = ceil(diameter) - size(I, 2);


Framed(ceil(rowdif / 2):size(I, 1) + ceil(rowdif / 2) - 1, ceil(coldif / 2):size(I, 2) + ceil(coldif / 2) - 1, :) = I;


Xcenter = ceil(size(Framed, 1) / 2);
Ycenter = ceil(size(Framed, 2) / 2);


%print in console
prompt = 'Enter the angle of rotation: ';

%get input from user
input = input(prompt);

radian=input*pi/180;

Result = zeros(ceil(diameter) + 2, ceil(diameter) + 2, 3);


for i = 1:1:size(Result, 1)

    for j = 1:1:size(Result, 2)
        %rotation matrix
        x_new = ceil(cos(radian) * (i - Xcenter) + sin(radian) * (j - Ycenter) + Xcenter);
        y_new = ceil(-1 * sin(radian) * (i - Xcenter) + cos(radian) * (j - Ycenter) + Ycenter);

        if (x_new >= 1 && y_new >= 1 && x_new <= size(Framed, 1) && y_new <= size(Framed, 2))
            Result(i, j, :) = Framed(x_new, y_new, :);
        end

    end

end

%find the edges of the image from above
for ii = 1:1:size(Result, 1)

    flag=1;

    for jj = 1:1:size(Result, 2)

        if (Result(ii, jj, 1) ~= 0 || Result(ii, jj, 2) ~= 0 || Result(ii, jj, 3) ~= 0)
            flag=0;
            break;
        end

    end

    if (flag==0)
       %crop the i'th row of the image
       Result=Result(ii:end,:,:);
       break;
    end

end

%find the edges of the image from bellow
for iii = size(Result, 1):-1:1

    flag=1;

    for jjj = size(Result, 2):-1:1

        if (Result(iii, jjj, 1) ~= 0 || Result(iii, jjj, 2) ~= 0 || Result(iii, jjj, 3) ~= 0)
            flag=0;
            break;
        end

    end

    if (flag==0)
       %crop the i'th row of the image
       Result=Result(1:iii,:,:);
       break;
    end

end

%find the edges of the image from left
for jj = 1:1:size(Result, 2)

    flag=1;

    for ii = 1:1:size(Result, 1)

        if (Result(ii, jj, 1) ~= 0 || Result(ii, jj, 2) ~= 0 || Result(ii, jj, 3) ~= 0)
            flag=0;
            break;
        end

    end

    if (flag==0)
       %crop the i'th row of the image
       Result=Result(:,jj:end,:);
       break;
    end

end

%find the edges of the image from right
for jj = size(Result, 2):-1:1

    flag=1;

    for ii = size(Result, 1):-1:1

        if (Result(ii, jj, 1) ~= 0 || Result(ii, jj, 2) ~= 0 || Result(ii, jj, 3) ~= 0)
            flag=0;
            break;
        end

    end

    if (flag==0)
       %crop the i'th row of the image
       Result=Result(:,1:jj,:);
       break;
    end

end


R = imrotate(I, input);
subplot(1, 2, 1)
imshow(R, [])
title('Rotate the image with the imrotate function:')

subplot(1, 2, 2)
imshow(Result, [])
title('First Rotation Result:')


%find the absolute path of relative sample file in the current folder
function sample_path = find_path(input)

    currentFile = matlab.desktop.editor.getActiveFilename;

    x = mfilename() + ".m";

    currentFolder = erase(currentFile, x);

    sample_path = currentFolder + input;

end

