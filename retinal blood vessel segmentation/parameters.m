function [tp, tn, fp, fn] = parameters(I, ground,mode)

tp = 0;
tn = 0;
fp = 0;
fn = 0;

for i = 1: size(I, 1)
    for j = 1: size(I, 2)
        if mode==1
            if (I(i, j) == 1 && ground(i, j) == 255)%for first manual 255 and for second manual 1
                tp = tp + 1;
            end
            if (I(i, j) == 0 && ground(i, j) == 255)
                fn = fn + 1;
            end

        elseif mode==2
            if (I(i, j) == 1 && ground(i, j) == 1)%for first manual 255 and for second manual 1
                tp = tp + 1;
            end
            if (I(i, j) == 0 && ground(i, j) == 1)
                fn = fn + 1;
            end
        end
        if (I(i, j) == 0 && ground(i, j) == 0)
            tn = tn + 1;
        end
        if (I(i, j) == 1 && ground(i, j) == 0)
            fp = fp + 1;
        end
    end
end

% % Create a binary mask for each parameter
% tp_mask = (I == 1) & ((mode == 1 & ground == 255) | (mode == 2 & ground == 1));
% tn_mask = (I == 0) & (ground == 0);
% fp_mask = (I == 1) & (ground == 0);
% fn_mask = (I == 0) & ((mode == 1 & ground == 255) | (mode == 2 & ground == 1));
% 
% % Create a color-coded image of all the parameters
% img = zeros([size(I), 3]);
% img(:,:,1) = double(tn_mask); % Red channel: True negative
% img(:,:,2) = double(fn_mask); % Green channel: False negative
% img(:,:,3) = double(tp_mask | fp_mask); % Blue channel: True/False positive
% 
% % Display the image
% imshow(I);
% hold on;
% h = imshow(img);
% set(h, 'AlphaData', 0.5);
% hold off;



end

