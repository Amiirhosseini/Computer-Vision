% Amirreza Hosseini
%      9820363
%Salt and Pepper Noise test

%clear workspace and console
clc;clear;clear All;

%read image
I=imread("./Street.bmp");

%noise percentage
noise_percentage = 0.12;

%test salt and pepper noise
MATLAB_SandP = imnoise(I, 'salt & pepper',noise_percentage);
My_SandP = salt_pepper(I,noise_percentage);

%psnr for both cases
psnr_MATLAB = psnr(MATLAB_SandP,I);
psnr_My = psnr(My_SandP,I);


%show I and MATLAB_SandP and My SandP with title
figure;
subplot(1,3,1);imshow(I);title('Original Image');
subplot(1,3,2);imshow(MATLAB_SandP);title('MATLAB Salt and Pepper');
subplot(1,3,3);imshow(My_SandP);title('My Salt and Pepper');




