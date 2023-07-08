% Amirreza Hosseini
%      9820363
% generate diffrent kernels for Template Matching

%clear workspace and console
clc;clear;clear All;

%open directory
directory =dir( '.\Dataset\kernels_org_opencv2\*.bmp' );
imgs_num=length(directory(not([directory.isdir])));

%generated directory
generated_dir= '.\Dataset\kernels_generated\' ;

for i=1:imgs_num
    %read image
    img=imread(strcat( '.\Dataset\kernels_org_opencv2\' ,directory(i).name));
    %convert to gray
    img=rgb2gray(img);
    %resize image to 46*46
    img46=imresize(img,[46*2,46*2]);
    img27=imresize(img,[27*2,27*2]);
    img37=imresize(img,[37*2,37*2]);

    %create 2 version of image
    %first one is rotated +45 degree
    %second one is rotated -45 degree
    %white frame rotation wiith croped mode
    img46_1=imrotate_white(img46,45);
    img46_2=imrotate_white(img46,-45);
    img27_1=imrotate_white(img27,45);
    img27_2=imrotate_white(img27,-45);
    img37_1=imrotate_white(img37,45);
    img37_2=imrotate_white(img37,-45);

    %again resize
    img46_1=imresize(img46_1,[46*2,46*2]);
    img46_2=imresize(img46_2,[46*2,46*2]);
    img27_1=imresize(img27_1,[27*2,27*2]);
    img27_2=imresize(img27_2,[27*2,27*2]);
    img37_1=imresize(img37_1,[37*2,37*2]);
    img37_2=imresize(img37_2,[37*2,37*2]);


    %save image in bitmap with quality 100
    imwrite(img46,strcat('.\Dataset\kernels_generated\46\',num2str(i-1),'_','46','_','0','.jpg'),'jpg','Quality',100);
    imwrite(img46_1,strcat('.\Dataset\kernels_generated\46\',num2str(i-1),'_','46','_','45','.jpg'),'jpg','Quality',100);
    imwrite(img46_2,strcat('.\Dataset\kernels_generated\46\',num2str(i-1),'_','46','_','-45','.jpg'),'jpg','Quality',100);
    imwrite(img27,strcat('.\Dataset\kernels_generated\27\',num2str(i-1),'_','27','_','0','.jpg'),'jpg','Quality',100);
    imwrite(img27_1,strcat('.\Dataset\kernels_generated\27\',num2str(i-1),'_','27','_','45','.jpg'),'jpg','Quality',100);
    imwrite(img27_2,strcat('.\Dataset\kernels_generated\27\',num2str(i-1),'_','27','_','-45','.jpg'),'jpg','Quality',100);
    imwrite(img37,strcat('.\Dataset\kernels_generated\37\',num2str(i-1),'_','37','_','0','.jpg'),'jpg','Quality',100);
    imwrite(img37_1,strcat('.\Dataset\kernels_generated\37\',num2str(i-1),'_','37','_','45','.jpg'),'jpg','Quality',100);
    imwrite(img37_2,strcat('.\Dataset\kernels_generated\37\',num2str(i-1),'_','37','_','-45','.jpg'),'jpg','Quality',100);
end