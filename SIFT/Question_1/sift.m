%matlap intialization 

% image=imread('Fish.jpg');
% MAXS=20;
% threshold=0;


function [output_image,conv_image_1sig,conv_image_5sig,keypoints]=sift(image,MAXS,threshold)

%enforcing the image to double + preallocation if array of images
image=double(image);                    
image_log =zeros(size(image,1),size(image,2),MAXS);

%This for loop get the LoG of images with MAXS different Sigmas but with 0 padding
for SIG = 1:1:MAXS
    H = ((ceil(SIG*3)*2)+1);                    %determining the size of the LOG filter 
%convoluting the image with LOG filter of size HxH
   TEMP= conv2(image,fspecial('log',[H H],SIG));  
%putting each o/p image in the array of images image_log
   for i=1:1:size(image,1)                       
       for j=1:1:size(image,2)
   image_log (i,j,SIG) = TEMP(i+floor(H/2),j+floor(H/2)) * (SIG^2);  % getting an array of normalized images
       end 
   end
end

% getting an array of squared normalized images of diffrent sigmas

image_log_squared = image_log .^2;

%applying the threshold

Max_log_value=max(image_log_squared(:));         % maximum value of log squared in the two images 

for SIG = 1:1:MAXS
    for i = 1:1:size(image,1)
        for j = 1:1:size(image,2)
            if (image_log_squared(i,j,SIG) <= threshold*Max_log_value)
                image_log_squared(i,j,SIG)=0;
            end
        end
    end
end


%finding the key points 
%finding the maxima of the squared LoG response in the scale space

keypoints=zeros(1512,3);  %this variable will carry the position of the keypoint in the array along with the its sigma
                          %[i j SIG] will be identifyed for each keypoint
array3=zeros(3,3,3);
keypoints_count=1;

for SIG = 2:1:MAXS-1
    for i = 2:1:size(image,1)-1
       for j = 2:1:size(image,2)-1
           %putting the neighbours in an arragy to get them compared with
           %the middle point
            array3(:,:,1)= [ image_log_squared(i-1,j-1,SIG-1) image_log_squared(i-1,j,SIG-1) image_log_squared(i-1,j+1,SIG-1);
                             image_log_squared(i,j-1,SIG-1) image_log_squared(i,j,SIG-1) image_log_squared(i,j+1,SIG-1);
                             image_log_squared(i+1,j-1,SIG-1) image_log_squared(i+1,j,SIG-1) image_log_squared(i+1,j+1,SIG-1)];
            array3(:,:,2)= [ image_log_squared(i-1,j-1,SIG) image_log_squared(i-1,j,SIG) image_log_squared(i-1,j+1,SIG);
                             image_log_squared(i,j-1,SIG) image_log_squared(i,j,SIG) image_log_squared(i,j+1,SIG);
                             image_log_squared(i+1,j-1,SIG) image_log_squared(i+1,j,SIG) image_log_squared(i+1,j+1,SIG)];
            array3(:,:,3)= [ image_log_squared(i-1,j-1,SIG+1) image_log_squared(i-1,j,SIG+1) image_log_squared(i-1,j+1,SIG+1);
                             image_log_squared(i,j-1,SIG+1) image_log_squared(i,j,SIG+1) image_log_squared(i,j+1,SIG+1);
                             image_log_squared(i+1,j-1,SIG+1) image_log_squared(i+1,j,SIG+1) image_log_squared(i+1,j+1,SIG+1)];
           for z = 1:1:3
               for x = 1:1:3
                   for y = 1:1:3
                       if ( image_log_squared(i,j,SIG) >= array3(x,y,z) && image_log_squared(i,j,SIG) ~= 0 )
                          if(x==3 && y==3 && z==3)
                              keypoints(keypoints_count,:)=[j i sqrt(2)*SIG];          % if the x,y is larger than the all the points  put it in the keypoints array
                              keypoints_count = keypoints_count+1;             % increment the array count (index)   
                          end
                       else
                           break;                           %break if the there is an element greater than middle element
                       end
                   end
                   if ( (image_log_squared(i,j,SIG) < array3(x,y,z)) || image_log_squared(i,j,SIG) == 0  )
                       break;                               %continue the breaking out of the loop if an element is greater than the middle element
                   end
               end
               if ( (image_log_squared(i,j,SIG) < array3(x,y,z)) || image_log_squared(i,j,SIG) == 0  )
                   break;                                   %continue the breaking out of the loop if an element is greater than the middle element
               end
           end
       end
    end
end                                                         

%circle the keypoints blobs with the right raduis
yellow = uint8([255 255 0]); % [R G B]; class of yellow must match class of I
shapeInserter = vision.ShapeInserter('Shape','Circles','BorderColor','Custom','CustomBorderColor',yellow);
circles = int32(keypoints);         %identifying the keypoints blobs 
RGB = repmat(uint8(image),[1,1,3]); % converting the image into RGB image 
output_image=step(shapeInserter, RGB, circles); %Draw the circles and display the result



conv_image_1sig=image_log(:,:,1);
conv_image_5sig=image_log(:,:,5);

