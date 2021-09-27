function [image_ii_norm,image_ii] =integral_image()
% the function takes the array of the normal image >> image 
% return the integral image >> image_ii
image=imread('cameraman_noise.tif');
image=double(image);   %increasing the range of the image from unit8 to double size to allow the calculation of integral image
image_ii=zeros(size(image,1),size(image,2)); %intializing the array of the integral image 
cumulative_sum=zeros(size(image,1),size(image,2)); %initializing the cumlative sum array 

%calculatin the cumulative row sum 
cumulative_sum(:,1)=image(:,1);
cumulative_sum(1,:)=image(1,:);
double(cumulative_sum);
double(image_ii);
for i=1:size(image,1)
    for j=2:size(image,2)
        cumulative_sum(i,j)=cumulative_sum(i,j-1)+image(i,j);
    end
end

%calculating the integral image for a given image 
image_ii(1,:)=cumulative_sum(1,:);
for j=1:size(image,2)
    for i=2:size(image,1)
        image_ii(i,j)=image_ii(i-1,j)+cumulative_sum(i,j);
    end
end

%normalizing the integral image to a range from 0 to 255 

image_ii_norm=zeros(size(image,1),size(image,2));  %intailizing the image_ii_norm array
%getting the normalized integrated image
for i=1:size(image,1)                               
    for j=1:size(image,2)
image_ii_norm(i,j) =(image_ii(i,j)/max(image_ii(:)))*255;
    end
end

%displaying the integral_image 
image_ii_norm(:)=round(image_ii_norm(:)); % getting the integer values of the normalized values to display the image 
image_ii_norm=uint8(image_ii_norm);       % making the values of class uint8  
imwrite(image_ii_norm,'camera_Integ.jpg')

        
    


