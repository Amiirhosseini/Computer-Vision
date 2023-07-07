% Amirreza Hosseini
%      9820363

%clear workspace and console
clc;clear;clear All;

%main program

%Gray scale resize test
% I=im2double(imread("Q4\Boat.png"));
% 
% Resizing_Factor=4;
% 
% NN_Image=My_Imresize_NN(I,Resizing_Factor);
% NN_Image=My_Imresize_NN(NN_Image,1/Resizing_Factor);
% 
% BL_Image=My_Imresize_BL(I,Resizing_Factor);
% BL_Image=My_Imresize_BL(BL_Image,1/Resizing_Factor);
% 
% ED_Image=My_Imresize_ED(I,Resizing_Factor);
% ED_Image=My_Imresize_ED(ED_Image,1/Resizing_Factor);
% 
% NN_PSNR=MY_PSNR(I,NN_Image);
% BL_PSNR=MY_PSNR(I,BL_Image);
% ED_PSNR=MY_PSNR(I,ED_Image);
% 
% %Compare with MATLAB functions
% NN_MATLAB_Image = imresize(I,Resizing_Factor,'nearest');
% NN_MATLAB_Image = imresize(NN_MATLAB_Image,1/Resizing_Factor,'nearest');
% 
% BL_MATLAB_Image = imresize(I,Resizing_Factor,'bilinear');
% BL_MATLAB_Image = imresize(BL_MATLAB_Image,1/Resizing_Factor,'bilinear');
% 
% %MATLAB PSNR
% NN_MATLAB_PSNR= MY_PSNR(I,NN_MATLAB_Image);
% BL_MATLAB_PSNR= MY_PSNR(I,BL_MATLAB_Image);
% 
% %show each of them in subplot with psnr and name as title
% figure; 
% subplot(2,3,1);imshow(NN_Image,[]);title(['NN PSNR=' num2str(NN_PSNR)]);
% subplot(2,3,2);imshow(BL_Image,[]);title(['BL PSNR=' num2str(BL_PSNR)]);
% subplot(2,3,3);imshow(ED_Image,[]);title(['ED PSNR=' num2str(ED_PSNR)]);
% subplot(2,3,4);imshow(NN_MATLAB_Image,[]);title(['MATLAB NN PSNR=' num2str(NN_MATLAB_PSNR)]);
% subplot(2,3,5);imshow(BL_MATLAB_Image,[]);title(['MATLAB BL PSNR=' num2str(BL_MATLAB_PSNR)]);
% subplot(2,3,6);imshow(I,[]);title('MAIN IMAGE');

%RGB resize test
I=im2double(imread("Q5\Image_1.tif"));

Resizing_Factor=8;

NN_Image=My_Imresize_NN_RGB(I,Resizing_Factor);
NN_Image=My_Imresize_NN_RGB(NN_Image,1/Resizing_Factor);

BL_Image=My_Imresize_BL_RGB(I,Resizing_Factor);
BL_Image=My_Imresize_BL_RGB(BL_Image,1/Resizing_Factor);

ED_Image=My_Imresize_ED_RGB(I,Resizing_Factor);
ED_Image=My_Imresize_ED_RGB(ED_Image,1/Resizing_Factor);

%Output_Image=My_Imresize_ED(Output_Image,1/2);

NN_PSNR=MY_RGB_PSNR(I,NN_Image);
BL_PSNR=MY_RGB_PSNR(I,BL_Image);
ED_PSNR=MY_RGB_PSNR(I,ED_Image);

%MATLAB functions
NN_MATLAB_Image = imresize(I,Resizing_Factor,'nearest');
NN_MATLAB_Image = imresize(NN_MATLAB_Image,1/Resizing_Factor,'nearest');

BL_MATLAB_Image = imresize(I,Resizing_Factor,'bilinear');
BL_MATLAB_Image = imresize(BL_MATLAB_Image,1/Resizing_Factor,'bilinear');

NN_MATLAB_PSNR=MY_RGB_PSNR(I,NN_MATLAB_Image);
BL_MATLAB_PSNR=MY_RGB_PSNR(I,BL_MATLAB_Image);


%show each of them in subplot with psnr and name as title   
figure;
subplot(2,3,1);imshow(NN_Image,[]);title(['NN PSNR=' num2str(NN_PSNR)]);
subplot(2,3,2);imshow(BL_Image,[]);title(['BL PSNR=' num2str(BL_PSNR)]);
subplot(2,3,3);imshow(ED_Image,[]);title(['ED PSNR=' num2str(ED_PSNR)]);
subplot(2,3,4);imshow(NN_MATLAB_Image,[]);title(['MATLAB NN PSNR=' num2str(NN_MATLAB_PSNR)]);
subplot(2,3,5);imshow(BL_MATLAB_Image,[]);title(['MATLAB BL PSNR=' num2str(BL_MATLAB_PSNR)]);
subplot(2,3,6);imshow(I,[]);title('MAIN IMAGE');
