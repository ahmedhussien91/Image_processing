function[filtered_image,integral_image1] = avg_filter(image,filter_size)
%implementing the filter 
image=double(image);
filtered_image = zeros(size(image,1),size(image,2)); % initializing the filtered image array for preallocation 
integral_image1 = integral_image(image);             %creating the integral image of the input image
%filtering the image by  getting the averag by using the integral image  
for i=1:size(image,1)-filter_size(1)
    for j=1:size(image,2)-filter_size(2)
        filtered_image(i+floor(filter_size(1)/2),j+floor(filter_size(2)/2)) = (1/(filter_size(1)*filter_size(2)))*(integral_image1(i+filter_size(1),j+filter_size(2))+integral_image1(i,j)-integral_image1(i+filter_size(1),j)-integral_image1(i,j+filter_size(2)));
    end
end

%displaying the filtered_image
filtered_image(:)=round(filtered_image(:)); % getting the integer values to display the image 
filtered_image=uint8(filtered_image);       % making the values of class uint8  
imwrite(filtered_image,'camera_filt_5.jpg')