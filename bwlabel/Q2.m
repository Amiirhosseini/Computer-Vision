% Amirreza Hosseini
%      9820363
%test the performance of My_BWlabel function

clc; clear; close all;

% Load the image
input_image = imread("./Cells.tif");

% Apply Otsu's thresholding method to get a binary image
threshold_level = multithresh(input_image, 1);
binary_image = imbinarize(input_image, double(threshold_level(1))/255);

% Apply morphological opening to remove small objects and smooth the edges
structuring_element = strel('disk', 2);
binary_image = imopen(binary_image, structuring_element);

% Initialize variables for connected component labeling
labeled_image = zeros(size(binary_image)); % output labeled image
current_label = 0;   % current label being assigned

% Loop over each pixel of the binary image
for y=1 : size(binary_image,1)
    for x=1 : size(binary_image,2)
        % If the pixel is foreground and has not been labeled yet,
        % assign a new label and use My_BWlabel function to label its connected components
        if binary_image(y,x) == 1 && labeled_image(y,x) == 0
            current_label = current_label + 1;
            [labeled_image, current_label] = My_BWlabel(y, x, binary_image, labeled_image, current_label);
        end
    end
end

% Display the labeled image in color
imshow(label2rgb(labeled_image),[]);

% Draw rectangles around each labeled cell in the original input image
draw_rectangles(labeled_image, input_image);

%write to excel file
Write2File(input_image, labeled_image, current_label, "./result.xlsx");
