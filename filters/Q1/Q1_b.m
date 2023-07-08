clc;clear;close all;

I=imread("./Cameraman.tif");
pad_size = [10 10];
zero=padarray(I,pad_size);

average_kernel=fspecial("average",7);
gaussian_kernel=fspecial("gaussian",7);

average=imfilter(zero,average_kernel);
gaussian=imfilter(zero,gaussian_kernel);

subplot(1,2,1);
imshow(average,[]);
title("average");

subplot(1,2,2);
imshow(gaussian,[]);
title("gaussian");
