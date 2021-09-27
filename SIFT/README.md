# Question 1
 Implement the Scale Invariant Feature Transform (SIFT) algorithm to find the blobs in the image “Fish.jpg”. 
Your function should take the image as an input, the maximum value of sigma (MaxS) to examine and the 
threshold explained in slide 27. You should examine values of sigma in the range [1, MaxS] with a step of 1. 
The function should output the image with the circles representing the identified blobs overlaid as shown in 
the lecture slides.
Deliverables:
 Your code
 The images resulting from convolution with the Laplacian of Gaussian (LoG) mask with sigma = 1 
and sigma = 5. Name the files “Fish_S1.jpg” and “Fish_S5.jpg”, resepctively
 The output image with no threshold where MaxS = 20. Name the file “Fish_0.jpg”
 The output image with threshold = 0.01 where MaxS = 20. Name the file “Fish_01.jpg”
 The output image with threshold = 0.05 where MaxS = 20. Name the file “Fish_05.jpg”

# Question 2 
Implement a function that uses the SIFT algorithm to stitch two gray-scale images. In your implementation, 
use the function you implemented in Problem 1. You should apply your function to the images 
“Louvre1.jpg” and “Louvre2.jpg”. The function should take the 2 images as inputs and it should output the 
stitched image. You can use the Prewitt operator for gradient orientation computation.
Deliverables:
 Your code.
 The stitched image. Name the file “Louvre_All.jpg”.
Note:
When implementing the orientation assignment step, you can use the function ‘edge’ in MATLAB that 
obtains the gradient magnitude and direction.