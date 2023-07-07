function write_to_file(main_image, label_image, num_labels ,file_path)

    label_image = uint8(label_image);
    hist_data = MY_histogram(uint8(label_image));

    excel_data = cell(num_labels+1, 3);
    excel_data{1,1} = 'Label ID';
    excel_data{1,2} = 'Pixel Area';
    excel_data{1,3} = 'Average Intensity';

    counter = 2;
    for val = 1 :255
        pixel_count = hist_data(val+1);
        if pixel_count ~= 0
            excel_data{counter, 1} = counter-1;
            mask = uint8(zeros(size(label_image)));
            mask(label_image == val) = 1;
            pixel_area = sum(mask(:));
            avg_intensity = sum(sum(mask.*main_image))/pixel_count;
            excel_data{counter, 2} = pixel_area;
            excel_data{counter, 3} = avg_intensity;
            counter = counter + 1;
        end
    end

    xlswrite(file_path, excel_data);

end