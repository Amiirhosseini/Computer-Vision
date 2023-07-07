% Amirreza Hosseini
%      9820363

%clear workspace and console
clc;clear;clear All;

%main program

Resizing_factor=2;

%Gray scale X2 resize test
I=im2double(imread("Q4\LR_Peppers.tif"));

bilinear_img = imresize(I,Resizing_factor,'bilinear');

nearest_img = imresize(I,Resizing_factor,"nearest");

ED_img=My_Imresize_ED(I,Resizing_factor);

bicubic_img = imresize(I,2,'bicubic');

tic
bilinear_img_suggest = imresize(I,Resizing_factor,'bilinear');
bicubic_img_suggest = imresize(I,Resizing_factor,'bicubic');
nearest_img_suggest = imresize(I,Resizing_factor,"nearest");

%suggested weights
% alpha = 0.81;
% beta = 0.18;
% gamma=0.01;

%calculate value of alpha,beta and gamma depend on I
denominator=16*(sum(sum(abs(bilinear_img_suggest-nearest_img_suggest))))+...
4*(sum(sum(abs(bicubic_img_suggest-nearest_img_suggest))))+1*(sum(sum(abs(bicubic_img_suggest-bilinear_img_suggest))));

alpha =  16*((sum(sum(abs(bilinear_img_suggest-nearest_img_suggest))))/denominator);
beta =  4*((sum(sum(abs(bicubic_img_suggest-nearest_img_suggest))))/denominator);
gamma =  1*((sum(sum(abs(bicubic_img_suggest-bilinear_img_suggest))))/denominator);

%summation of alpha, beta and gamma should be 1
%alpha,beta and gamma could be tunned

suggestion_img = alpha * bicubic_img_suggest + beta * bilinear_img_suggest+ gamma *nearest_img_suggest;
toc

J=im2double(imread("Q4\Peppers.tif"));

NN_PSNR = MY_PSNR(nearest_img,J);
BL_PSNR = MY_PSNR(bilinear_img,J);
% my_bilinear_PSNR = MY_PSNR(my_bilinear_img,J);
ED_PSNR=MY_PSNR(ED_img,J);
bicubic_PSNR = MY_PSNR(bicubic_img,J);
suggestion_PSNR = MY_PSNR(suggestion_img,J);

imshow([nearest_img bilinear_img suggestion_img bicubic_img J],[]);

%show all psnrs as title
title({['NN PSNR=' num2str(NN_PSNR)  '   BL PSNR=' num2str(BL_PSNR)  '   ED PSNR=' num2str(ED_PSNR) ...
    '   BC PSNR=' num2str(bicubic_PSNR) '   My Way PSNR=' num2str(suggestion_PSNR)]});
