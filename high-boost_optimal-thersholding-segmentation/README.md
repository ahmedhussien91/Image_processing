# Question 1 
Implement a function that applies a high-boost filter to an input gray-scale image. Your filter should use the 
butterworth high-pass filter. The function should take as inputs the input image, the order of the filter, the 
cutoff distance of the high-pass filter D0 and the constant A. It should output the filtered image. Apply the 
filter to the image “Moon.jpg”.
Deliverables: 
 Your code.
 The output image obtained using 1st order butterworth filter with D0 = 50 and A = 1.5. Name the 
output image “MoonHB_1.jpg”.
 The output image obtained using 1st order butterworth filter with D0 = 50 and A = 2. Name the 
output image “MoonHB_2.jpg”.
 The output image obtained using 2
nd order butterworth filter with D0 = 50 and A = 2. Name the 
output image “MoonHB_3.jpg”.

# Question 2 
Implement a function that implements the optimal thresholding segmentation method. Your function 
should take a gray-scale image as an input and outputs the computed threshold and the image after 
segmentation. Apply your function to the image “Water.jpg”.
Deliverables: 
 Your code.
 A text file showing the value of computed threshold. Name the file “Threshold.txt”.
 The output image that shows the segmented image (two regions). Name the image 
“Water_Seg.jpg”.
Note: You can use any programming language for implementation. However, it might be easier to use MATLAB 
since there are many functions that are already implemented that you can use directly, but you are required to write 
your own version of the required filters. You are allowed to use MATLAB functions that compute the 2D Fourier 
transform.