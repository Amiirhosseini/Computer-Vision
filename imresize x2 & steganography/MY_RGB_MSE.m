function MSE = MY_RGB_MSE(I, J)
    MSE = mean(mean((I - J).^2, 1), 2);
end