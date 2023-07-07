% Amirreza Hosseini
%      9820363
%test the performance of BWlabal function on the image as ground truth
clc;clear;close all;

%read image
img = im2double(imread('cells.tif'));


%show image
figure(1);
imshow(img,[]);

%threshold the image
T=multithresh(img,1)
img=imbinarize(img,T);

se = strel('disk', 2);
img = imerode(img, se);

%use bwlable to label the image
labeled_img = bwlabel(img,8);

count=max(max(labeled_img))

%RGB label the image
labeled_img = label2rgb(labeled_img);

%show the labeled image
figure(2);
imshow(labeled_img);