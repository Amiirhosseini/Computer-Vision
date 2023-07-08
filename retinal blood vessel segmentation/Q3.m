%Amirreza Hosseini 9820363
%Retinal vessel blood extraction
clc; clear; close all;

% Load the images and masks
n = 20;
path = '.\DRIVE\Test\';
temp1 = imread([path 'images\1_test.tif']);
temp2 = imread([path '2nd_manual\1_manual2.gif']);
images = uint8(zeros([n size(temp1)]));
first_manual = uint8(zeros([n size(temp2)]));
second_manual = uint8(zeros([n size(temp2)]));
mask = uint8(zeros([n size(temp2)]));
for i = 1: n
    images(i, :, :, :) = imread([path 'images\' num2str(i) '_test.tif']);
    first_manual(i, :, :, :) = imread([path '1st_manual\' num2str(i) '_manual1.gif']);
    second_manual(i, :, :, :) = imread([path '2nd_manual\' num2str(i) '_manual2.gif']);
    mask(i, :, :, :) = imread([path 'mask\' num2str(i) '_test_mask.gif']);
end

% Mask the images
masked_images = images;
for i = 1: n
    for j = 1: size(masked_images(i, :, :, :), 2)
        for k = 1: size(masked_images(i, :, :, :), 3)
            if (mask(i,j, k) == 0)
                masked_images(i, j, k, 1) = 0;
                masked_images(i, j, k, 2) = 0;
                masked_images(i, j, k, 3) = 0;
            end
        end
    end
end

% Enhance lines in 12 directions using opening operation
linearly_opened_images = masked_images;
for i = 1: n
    for j = 0: 45: 180
        se = strel('line', 7, j);
        linearly_opened_images(i, :, :, :) = imopen(squeeze(linearly_opened_images(i, :, :, :)), se);
    end
end

% Sharpen the images
sharpened_images = linearly_opened_images;
for i = 1: n
    sharpened_images(i, :, :, :) = imsharpen(squeeze(sharpened_images(i, :, :, :)), 'Radius', 1, 'Amount', 5);
end

% Apply adaptive thresholding
thresholded_images = sharpened_images;
for i = 1: n
    % Apply median filter to reduce noise
    S = medfilt3(squeeze(thresholded_images(i, :, :, :)),[19 19 19]);
    K = 0.93;
    T = K * S;
    thresholded_images(i, :, :, :) = squeeze(thresholded_images(i, :, :, :)) < T;

    % Apply CLAHE to enhance contrast
    thresholded_images(i, :, :, 2) = adapthisteq(squeeze(thresholded_images(i, :, :, 2)));
    % Rescale it in 0 and 1
    thresholded_images(i, :, :, 2) = rescale(squeeze(thresholded_images(i, :, :, 2)));
end

% Reduce noise
noise_canceled_images = thresholded_images;
se = strel('disk',2);
for i = 1: n
    noise_canceled_images(i, :, :, :) = imdilate(squeeze(noise_canceled_images(i, :, :, :)), se);
end

% Apply median filter
for i = 1: n
    noise_canceled_images(i, :, :, 2) = medfilt2(squeeze(noise_canceled_images(i, :, :, 2)), [5 5]);
end

% Apply opening
for i = 1: n
    se = strel('disk', 1);
    noise_canceled_images(i, :, :, :) = imopen(squeeze(noise_canceled_images(i, :, :, :)), se);
end

% Create a new mask
se_mask = strel('disk', 8);
i_mask = imopen(mask, se_mask);

% Mask the images
final_images = noise_canceled_images;
for i = 1: n
    for j = 1: size(final_images(i, :, :, :), 2)
        for k = 1: size(final_images(i, :, :, :), 3)
            if (i_mask(i, j, k) == 0)
               final_images(i,j,k,2)=0;
            end
        end
    end
end

% Apply imclose to the vessels to make them thicker
for i = 1: n
    se=strel('square', 4);
    final_images(i, :, :, 2) = imclose(squeeze(final_images(i, :, :, 2)), se);
     imwrite(imadjust(squeeze(final_images(i, :, :, 2))), ['results\first\' num2str(i) '.tif']);  %chenging parameter
     %imwrite(imadjust(squeeze(final_images(i, :, :, 2))), ['results\second\' num2str(i) '.tif']);   %chenging parameter
end

% Calculate parameters
sensitivity = double(zeros([1 n]));
specificity = double(zeros([1 n]));
accuracy = double(zeros([1 n]));
for i = 1: n
    % Calculate true positives, true negatives, false positives, and false negatives
    [tp, tn, fp, fn] = parameters(squeeze(final_images(i, :, :, 2)), squeeze(first_manual(i, :, :)),1);  %chenging parameter
    sensitivity(i) = double(tp / (tp + fn));
    specificity(i) = double(tn / (tn + fp));
    accuracy(i) = double((tp + tn) /(tp + tn + fp + fn));
end
mean_sensitivity = mean(sensitivity)
mean_specificity = mean(specificity)
mean_accuracy = mean(accuracy)

% Calculate F1 score
f1_score = 2 * mean_sensitivity * mean_specificity / (mean_sensitivity + mean_specificity);

disp(strcat('F1 score is : ',num2str(f1_score)));
