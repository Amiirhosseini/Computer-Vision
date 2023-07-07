function new_BW_pic = best_BW_PSNR(I)
new_BW_pic=zeros(size(I,1),size(I,2));
for i=1:size(I,1)
    for j=1:size(I,2)
        if I(i,j)>=0.5
            new_BW_pic(i,j)=1;
        
         else
        new_BW_pic(i,j)=0;
        end
    end
end
    
end