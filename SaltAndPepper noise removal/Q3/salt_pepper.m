function Output_Image = salt_pepper(I,n)

noise=n*100;
noise=int8(noise);
%itterate through the image with 100x1 vectors
for i=1:size(I,1)
    for j=1:size(I,2)
        %get n random numbers between 1 and 100
        random_pixels = randi([1 100],1,noise);

        %itterate through the random numbers
        for k=1:noise
            %if the random number is 1, set the pixel to 0 or 255
            if random_pixels(k) == 1
                %get a random number only 0 or 1
                fair_coin = randi([0 1]);
                %if the random number is 0, set the pixel to 0
                if fair_coin == 0
                    I(i,j) = 0;
                %if the random number is 1, set the pixel to 255
                else
                    I(i,j) = 255;
                end
            end
        end

    end

end
%return the image
Output_Image = I;
end