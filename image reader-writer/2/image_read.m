%read generic size of pgm image from defrent files
function I = image_read(input)
f= fopen(input);
file_content=fread(f,'uint8');
fclose(f);

image_type=file_content(2);


start=0;
row_size='';
column_size='';
flag=0;

for g=4:255
    x=file_content(g);
    row_size=append(row_size,native2unicode(x,"UTF-8"));
    if x==32
        for h=g+1:255
            x=file_content(h);
    
            if x==10 ||x==32
                start=g+9;
                flag=1;
                break;
            end
            
            column_size=append(column_size,native2unicode(x,"UTF-8"));
     
        end
    end
    if flag==1
        break;
    end
end
row_size=str2double(row_size);
column_size=str2double(column_size);
image_data=file_content(start:end);

%pgm case
if image_type==53
    I=zeros(column_size,row_size);
    
    k=1;
    for i=1:column_size
        for j=1:row_size
            I(i,j)=image_data(k);
            k=k+1;
        end
    end
end

%ppm case
if image_type==54

%I=zeros(column_size,row_size,3);
R=zeros(column_size,row_size,1);
G=zeros(column_size,row_size,1);
B=zeros(column_size,row_size,1);

k=1;
for i=1:column_size
    for j=1:row_size
            R(i,j)=image_data(k);
            G(i,j)=image_data(k+1);
            B(i,j)=image_data(k+2);
            k=k+3;
    end
end

I=cat(3,R,G,B);
I=uint8(I);

end

end