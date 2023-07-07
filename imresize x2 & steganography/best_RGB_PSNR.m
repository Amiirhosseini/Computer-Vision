function new_BW_pic = best_RGB_PSNR(I)
new_BW_pic=zeros(size(I,1),size(I,2));

%maingin har kanal
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);

J=R/3 + G/3 +B/3;

new_BW_pic=best_BW_PSNR(rgb2gray(I));

gray=rgb2gray(I);


%bara har kanal mojaza badesh miangin begirim
% R_BW=best_BW_PSNR(R);
% G_BW=best_BW_PSNR(G);
% B_BW=best_BW_PSNR(B);
% 
% new_BW_pic=R_BW/3+G_BW/3+B_BW/3;
end