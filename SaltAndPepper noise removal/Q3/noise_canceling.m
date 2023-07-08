function [output_image,kernel_avg] = noise_canceling(input_image,org_kernel_size)
    
    output_image = input_image;
    kernel_size=org_kernel_size;
    kernel_avg=org_kernel_size;
    kernel_avg_i=1;
while true   

    pad_size = floor(kernel_size/2);
    pad_image = padarray(input_image, [pad_size, pad_size], 'symmetric', "both");
    h = size(pad_image, 1);
    w = size(pad_image, 2);
    flag=0;
    %print kernel size
    fprintf('kernel size: %d\n',kernel_size);
    for i=1 : h-kernel_size+1
        for j=1 : w-kernel_size+1
            % select pixels under the kernel
            u_kernel = pad_image(i:i+kernel_size-1, j:j+kernel_size-1);
            % remove 0 and 255 pixels from region under the kernel and keep the indexes for the rest of them
            
            selected_elements = u_kernel(u_kernel~=0 & u_kernel~=255);
            %reshape the selected elements with kernel_size*kernel_size
            % mean of non valid pixels
            if (isempty(selected_elements))
                %choose higher kernel size
                kernel_size=kernel_size+2;
                flag=1;
                break;
            else
                %kernel_size=org_kernel_size;
               final_element=median(selected_elements);
%                h=fspecial('gaussian',[kernel_size kernel_size],kernel_size/6);
%                final_element=imfilter(u_kernel,h);
            end
            %output_image(i:i+kernel_size-1, j:j+kernel_size-1)=final_element;
            output_image(i,j)=final_element;
        end
        if(flag==1)
            kernel_avg_i=kernel_avg_i+1;
            kernel_avg(kernel_avg_i)=kernel_size;
            break;
        end
    end

    %calculate number of 0s and 255s of output image
    num_0 = sum(sum(output_image==0));
    num_255 = sum(sum(output_image==255));
    

    if(num_0==0 && num_255==0)
        break;
    end
end

%mean of kernel sizes
kernel_avg=mean(kernel_avg);

end