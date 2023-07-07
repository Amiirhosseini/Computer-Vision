function draw_rectangles(labeled_image, input_image)

    % Get region properties of labeled image
    stats = regionprops(labeled_image, 'BoundingBox');

    % Create figure and axis object
    fig = figure;
    ax = axes('Parent', fig);

    % Display the input image
    imshow(input_image, [], 'Parent', ax);

    % Loop over each labeled region and draw a rectangle around it
    hold(ax, 'on');
    for i = 1:numel(stats)
        bb = stats(i).BoundingBox;
        rectangle(ax, 'Position', bb, 'EdgeColor', 'g', 'LineWidth', 1);
    end
    hold(ax, 'off');

end