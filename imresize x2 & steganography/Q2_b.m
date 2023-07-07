% Amirreza Hosseini
%      9820363

%clear workspace and console
clc;clear;clear All;

%main program

I=im2double(imread("Q5\Image_1.tif"));


J=best_RGB_PSNR(I);
psnr=MY_RGB_PSNR(I,J);

figure;
subplot(1,2,1);imshow(I,[]);
subplot(1,2,2);imshow(J,[]);

title(['PSNR=' num2str(psnr)]);