function PSNR = MY_PSNR(I, J)
    max_possible_lighting = 1;
    PSNR = 10 * log10((double(max_possible_lighting) ^ 2) / MY_MSE(I,J));
end