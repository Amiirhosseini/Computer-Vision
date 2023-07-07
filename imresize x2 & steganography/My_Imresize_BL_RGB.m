function Output_Image = My_Imresize_BL_RGB(Input_Image, Resizing_Factor)

R=Input_Image(:,:,1);
G=Input_Image(:,:,2);
B=Input_Image(:,:,3);

R=My_Imresize_BL(R,Resizing_Factor);
G=My_Imresize_BL(G,Resizing_Factor);
B=My_Imresize_BL(B,Resizing_Factor);

Output_Image=cat(3,R,G,B);

end