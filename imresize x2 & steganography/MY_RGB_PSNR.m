function PSNR = MY_RGB_PSNR(I, J)
    max_possible_lighting = 1;
    PSNR = 10 * log10((double(max_possible_lighting) ^ 2) / mean(MY_RGB_MSE(I,J),3));
end