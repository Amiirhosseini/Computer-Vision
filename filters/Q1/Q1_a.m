clc;clear;close all;

I=imread("./Street.bmp");

pad_size = [50 50];

zero=padarray(I,pad_size);
replicate=padarray(I,pad_size,"replicate");
symmetry=padarray(I,pad_size,'symmetric');
circle=padarray(I,pad_size,"circular");


subplot(2,2,1);
imshow(zero,[]);
title("zero padding");

subplot(2,2,2);
imshow(replicate,[]);
title("replicate padding");

subplot(2,2,3);
imshow(symmetry,[]);
title("symmetric padding");

subplot(2,2,4);
imshow(circle,[]);
title("circular padding");