% Amirreza Hosseini
%      9820363

%clear workspace and console
clc;clear;clear All;

key=rng;
secret_msg=imread("Q5\Image_1.tif");
cover_img=imread("Q5\Image_2.tif");

stego_img=My_Encode(cover_img,secret_msg);

figure;
subplot(1,2,1);
imshow(cover_img,[]);
title("cover image");
subplot(1,2,2);
imshow(stego_img,[]);
title("stego image");

imwrite(stego_img,"Q5\stego_image.tif");
save("Q5\key","key");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clear workspace and console
clc;clear;clear All;
load 'Q5\key'
stego_img=imread("Q5\stego_image.tif");
rng(key);

secret_msg=My_Decode(stego_img);

figure;
imshow(secret_msg,[]);
title("secret message");