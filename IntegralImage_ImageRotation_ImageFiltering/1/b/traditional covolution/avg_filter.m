function[filtered_image] = avg_filter(image,filter_size)
%implementing the filter
h=ones(filter_size(1),filter_size(2));
h=double(h);   %changing the class 
image=double(image);
filtered_image = (1/(size(h,1)*size(h,2))).*conv2(image,h,'same');


%displaying the filtered_image
filtered_image(:)=round(filtered_image(:)); % getting the integer values of the normalized values to display the image 
filtered_image=uint8(filtered_image);       % making the values of class uint8  
imwrite(filtered_image,'camera_filt_3.jpg')