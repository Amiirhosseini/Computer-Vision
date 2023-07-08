function difference = Difference(image1, image2, direction)
    %diff calculates the difference between the borders of two images
    %   image1 and image2 are the input images
    %   direction indicates whether to calculate the horizontal or vertical border difference
    
    % Convert the images to int64 for accurate calculations
    image1 = int64(image1);
    image2 = int64(image2);
    
    % Determine the size of one side of the square image
    imageSize = size(image1, 1);
    
    % Initialize the difference variable to uint64
    difference = uint64(0);
    
    if (direction == 0)
        % Calculate horizontal border difference
        difference = sum((image1(imageSize, :) - image2(1, :)) .^ 2);
    else
        % Calculate vertical border difference
        difference = sum((image1(:, imageSize) - image2(:, 1)) .^ 2);
    end
    