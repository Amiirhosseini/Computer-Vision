clc;clear;close all;

I = im2double(imread('./leaves.png'));

%first diffrence filter for x direction
h1 = [-1 0 1];
%second diffrence filter for y direction
h2 = [-1;0;1];

%apply first diffrence filter for x direction
dx = imfilter(I,h1);
%apply second diffrence filter for y direction
dy = imfilter(I,h2);

subplot(1,4,1);
imshow(abs(dx),[]);
title("|dx|");

subplot(1,4,2);
imshow(abs(dy),[]);
title("|dy|");

subplot(1,4,3);
imshow(abs(dx+dy),[]);
title("|dx+dy|");

subplot(1,4,4);
imshow(abs(dx)+abs(dy),[]);
title("|dx|+|dy|");

%-45 Sobel kernel   
h3 = [-2 -1 0;-1 0 1;0 1 2];
%45 Sobel kernel
h4 = [0 -1 -2;1 0 -1;2 1 0];

%apply -45 Sobel kernel
d45 = imfilter(I,h3);
%apply 45 Sobel kernel
d135 = imfilter(I,h4);

figure;
subplot(1,3,1);
imshow(abs(d45),[]);
title("Sobel 45");

subplot(1,3,2);
imshow(abs(d135),[]);
title("Sobel 135");

subplot(1,3,3);
imshow(abs(dx)+abs(dy),[]);
title("|dx|+|dy|");