% Amirreza Hosseini
% 9820363
% content-aware image retargeting

clc;clear;close all

%driver code
image_name = 'Diana';
percentage = 0.3;
dimansion=0;      % 0 or 1

I = imread(['Samples dataset\' image_name '\' image_name '.png']);
depthMap = double(imread(['Samples dataset\' image_name '\' image_name '_DMap.png']));
saliencyMap = double(imread(['Samples dataset\' image_name '\' image_name '_SMap.png']));

[J, importance_map] = cair(I, depthMap, saliencyMap, dimansion, percentage);
figure;
subplot(1,2,1);
imshow(uint8(J));
title('Output Image');
subplot(1,2,2);
imshow(importance_map,[]);
title('Energy Map');

imwrite(uint8(J),['output\' image_name '\' image_name '_' num2str(percentage) '_percentage.jpeg'])
%imwrite(im2uint8(importance_map),['output\' image_name '\' image_name '_energyMap.jpeg'])