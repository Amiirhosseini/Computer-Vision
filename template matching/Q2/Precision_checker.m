% Amirreza Hosseini
%      9820363
% check accuracy and performance of the CIBR system

%clear workspace and console
clc;clear;clear All;

%open directory
Result_directory =dir( '.\Dataset\Results\*.txt' );
Result_num=length(Result_directory(not([Result_directory.isdir])));

%open Ground Truth diractory
Coordinates_directory =dir( '.\Dataset\Coordinates\*.txt' );
Coordinates_num=length(Coordinates_directory(not([Coordinates_directory.isdir])));

sum_result=0;
total=0;
for i=1:1:Result_num
    %open result file
    Result_file=Result_directory(i).name;
    Result_fileID=fopen(strcat(Result_directory(i).folder,'\',Result_file));
    %get result data into the tuple
    Result_data=textscan(Result_fileID, '%d, %d, %d' );
    %close result file
    fclose(Result_fileID);

    %split the name of result file by underline
    Result_file_split=strsplit(Result_file,'_');
    coord_search=strcat("coord_",Result_file_split(2));
    %open coordinates file
    Coordinates_file=coord_search;
    Coordinates_fileID=fopen(strcat(Coordinates_directory(i).folder,'\',Coordinates_file));
    %get coordinates data into the tuple
    Coordinates_data=textscan(Coordinates_fileID, '%d, %d, %d' );
    %close coordinates file
    fclose(Coordinates_fileID);

    %split each tuple into three variables
    Result_data_splited=cell2mat(Result_data);
    Coordinates_data_splited=cell2mat(Coordinates_data);

    %len = min of length of result and coordinates
    len=min(length(Result_data_splited),length(Coordinates_data_splited));

    %checking the accuracy for length of result data
    for j=1:len
       
        %find if it is inside the circle
        R= Coordinates_data_splited(j,3);
        if (Result_data_splited(j,1)-Coordinates_data_splited(j,1))^2+(Result_data_splited(j,2)-Coordinates_data_splited(j,2))^2<=R^2
            sum_result=sum_result+1;
        end
        total=total+1;
    end
end

accuracy=sum_result/total;

%print accuracy
fprintf( 'Accuracy: %f\n',accuracy);