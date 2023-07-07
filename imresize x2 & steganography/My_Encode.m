function stego_img = My_Encode(cover_img, secret_msg)
    R=secret_msg(:,:,1);
    G=secret_msg(:,:,2);
    B=secret_msg(:,:,3);
    
    %make every reprezendted uint az a 8 bit in new matrix
    
    
    %define flatten matrix as the size of cover_img
    matrix=zeros(1,size(cover_img,1)*size(cover_img,2)*8);
    
    k=0;
    for i = 1:size(R,1)
        for j=1:size(R,2)
            for l=1:8
                matrix(k+l)=bitget(R(i,j),l);
            end
            k=k+8;
        end
    end
    
    for i = 1:size(G,1)
        for j=1:size(G,2)
            for l=1:8
                matrix(k+l)=bitget(G(i,j),l);
            end
            k=k+8;
        end
    end
    
    for i = 1:size(B,1)
        for j=1:size(B,2)
            for l=1:8
                matrix(k+l)=bitget(B(i,j),l);
            end
            k=k+8;
        end
    end
    
    random_pattern=(round(rand(size(cover_img)))==1);
    
    %reshape matrix as the size of cover_img
    matrix=reshape(matrix(1:size(cover_img,1)*size(cover_img,2)),[size(cover_img,1),size(cover_img,2)]);
    
    randomized_secret_msg=xor(matrix,random_pattern);
    
    stego_img=bitset(cover_img,1,randomized_secret_msg);

    %show every bit plane of stego image
    figure;
    for i=1:8
        subplot(2,4,i);
        imshow(bitget(stego_img,i),[]);
        %add title to every subplot
        title(['bit plane ',num2str(i)]);
    end
end