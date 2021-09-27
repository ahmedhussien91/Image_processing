# Problem 1
 a) Implement the integral image algorithm that can obtain the integral image for any gray-scale image. Apply your 
function to the image “Cameraman_noise.tif”. Your function should take the image as an input and should output the 
integral image.
Deliverables:
 Your code
 The integral image obtained for the “Cameraman_noise.tif” image. Name the file “Camera_Integ.jpg”
b) Implement an average filter for noise removal that uses the function you wrote in (a). Apply your function to the 
image “Cameraman_noise.tif”. Your function should take the image as an input in addition to the size of the filter (s x 
s). The function should output the filtered image. 
Deliverables:
 Your code
 The filtered image obtained for a filter size of 3 x 3. Name the file “Camera_Filt_3.jpg”
 The filtered image obtained for a filter size of 5 x 5. Name the file “Camera_Filt_5.jpg”
c) What is the advantage of using the intergal image for average filtering compared to traditional convolution 
implementation of average filtering
# Problem 2 
Implement a function to rotate an image around its center by an angle θ (Positive values of θ indicate counter clockwise direction). Your function should take the image and the angle θ as inputs. The function should output the 
rotated image. Use linear interpolation. Apply your function to the “cameraman.tif” image.
Deliverables: 
 Your code
 The rotated images with (a) θ = 40°, (b) θ = 70°. Name the files “Cameraman_40R.jpg” and 
“Cameraman_70R.jpg”
Note: You can use any programming language for implementation. However, it might be easier to use MATLAB since there are 
many functions that are already implemented that you can use directly. You are required though to write your own version of the 
histogram equalization and rotation algorithms (Do not use the already implemented imfilter or imrotate functions of 
MATLAB).