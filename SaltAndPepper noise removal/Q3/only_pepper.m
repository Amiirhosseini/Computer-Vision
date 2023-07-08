function Output_Image = only_pepper(I,n)

    noise=n*100;
    %itterate through the image with 100x1 vectors
    for i=1:size(I,1)
        for j=1:size(I,2)
            %get n random numbers between 1 and 100
            random_pixels = randi([1 100],1,noise);
    
            %itterate through the random numbers
            for k=1:noise
                if random_pixels(k) == 1
                    I(i,j) = 0;
                end
            end
    
        end
    
    end
    %return the image
    Output_Image = I;
    end