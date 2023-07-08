function J = auto_crop(inputImage, energyMap, remain_percent)
    croppedImageWidth = int16(round(size(inputImage, 2) * remain_percent));
    croppedImage = zeros(size(inputImage, 1), croppedImageWidth, 'double');
    max_energy = 0;
    max_index = 0;
    for i = 1:size(inputImage, 2) - size(croppedImage, 2) + 1
        energy_frame = energyMap(:, i:size(croppedImage, 2) + i - 1);
        value = sum(sum(energy_frame));
        if value > max_energy
            max_index = i;
            max_energy = value;
        end
    end
    J = inputImage(:, max_index:size(croppedImage, 2) + i - 1, :);
end