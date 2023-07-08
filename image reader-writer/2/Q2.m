% Amirreza Hosseini
%      9820363

%clear workspace and console
clc;clear;clear All;

%main program

sample_path=find_path("sample.ppm");


I=im2double(image_read(sample_path));

J=I;
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);

for i=1:size(I,1)
    for j=1:size(I,2)

        if round(sqrt((((i-size(I,1)/2)^2)/800^2) + ((j-size(I,2)/2)^2)/400^2))<1 || round(sqrt((((i-size(I,1)/2)^2)/400^2) + ((j-size(I,2)/2)^2)/800^2))<1

            if round(sqrt((((i-size(I,1)/2)^2)/400^2) + ((j-size(I,2)/2)^2)/800^2))<1

                I(i,j,1)=1-I(i,j,1);
                I(i,j,2)=1-I(i,j,2);
                I(i,j,3)=1-I(i,j,3);

                if round(sqrt((((i-size(I,1)/2)^2)/800^2) + ((j-size(I,2)/2)^2)/400^2))<1
                    I(i,j,1)=1;
                    I(i,j,2)=1;
                    I(i,j,3)=1;

                end
            end

        else
            % RGB to Gray scale
            I(i,j,1)=(0.2989*R(i,j)+0.5870*G(i,j)+0.1140*B(i,j))/3;
            I(i,j,2)=(0.2989*R(i,j)+0.5870*G(i,j)+0.1140*B(i,j))/3;
            I(i,j,3)=(0.2989*R(i,j)+0.5870*G(i,j)+0.1140*B(i,j))/3;

        end


    end

end

%double to uint8
I = uint8(255 * mat2gray(I));
J = uint8(255 * mat2gray(J));

figure,imshow([I;J],[]);
title('image by new image read function:');


%--------------------------------------save test for ppm
save_image(I,"ppm",852,1282,"saved_modifeid_sample.ppm");





%find the absolute path of relative sample file in the current folder
function sample_path = find_path(input)

currentFile = matlab.desktop.editor.getActiveFilename;

x=mfilename()+".m";

currentFolder = erase(currentFile,x);

sample_path=currentFolder + input;

end



%save pgm and ppm format with given argumants
function save_image(image_data,image_type,column_size,row_size,relative_path)

%pgm case
if image_type=="pgm"

    head=[80; 53; 32];

    %ascii to decimal
    row_size=num2str(row_size);
    row_size=double(row_size);

    row_size=reshape(row_size,[],1);

    head=[head;row_size];
    head(end+1)=32;

    %ascii to decimal
    column_size=num2str(column_size);
    column_size=double(column_size);

    column_size=reshape(column_size,[],1);

    head=[head;column_size];
    head(end+1)=32;
    brightness=[50;53;53];
    head=[head;brightness];
    head(end+1)=10; %space ascii

    image_data=reshape(image_data.',[],1);
    file_content=[head;image_data];
end

%ppm case
if image_type=="ppm"

    head=[80; 54; 32];

    row_size_int=row_size;
    column_size_int=column_size;

    %ascii to decimal
    row_size=num2str(row_size);
    row_size=double(row_size);

    row_size=reshape(row_size,[],1);

    head=[head;row_size];
    head(end+1)=32;

    %ascii to decimal
    column_size=num2str(column_size);
    column_size=double(column_size);

    column_size=reshape(column_size,[],1);

    head=[head;column_size];
    head(end+1)=32;
    brightness=[50;53;53];
    head=[head;brightness];
    head(end+1)=10; %space ascii

    R=image_data(:,:,1);
    G=image_data(:,:,2);
    B=image_data(:,:,3);

    image=zeros();

    for i=1:column_size_int
        for j=1:row_size_int
            image(end+1)=R(i,j);
            image(end+1)=G(i,j);
            image(end+1)=B(i,j);
        end
    end

    image=image(2:end);
    image=reshape(image.',[],1,1);
    file_content=[head;image];

end

absolute_path=find_path(relative_path);
%create a file
f = fopen(absolute_path,'w');
%write data to file
fwrite(f,file_content);
%close file
fclose(f);

end
