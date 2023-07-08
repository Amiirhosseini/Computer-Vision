% Amirreza Hosseini
%      9820363
% Template Matching

%clear workspace and console
clc; clear; clear All;

%main program
image_name = 'im_37';
I = imread(strcat('.\Dataset\Images\', image_name, '.png')); %read image

%split image into RGB channels
R = I(:, :, 1);
G = I(:, :, 2);
B = I(:, :, 3);

%gray to black and white
R = imbinarize(R);
G = imbinarize(G);
B = imbinarize(B);

windowSize = 5; %set window size

% apply median filter
R = medfilt3(R, [windowSize windowSize windowSize]);
G = medfilt3(G, [windowSize windowSize windowSize]);
B = medfilt3(B, [windowSize windowSize windowSize]);

figure;imshow([R G B],[]);

%create black circular templates with radius 27,37,46 in matrix form
template1 = zeros(2 * 27, 2 * 27);
%if in circle, set to 1
for i = 1:2 * 27

    for j = 1:2 * 27

        if (i - 27) ^ 2 + (j - 27) ^ 2 <= 27 ^ 2
            template1(i, j) = 1;
        end

    end

end

template1 = ~template1;

template2 = zeros(2 * 37, 2 * 37);

for i = 1:2 * 37

    for j = 1:2 * 37

        if (i - 37) ^ 2 + (j - 37) ^ 2 <= 37 ^ 2
            template2(i, j) = 1;
        end

    end

end

template2 = ~template2;

template3 = zeros(2 * 46, 2 * 46);

for i = 1:2 * 46

    for j = 1:2 * 46

        if (i - 46) ^ 2 + (j - 46) ^ 2 <= 46 ^ 2
            template3(i, j) = 1;
        end

    end

end

template3 = ~template3;

% %show templates
% figure;
% subplot(1,3,1);
% imshow(template1,[]);
% subplot(1,3,2);
% imshow(template2,[]);
% subplot(1,3,3);
% imshow(template3,[]);

circles = zeros(size(G, 1), size(G, 2)); %create matrix for circles with psnrs
psnrs = zeros(size(G, 1), size(G, 2)); %create matrix for psnrs
templates = zeros(size(G, 1), size(G, 2)); %create matrix for template number
min_psnr = 13;
R = double(R);
%do the same for template 1
i = 1;

while i <= size(G, 1) - 2 * 27
    j = 1;

    while j < size(G, 2) - 2 * 27
        peace = G(i:i + 2 * 27 - 1, j:j + 2 * 27 - 1);

        maxi = psnr(im2uint8(template1), im2uint8(peace));

        if maxi > min_psnr

            if (psnrs(i + 27, j + 27) < maxi)
                psnrs(i + 27, j + 27) = maxi;
                templates(i + 27, j + 27) = 27;
                circles(i + 27, j + 27) = 1;
                %fprintf('(%d,%d)=%d\n', i + 27, j + 27, maxi);
            end

        end

        j = j + 1;
    end

    i = i + 1;
end

% % %do the same for template 2
i = 1;

while i <= size(G, 1) - 2 * 37
    j = 1;

    while j < size(G, 2) - 2 * 37
        peace = G(i:i + 2 * 37 - 1, j:j + 2 * 37 - 1);
       
        maxi = psnr(im2uint8(template2), im2uint8(peace));
       
        if maxi > min_psnr

            if (psnrs(i + 37, j + 37) < maxi)
                psnrs(i + 37, j + 37) = maxi;
                templates(i + 37, j + 37) = 37;
                circles(i + 37, j + 37) = 1;
                %fprintf('(%d,%d)=%d\n', i + 37, j + 37, maxi);
            end

        end

        j = j + 1;
    end

    i = i + 1;
end

% %template matching for template 3 in G channel
i = 1;

while i <= size(G, 1) - 2 * 46
    j = 1;

    while j < size(G, 2) - 2 * 46
        %peace of image in template size
        peace = G(i:i + 2 * 46 - 1, j:j + 2 * 46 - 1);
       
        maxi = psnr(im2uint8(template3), im2uint8(peace));
        
        %if ncc is greater
        if maxi > min_psnr
            %add i and j to center of circle
            if (psnrs(i + 46, j + 46) < maxi)
                psnrs(i + 46, j + 46) = maxi;
                templates(i + 46, j + 46) = 46;
                circles(i + 46, j + 46) = 1;
                %fprintf('(%d,%d)=%d\n', i + 46, j + 46, maxi);
            end

        end

        j = j + 1;
    end

    i = i + 1;
end

%find number of 1 in circles matrix
num = sum(sum(circles));

figure;imshow(circles);

values = zeros(size(R, 1), size(R, 2));
min_psnr_number = 0;
%itterate over R channel
for i = 1:size(R, 1)

    for j = 1:size(R, 2)
        %if there is a circle in this pixel
        if circles(i, j) == 1
            min_psnr_number = 0;
            %get the template number
            template_num = templates(i, j);
            %if template number == 46
            if template_num == 46
                %get peace of image
                peace = R(i - 46:i + 46 - 1, j - 46:j + 46 - 1);
                directory = dir('.\Dataset\kernels_generated\46\*.jpg');
                kernel_num = length(directory(not([directory.isdir])));
                peace = white_cropper(peace, size(peace, 1), size(peace, 2));
                %itterate over kernels
                for k = 1:kernel_num
                    %read kernel
                    kernel = imread(strcat('.\Dataset\kernels_generated\46\', directory(k).name));
                    %find kernel value from image text splited by underline
                    splited = strsplit(directory(k).name, '_');
                    kernel_value = str2double(splited(1));
                    kernel = imbinarize(kernel);
                    kernel = white_cropper(kernel, size(kernel, 1), size(kernel, 2));

                    %                     kernel_conv=bwconvhull(~kernel);
                    %                     kernel=kernel&kernel_conv;
                    %
                    %                     peace = imbinarize(peace);
                    %                     peace_conv=bwconvhull(~peace);
                    %                     peace=peace&peace_conv;

                    %                     imshow(kernel);
                    %                     imshow(peace);
                    %calculate psnr
                    corr_val = normxcorr2(im2uint8(kernel), im2uint8(peace));
                    %if psnr is greater than min_psnr_number
                    if max(corr_val(:)) > min_psnr_number
                        %add psnr to values matrix
                        values(i, j) = kernel_value;
                        min_psnr_number = max(corr_val(:));
                    end

                end

            end

            %if template number == 37
            if template_num == 37
                %get peace of image in size of template
                peace = R(i - 37:i + 37 - 1, j - 37:j + 37 - 1);
                peace = white_cropper(peace, size(peace, 1), size(peace, 2));
                directory = dir('.\Dataset\kernels_generated\37\*.jpg');
                kernel_num = length(directory(not([directory.isdir])));
                %itterate over kernels
                for k = 1:kernel_num
                    %read kernel
                    kernel = imread(strcat('.\Dataset\kernels_generated\37\', directory(k).name));
                    %find kernel value from image text splited by underline
                    splited = strsplit(directory(k).name, '_');
                    kernel_value = str2double(splited(1));
                    kernel = imbinarize(kernel);
                    kernel = white_cropper(kernel, size(kernel, 1), size(kernel, 2));
                    % imshow(kernel);
                    % imshow(peace);
                    %calculate psnr
                    corr_val = normxcorr2(im2uint8(kernel), im2uint8(peace));
                    %if psnr is greater than min_psnr_number
                    if max(corr_val(:)) > min_psnr_number
                        %add psnr to values matrix
                        values(i, j) = kernel_value;
                        min_psnr_number = max(corr_val(:));
                    end

                end

            end

            %if template number == 27
            if template_num == 27
                %get peace of image in size of template
                peace = R(i - 27:i + 27 - 1, j - 27:j + 27 - 1);
                peace = white_cropper(peace, size(peace, 1), size(peace, 2));
                directory = dir('.\Dataset\kernels_generated\27\*.jpg');
                kernel_num = length(directory(not([directory.isdir])));
                %itterate over kernels
                for k = 1:kernel_num
                    %read kernel
                    kernel = imread(strcat('.\Dataset\kernels_generated\27\', directory(k).name));
                    %find kernel value from image text splited by underline
                    kernel = imbinarize(kernel);
                    splited = strsplit(directory(k).name, '_');
                    kernel_value = str2double(splited(1));
                    %                     imshow(kernel);
                    %                     imshow(peace);
                    %calculate psnr
                    kernel = white_cropper(kernel, size(kernel, 1), size(kernel, 2));
                    % imshow(kernel);
                    % imshow(peace);
                    corr_val = normxcorr2(im2uint8(kernel), im2uint8(peace));
                    %if psnr is greater than min_psnr_number
                    if max(corr_val(:)) > min_psnr_number
                        %add psnr to values matrix
                        values(i, j) = kernel_value;
                        min_psnr_number = max(corr_val(:));
                    end

                end

            end

        end

    end

end

%create tuple of circles and values and templates
tuple = zeros(num, 4);
index = 1;

for i = 1:size(R, 1)

    for j = 1:size(R, 2)

        if circles(i, j) == 1
            tuple(index, 1) = i;
            tuple(index, 2) = j;
            tuple(index, 3) = values(i, j);
            tuple(index, 4) = templates(i, j);
            tuple(index, 5) = psnrs(i, j);
            index = index + 1;
        end

    end

end

%sort tuple by values
tuple = sortrows(tuple, 3);

%remove duplicate records from tuple
tuple = unique(tuple, 'rows');
upper = size(tuple, 1);
i = 1; j = 1;
%remove redundant records from tuple that are in the same circle
while i <= upper
    j = i + 1;

    while j <= upper
        R = tuple(i, 4);
        X = (tuple(i, 1) - tuple(j, 1)) ^ 2;
        Y = (tuple(i, 2) - tuple(j, 2)) ^ 2;
        %if the distance between two circles is less than radius^2
        if X + Y <= R ^ 2
            %keep the one with higher psnr and remove the other
            if tuple(i, 5) > tuple(j, 5)
                tuple(j, :) = [];
                %update the index of the next record
                upper = size(tuple, 1);
                i = 0;
                break;
            else
                tuple(i, :) = [];
                %update the index of the next record
                upper = size(tuple, 1);
                i = 0;
                break;
            end

        end

        j = j + 1;
    end

    i = i + 1;
end

%sort tuple by values
tuple = sortrows(tuple, 3);

%print tuple
for i = 1:size(tuple, 1)
    fprintf('(%d,%d)=%d , %d\n', tuple(i, 1) - 2, tuple(i, 2) - 2, tuple(i, 3), tuple(i, 4));
end

%write tuple to file
file_name = strcat('.\Dataset\Results\', image_name, '.txt');
file = fopen(file_name, 'w');

for i = 1:size(tuple, 1)
    fprintf(file, '%d, %d, %d\n', tuple(i, 1) - 2, tuple(i, 2) - 2, tuple(i, 4));
end
