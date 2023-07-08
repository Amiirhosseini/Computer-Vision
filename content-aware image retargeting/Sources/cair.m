function [outputImage, importance_map] = cair(inputImage, depthMap, saliencyMap, dimension, percentage)
%The main function for content-aware image retargeting system that handles
%the rest by calling other functions
    height = size(inputImage, 1);
    width = size(inputImage, 2);

    K = medfilt2(rgb2gray(inputImage), [3 3]);
    gradientMap = imgradient(K);

    d135line_kernel = [-2 -1 0; -1 0 1; 0 1 2];
    d45line_kernel = [0 -1 -2; 1 0 -1; 2 1 0];

    g135map = double(imfilter(K, d135line_kernel));
    g45map = double(imfilter(K, d45line_kernel));

    emap_canny = edge(K, 'canny');
    emap_sobel=edge(K,'sobel');

    importance_map = ...
        3 * normalize(depthMap) + ...
        normalize(saliencyMap) + ...
        2 * normalize(gradientMap) + ...
        2 * normalize(emap_canny) + ...
        normalize(emap_sobel) + ...
        3 * normalize(max(g45map, g135map));

    importance_map = medfilt2(importance_map, [5 5]);

    if percentage < 1
        outputImage = seamCarve(inputImage, dimension, percentage * .7, importance_map, 1);
    else
        outputImage = seamInsert(inputImage, dimension, (percentage-1) * .7, importance_map);
    end

    figure;
    subplot(2,3,1);
    imshow(depthMap,[]);
    title('Depth Map');

    subplot(2,3,2);
    imshow(saliencyMap,[]);
    title('Saliency Map');

    subplot(2,3,3);
    imshow(gradientMap,[]);
    title('Gradient Map');
    
 subplot(2,3,4);
    imshow(importance_map,[]);
    title('Importance Map');

    subplot(2,3,5);
    imshow(emap_canny);
    title('Edge (canny) Image');

    subplot(2,3,6);
    imshow(emap_sobel);
    title('Edge (sobel) Image');

    if (dimension == 0)
        outputImage = imresize(outputImage, [height max(width,(1 + percentage-1) * width)], 'bicubic');
    else
        outputImage = imresize(outputImage, [max(height,(1 + percentage-1) * height) width], 'bicubic');
    end
end



function outputImage = seamInsert(inputImage, dimension, percentage, importance_map)
% The seamInsert function takes an input image, a dimension (0 for width or 1 for height), a percentage, and an importance map as inputs. 
% It returns an output image with seams inserted based on the importance map.
% The function first finds the optimal seams to remove from the image using the getOptimalSeam function. 
% These seams are stored in a cell array. Then the function iterates over the seams in reverse order and 
% inserts them into the image using the insertSeam function.

    original_size = size(inputImage, 2 - dimension);
    seams = cell(round(percentage * original_size), 1);
    tempImage = inputImage;
    tempImportanceMap = importance_map;
    for i = 1:round(percentage * original_size)
        optimalSeam = getOptimalSeam(tempImage, dimension, tempImportanceMap, 1);
        seams{i} = optimalSeam;
        [tempImage, ~] = removeSeam(tempImage, dimension, optimalSeam);
        tempImportanceMap = updateImportance(tempImportanceMap, 0, optimalSeam);
        tempImportanceMap = medfilt2(tempImportanceMap,[3 3]);
        [tempImportanceMap, ~] = removeSeam(tempImportanceMap, dimension, optimalSeam);
    end
    outputImage = inputImage;
    seams_energy = zeros(size(seams));
    for i=1:size(seams)
        if (dimension == 0)
            for j=1:size(seams{i})
                seams_energy(i) = seams_energy(i) + importance_map(j,seams{i}(j));
            end
        else
            for j=1:size(seams{i})
                seams_energy(i) = seams_energy(i) + importance_map(seams{i}(j),j);
            end
        end
    end
    [~,idx]=sort(seams_energy);
    for i=1:size(idx)
        [outputImage, importance_map] = insertSeam(outputImage, dimension, seams{idx(i)}, importance_map);
        figure(1);
        subplot(1,2,1);
        imshow(uint8(showSeam(outputImage, seams{idx(i)})), []);
        subplot(1,2,2);
        imshow(importance_map,[]);
        
        current_percentage = i / original_size;
        disp(['Current Percentage: ' num2str(current_percentage * 100) '%']);
    end
end


function [outputImage, new_importance_map] = insertSeam(inputImage, dimension, optimalSeam, importance_map)
% The insertSeam function takes an input image, a dimension (0 for width or 1 for height), an optimal seam and an importance map as inputs. 
% It returns an output image with the seam inserted and the updated importance map.
% The updated importance map is calculated by inserting the average of the neighboring pixels along the seam into the importance map.
    if (dimension == 0)
        outputImage = zeros(size(inputImage, 1), size(inputImage, 2) + 1, size(inputImage, 3));
        new_importance_map = zeros(size(importance_map,1),size(importance_map,2)+1);
        for i = 1: size(outputImage, 1)
            if optimalSeam(i) == 1
                new_pixel = inputImage(i,optimalSeam(i),:);
                new_importance_pixel = importance_map(i,optimalSeam(i));
            elseif optimalSeam(i) == size(inputImage,2)
                new_pixel = inputImage(i,optimalSeam(i),:);
                new_importance_pixel = importance_map(i,optimalSeam(i));
            else
                new_pixel = (inputImage(i,optimalSeam(i)-1,:) + inputImage(i,optimalSeam(i)+1,:))/2;
                new_importance_pixel = (importance_map(i,optimalSeam(i)-1) + importance_map(i,optimalSeam(i)+1))/2;
            end
            outputImage(i,:, :) = [inputImage(i, 1:optimalSeam(i), :), new_pixel,inputImage(i,optimalSeam(i)+1:end,:)];
            new_importance_map(i,:) = [importance_map(i, 1:optimalSeam(i)), new_importance_pixel,importance_map(i,optimalSeam(i)+1:end)];
        end
    else
        outputImage = zeros(size(inputImage, 1) + 1, size(inputImage, 2), size(inputImage, 3));
        new_importance_map = zeros(size(importance_map,1)+1,size(importance_map,2));
        for i = 1: size(outputImage, 2)
            if optimalSeam(i) == 1
                new_pixel = inputImage(optimalSeam(i),i,:);
                new_importance_pixel = importance_map(optimalSeam(i),i);
            elseif optimalSeam(i) == size(inputImage,1)
                new_pixel = inputImage(optimalSeam(i),i,:);
                new_importance_pixel = importance_map(optimalSeam(i),i);
            else
                new_pixel = (inputImage(optimalSeam(i)-1,i,:) + inputImage(optimalSeam(i)+1,i,:))/2;
                new_importance_pixel = (importance_map(optimalSeam(i)-1,i) + importance_map(optimalSeam(i)+1,i))/2;
            end
            outputImage(:, i,:) = [inputImage(1:optimalSeam(i),i,:), new_pixel,inputImage(optimalSeam(i)+1:end,i,:)];
            new_importance_map(:,i) = [importance_map(1:optimalSeam(i),i);new_importance_pixel;importance_map(optimalSeam(i)+1:end,i)];
        end
    end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [outputImage, last_importance_map] = seamCarve(inputImage, dimension, percentage, importance_map, k)
    outputImage = inputImage;
    original_size = size(inputImage, 2 - dimension);
    for i = 1:round(percentage * size(inputImage, 2))
        optimalSeam = getOptimalSeam(outputImage, dimension, importance_map, k);
        figure(1);
        subplot(1,2,1);
        imshow(uint8(showSeam(outputImage, optimalSeam)), []);
        subplot(1,2,2);
        imshow(importance_map,[]);
        [outputImage, ~] = removeSeam(outputImage, dimension, optimalSeam);
        importance_map = updateImportance(importance_map, 0, optimalSeam);
        importance_map = medfilt2(importance_map,[3 3]);
        [importance_map, ~] = removeSeam(importance_map, dimension, optimalSeam);

        current_percentage = i / original_size;
        disp(['Current Percentage: ' num2str(current_percentage * 100) '%']);
    end
    last_importance_map = importance_map;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function S = getOptimalSeam(I, dimension, importance_map, k)
%   This function takes an input image I, a dimension (0 for width or 1 for height), 
% an importance map and a value k as inputs. It returns the optimal seam S to be removed from the image.
if (dimension == 0)%modifying width size
    S = squeeze(zeros(1, size(I, 1)));
    seams_table = double(zeros(size(importance_map)));
    navigator = zeros(size(importance_map));
    for i = 1: size(I, 1)
        for j = 1: size(I, 2)
            upper_nodes = realmax * squeeze(ones(1, 2 * k + 1));
            upper_nodes(k + 1) = 0;
            for l = -k: k
                if (j + l >= 1 && j + l <= size(I, 2) && i - 1 >= 1)
                    upper_nodes(l + k + 1) = seams_table(i - 1, j + l);
                end
            end
            [val, idx] = min(upper_nodes);
            seams_table(i, j) = importance_map(i, j) + val;
            navigator(i, j) = j + idx - k - 1;
        end
    end
    [~, min_seam_idx] = min(squeeze(seams_table(size(I, 1), :)));
    x = min_seam_idx;
    for i = size(I, 1): -1: 1
        S(i) = x;
        x = navigator(i, x);
    end
else%modifying height size
    S = zeros(size(I, 2));
    seams_table = double(zeros(size(importance_map)));
    navigator = zeros(size(importance_map));
    for j = 1: size(I, 2)
        for i = 1: size(I, 1)
            upper_nodes = realmax * squeeze(ones(1, 2 * k + 1));
            upper_nodes(k + 1) = 0;
            for l = -k: k
                if (i + l >= 1 && i + l <= size(I, 1) && j - 1 >= 1)
                    upper_nodes(l + k + 1) = seams_table(i + l, j - 1);
                end
            end
            [val, idx] = min(upper_nodes);
            seams_table(i, j) = importance_map(i, j) + val;
            navigator(i, j) = i + idx - k - 1;
        end
    end
    [~, min_seam_idx] = min(squeeze(seams_table(:, size(I, 2))));
    x = min_seam_idx;
    for i = size(I, 2): -1: 1
        S(i) = x;
        x = navigator(x, i);
    end
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [outputImage, seam_val] = removeSeam(inputImage, dimension, optimalSeam)
%   This function takes an input image I, a dimension (0 for width or 1 for height), 
% and an optimal seam S as inputs. It returns the output image with the seam removed and the value of the seam.
seam_val = 0;
if (dimension == 0)%modifying width size
    outputImage = zeros(size(inputImage, 1), size(inputImage, 2) - 1, size(inputImage, 3));
    for i = 1: size(outputImage, 1)
        seam_val = seam_val + double(inputImage(i, optimalSeam(i)));
        outputImage(i, :, :) = squeeze(inputImage(i, 1: end ~= optimalSeam(i), :));
    end
else%modifying height size
    outputImage = zeros(size(inputImage, 1) - 1, size(inputImage, 2), size(inputImage, 3));
    for i = 1: size(outputImage, 2)
        seam_val = seam_val + double(inputImage(optimalSeam(i), i));
        outputImage(:, i, :) = squeeze(inputImage(1: end ~= optimalSeam(i), i, :));
    end
end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function new_importance_map = updateImportance(importance_map, dimension, S)
%UPDATEIMPORTANCE Summary of this function goes here
%   This function takes an importance map, a dimension (0 for width or 1 for height), and a seam S as inputs. 
% It returns a new importance map with updated values based on the removed seam.
new_importance_map = importance_map;
if (dimension == 0)
    for i = 1: size(importance_map, 1)
        if (S(i) - 1 >= 1 && S(i) + 1 <= size(importance_map, 2))
            new_importance_map(i, S(i) - 1) = new_importance_map(i, S(i) - 1) + 0.491/2*new_importance_map(i, S(i));
            new_importance_map(i, S(i) + 1) = new_importance_map(i, S(i) + 1) + 0.491/2*new_importance_map(i, S(i));
        end
        if (S(i) - 2 >= 1 && S(i) + 2 <= size(importance_map, 2))
            new_importance_map(i, S(i) - 2) = new_importance_map(i, S(i) - 2) + 0.009/2*new_importance_map(i, S(i));
            new_importance_map(i, S(i) + 2) = new_importance_map(i, S(i) + 2) + 0.009/2*new_importance_map(i, S(i));
        end
        
    end
else
    for j = 1: size(importance_map, 2)
        if (S(j - 1) >= 1 && S(j) + 1 <= size(importance_map, 1))
            new_importance_map(S(j) - 1, j) = new_importance_map(S(j) - 1, j) + 0.5*new_importance_map(S(j), j);
            new_importance_map(S(j) + 1, j) = new_importance_map(S(j) + 1, j) + 0.5*new_importance_map(S(j), j);
        end
    end
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function outputImage = showSeam(inputImage, optimalSeam)
%   This function takes an input image I and an optimal seam S as inputs. 
% It returns the input image with the seam highlighted in red.
outputImage = inputImage;
if (size(optimalSeam, 2) == size(inputImage, 1))
    for i = 1: size(optimalSeam, 2)
        outputImage(i, optimalSeam(i), 1) = 255;
        outputImage(i, optimalSeam(i), 2) = 0;
        outputImage(i, optimalSeam(i), 3) = 0;
    end
else
    for i = 1: size(optimalSeam, 2)
        outputImage(optimalSeam(i), i, 1) = 255;
        outputImage(optimalSeam(i), i, 2) = 0;
        outputImage(optimalSeam(i), i, 3) = 0;
    end
end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = normalize(x)
%NORMALIZE Normalize the input array using min-max normalization
%   This function takes an input array x and returns a normalized version of the array using min-max normalization.
y = (x - min(x(:))) / (max(x(:)) - min(x(:)));
end

