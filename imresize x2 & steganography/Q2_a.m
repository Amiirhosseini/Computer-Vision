% Amirreza Hosseini
%      9820363

%clear workspace and console
clc;clear;clear All;

%main program

I=im2double(imread("Q4\Cameraman.tif"));


J=best_BW_PSNR(I);

imshow([I J],[]);

title(['PSNR=' num2str(MY_PSNR(I,J))]);
