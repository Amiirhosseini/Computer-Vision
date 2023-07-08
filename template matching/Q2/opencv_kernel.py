import cv2
import numpy as np  
import os

#get current directory
directory=os.getcwd()

#open folder in current directory
directory=  directory +  "\Q2\\Dataset\\kernels_org_opencv2\\"

#for all digits form 0 to 9 and with 45 and -45 degree rotation
for i in range(0,10):
    #create a 46*46 blank image, white background with digit i in center of image
    blank_image = np.zeros((46*2,46*2,3), np.uint8)
    blank_image[:,:] = (255,255,255)
    cv2.putText(blank_image,str(i),(13*2,32*2), cv2.FONT_HERSHEY_TRIPLEX, 2,(0,0,0),4)
    #save the image
    cv2.imwrite(directory+str(i)+".bmp",blank_image)
    
print(directory)
# #show the images
# cv2.imshow("9",blank_image)

# #wait for key press
# cv2.waitKey(0)

# #close all windows
# cv2.destroyAllWindows()


