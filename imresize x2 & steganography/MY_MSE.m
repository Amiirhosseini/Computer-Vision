function MSE = MY_MSE(I, J)
    MSE = sum(sum((I-J).^2))/(numel(I));
end