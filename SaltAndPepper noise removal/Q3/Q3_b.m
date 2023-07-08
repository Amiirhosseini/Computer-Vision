% Amirreza Hosseini
%      9820363

%clear workspace and console
clc;clear;clear All;

%read image
I=im2double(imread("./Baboon.tif"));

window = 3;

%list of psnr values
Median_PSNRs = zeros(1,9);
My_way_PSNRs = zeros(1,9);

for i = 3:2:9
        SandP = imnoise(I, 'salt & pepper', i/10);
        [My_way,avg_kernels]=noise_canceling(im2uint8(SandP),window);
        avg_kernels=round(avg_kernels);
        Median_kernel = medfilt2(SandP, [avg_kernels avg_kernels]);
        %check the psnr
        psnr_Median_kernel = psnr(Median_kernel,I);
        psnr_My_way = psnr(im2double(My_way),im2double(I));
        Median_PSNRs(i) = psnr_Median_kernel;
        My_way_PSNRs(i) = psnr_My_way;

        fprintf("noise = %f\n",i/10);
        fprintf("psnr_Median_kernel = %f\n",psnr_Median_kernel);
        fprintf("psnr_My_way = %f\n------------\n",psnr_My_way);

        figure;
        subplot(1,4,1);imshow(I);title('Original Image');
        subplot(1,4,2);imshow(SandP);title('Salt & Pepper Image' + " " + num2str(i/10) + " " + 'noise');
        subplot(1,4,3);imshow(Median_kernel);title('Median Filtered Image');
        subplot(1,4,4);imshow(My_way);title('My Way Filtered Image'); 
end

%calculate the average psnr
avg_Median_PSNRs = mean(Median_PSNRs);
avg_My_way_PSNRs = mean(My_way_PSNRs);

%show the average psnr
fprintf("avg_Median_PSNRs = %f\n",avg_Median_PSNRs);
fprintf("avg_My_way_PSNRs = %f\n",avg_My_way_PSNRs);