% Amirreza Hosseini
%      9820363
% Puzzle solver

%clear workspace and console
clc;clear;clear All;

%get a number from input
num = input('Enter puzzle number to solve: ');

%get the number for pieces
numOfPieces = input('Enter number of pieces: ');

%get directory and get all folder with seperated values by underline
directory = dir('Q4\');
directory = {directory.name};
directory = regexp(directory, '_', 'split');
%delete the first and second element of directory
directory(1:2) = [];

%the second value of each cell is the number of puzzle pick the one with equal number
%to input
for i = 1 : length(directory)
    if str2double(directory{i}{2}) == num
        directory = directory{i};
        break;
    end
end

%the third element of directory is the row size of puzzle
rowSize = str2double(directory{3});
%the fourth element of directory is the column size of puzzle
colSize = str2double(directory{4});

%go to the directory of puzzle
new_directory = ['Q4\' directory{1} '_' directory{2} '_' directory{3} '_' directory{4}];


orginal_image = imread([new_directory '\Original.tif']);

address=new_directory;
new_directory=dir(new_directory);
%remove non folder files from directory
new_directory = new_directory([new_directory.isdir]);
%remove . and .. from directory
new_directory = new_directory(~ismember({new_directory.name},{'.','..'}));
new_directory={new_directory.name};

%seperated values by underline
new_directory = regexp(new_directory, '_', 'split');
%keep the cells that first element of them is "Rotated" and remove others
for i = 1 : length(new_directory)
    if strcmp(new_directory{i}{1}, 'Unrotated')
        continue;
    else
        new_directory{i} = [];
    end
end
new_directory = new_directory(~cellfun('isempty',new_directory));

%the second value of each cell is the number of pieces pick the one with equal number
%to input
for i = 1 : length(new_directory)
    if str2double(new_directory{i}{2}) == numOfPieces
        new_directory = new_directory{i};
        break;
    end
end

%go to the directory of pieces
new_directory = [address '\' new_directory{1} '_' new_directory{2}];

%if the number of pieces is 40
if (numOfPieces==40)

    tempImage = imread([new_directory '\Corner_1_1.tif']);
    rSize = size(tempImage, 1);
    numOfPatches = (rowSize / rSize) * (colSize / rSize) - 4;
    corner1 = imread([new_directory '\Corner_1_1.tif']);
    corner2 = imread([new_directory '\Corner_1_8.tif']);
    corner3 = imread([new_directory '\Corner_5_1.tif']);
    corner4 = imread([new_directory '\Corner_5_8.tif']);
end

%if the number of pieces is 160
if (numOfPieces==160)

    tempImage = imread([new_directory '\Corner_1_1.tif']);
    rSize = size(tempImage, 1);
    numOfPatches = (rowSize / rSize) * (colSize / rSize) - 4;
    corner1 = imread([new_directory '\Corner_1_1.tif']);
    corner2 = imread([new_directory '\Corner_1_16.tif']);
    corner3 = imread([new_directory '\Corner_10_1.tif']);
    corner4 = imread([new_directory '\Corner_10_16.tif']);
end

%if the number of pieces is 640
if (numOfPieces==640)

    tempImage = imread([new_directory '\Corner_1_1.tif']);
    rSize = size(tempImage, 1);
    numOfPatches = (rowSize / rSize) * (colSize / rSize) - 4;
    corner1 = imread([new_directory '\Corner_1_1.tif']);
    corner2 = imread([new_directory '\Corner_1_32.tif']);
    corner3 = imread([new_directory '\Corner_20_1.tif']);
    corner4 = imread([new_directory '\Corner_20_32.tif']);
end

finalImage = uint8(zeros(rowSize, colSize, 3));
finalImage(1: rSize, 1: rSize, :) = corner1;
finalImage(1: rSize, colSize - rSize + 1: colSize, :) = corner2;
finalImage(rowSize - rSize + 1: rowSize, 1: rSize, :) = corner3;
finalImage(rowSize - rSize + 1: rowSize, colSize - rSize + 1: colSize, :) = corner4;

patches = uint8(zeros(numOfPatches, rSize, rSize, 3));

i = 1;
while i <= numOfPatches
    patches(i, :, :, :) = imread([new_directory '\Patch_' num2str(i) '.tif']);
    i = i + 1;
end

solution = zeros(rowSize / rSize, colSize / rSize);

i = 1;
while i <= rowSize
    j = 1;
    while j <= colSize
        if (((i == 1) && (j == 1)) || ((i == rowSize - rSize + 1) && (j == 1)) || ((i == 1) && (j == colSize - rSize + 1)) || ((i == rowSize - rSize + 1) && (j == colSize - rSize + 1)))
            j = j + rSize;
            continue;
        end
        if (i == 1)
            baseImage = finalImage(i: i + rSize - 1, j - rSize: j - 1, :);
            values = uint32(zeros(1, numOfPatches));
            
            k = 1;
            while k <= numOfPatches
                values(k) = Difference(rgb2gray(baseImage), rgb2gray(squeeze(patches(k, :, :, :))), 1);
                k = k + 1;
            end
            
            [minValue, minIndex] = min(values);
            finalImage(i: i + rSize - 1, j: j + rSize - 1, :) = patches(minIndex, :, :, :);
            solution(ceil(i / rSize), ceil(j / rSize)) = minIndex;
            imshow(finalImage, []);
        else
            baseImage = finalImage(i - rSize: i - 1, j: j + rSize - 1, :);
            values = uint32(zeros(1, numOfPatches));
            
            k = 1;
            while k <= numOfPatches
                values(k) = Difference(rgb2gray(baseImage), rgb2gray(squeeze(patches(k, :, :, :))), 0);
                k = k + 1;
            end
            
            if (j > 1)
                baseImage = finalImage(i: i + rSize - 1, j - rSize: j - 1, :);
                
                k = 1;
                while k <= numOfPatches
                    values(k) = values(k) + Difference(rgb2gray(baseImage), rgb2gray(squeeze(patches(k, :, :, :))), 1);
                    k = k + 1;
                end
            end
            
            [minValue, minIndex] = min(values);
            finalImage(i: i + rSize - 1, j: j + rSize - 1, :) = patches(minIndex, :, :, :);
            solution(ceil(i / rSize), ceil(j / rSize)) = minIndex;
            imshow(finalImage, []);
        end
        
        j = j + rSize;
    end
    
    i = i + rSize;
end

title('Solved Image with ' + string(numOfPieces) + ' pieces');