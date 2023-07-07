function secret_msg = My_Decode(stego_img)
random_pattern=(round(rand(size(stego_img))));

first_plane=(bitget(stego_img,1)==1);

first_plane = xor(first_plane,random_pattern);

%make first plane flatten
first_plane=reshape(first_plane,[1,size(stego_img,1)*size(stego_img,2)]);

R=zeros(274,418);
G=zeros(274,418);
B=zeros(274,418);

k=0;
%extract R G B from stego_img
for i=1:size(R,1)
    for j=1:size(R,2)
        for l=1:8
            R(i,j)=bitset(R(i,j),l,first_plane(k+l));
        end
        k=k+8;
    end
end

for i=1:size(G,1)
    for j=1:size(G,2)
        for l=1:8
            G(i,j)=bitset(G(i,j),l,first_plane(k+l));
        end
        k=k+8;
    end
end

for i=1:size(B,1)
    for j=1:size(B,2)
        for l=1:8
            B(i,j)=bitset(B(i,j),l,first_plane(k+l));
        end
        k=k+8;
    end
end


secret_msg=cat(3,R,G,B);
secret_msg=uint8(secret_msg);
end