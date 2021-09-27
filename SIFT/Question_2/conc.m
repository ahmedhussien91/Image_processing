function [stitched_image] = conc( shift_final, image1, image2)

% this function concatenate the two image using the shift_final output from
% the stitch2 function 
Y = size(image2,2);
X = size(image1,1);
cons = shift_final(1,2);


% removing the coloums that is repeated in image2
for k = 1:size(image2,2)
   if (k > cons)
       image2(:,Y+1-k) =[];
   end
end

% adding rows to the tob of image2 and to the bottom of image1 to equalize the diffrence(the shift) between the two images  

image2 = padarray(image2,[shift_final(1,1) 0],'pre');

image1 = padarray(image1,[shift_final(1,1) 0],'post');



stitched_image = cat(2,image1,image2);
imshow(stitched_image(:,:))
