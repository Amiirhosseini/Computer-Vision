% Amirreza Hosseini
%      9820363
%Only Salt and Only Pepper Noise test

%clear workspace and console
clc;clear;clear All;

%read image
I=imread("./Street.bmp");

%noise percentage
noise_percentage = 0.6;

%test salt and pepper noise
MATLAB_SandP = imnoise(I, 'salt & pepper',noise_percentage);
Only_pepper_noise = only_pepper(I,noise_percentage);
Only_salt_noise = only_salt(I,noise_percentage);

%psnr for both cases
psnr_MATLAB = psnr(MATLAB_SandP,I);
psnr_Only_salt = psnr(Only_salt_noise,I);
psnr_Only_pepper=psnr(Only_pepper_noise,I);

%noise canceling check
kernel_size=3;
pepper_noise_canceled=noise_canceling(Only_pepper_noise,kernel_size);
salt_noise_canceled=noise_canceling(Only_salt_noise,kernel_size);


%show I and MATLAB_SandP and My SandP with title
figure;
subplot(1,2,1);imshow(I);title('Original Image');
subplot(1,2,2);imshow(MATLAB_SandP);title('MATLAB Salt and Pepper');
figure;
subplot(1,4,1);imshow(Only_salt_noise);title('My Only Salt');
subplot(1,4,2);imshow(Only_pepper_noise);title('My Only pepper');
subplot(1,4,3);imshow(salt_noise_canceled);title('My Only Salt canceled');
subplot(1,4,4);imshow(pepper_noise_canceled);title('My Only pepper canceled');