% input for the function will be here the two keypoints and the two images
% keypoints will be got by the sift function 
% output will be the stitched_image  
function [shift_final,PF] = stitch2(keypoints1, keypoints2,image1,image2)

% inserting zeros at the end of the keypoints to know where to stop 
keypoints1(size(keypoints1,1)+1,:) = [0 0 0];
keypoints2(size(keypoints2,1)+1,:) = [0 0 0];

keypoints1(:,size(keypoints1,2)+1)= zeros(size(keypoints1,1),1);
keypoints2(:,size(keypoints2,2)+1)= zeros(size(keypoints2,1),1);

% changing the image into double in order to be able to do operations on it
% freely 
image1=double(image1);


% putting the image in a bigger array for the convolution result and to be
% of equal size for logical indexing

image_inc8 = zeros(size(image1,1)+16,size(image1,2)+16);
for i = 1:1:size(image1,1)
    for j = 1:1:size(image1,2)
        image_inc8(i+8,j+8) = image1(i,j);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MAXS= 20;
% applying gaussian filter on the image with each of 20 SIG 
image_conv =zeros(size(image1,1),size(image1,2),MAXS);
for SIG = 2:1:MAXS
% convoluting the image with Gaussian filter of size HxH
    H = ((ceil(SIG*3)*2)+1);  % size of Gaussian filter 
   TEMP= conv2(image1,gaussian2d(H,SIG));  
% putting each o/p image in the array of images image_log
   for i=1:1:size(image1,1)                       
       for j=1:1:size(image1,2)
   image_conv (i,j,SIG) = TEMP(i+floor(H/2),j+floor(H/2)) ;  % getting an array of normalized images
       end 
   end
end

% conveluting the image with perwit operator tho get the ceta (angle)
image_prewitx =zeros(size(image1,1),size(image1,2),MAXS);
image_prewity =zeros(size(image1,1),size(image1,2),MAXS);
for SIG = 2:1:MAXS
% convoluting the image with 2D prewit operator
 Gy = conv2(image_conv(:,:,SIG),fspecial('prewitt'));
 Gx = conv2(image_conv(:,:,SIG),fspecial('prewitt')');
 
% putting each o/p image in the array of images image_prewit
   for i=1:1:size(image1,1)                       
       for j=1:1:size(image1,2)
   image_prewity (i,j,SIG) = Gy(i+2,j+2) ;  % getting an array of y edges
   image_prewitx (i,j,SIG) = Gx(i+2,j+2) ;  % getting an array of x edges
       end 
   end
end

% getting the angle of all the pixels in diffrent sigmas
image_angle = zeros(size(image1,1),size(image1,2),MAXS);
temp = zeros(size(image1,1),size(image1,2),MAXS);
for SIG = 2:1:MAXS
    for i = 1:1:size(image1,1)
        for j = 1:1:size(image1,2)
     temp(i,j) = atan2(image_prewity(i,j,SIG),image_prewitx(i,j,SIG))+pi;
    % quantizaing the angles into 8 levels
    if (temp(i,j) <= pi/4)
        image_angle(i,j,SIG)=0;
    elseif (temp(i,j) <= 2*pi/4)
        image_angle(i,j,SIG)= pi/4;
    elseif (temp(i,j) <= 3*pi/4)
        image_angle(i,j,SIG)= 2*pi/4;
    elseif (temp(i,j) <= 4*pi/4)
        image_angle(i,j,SIG)= 3*pi/4;
    elseif (temp(i,j) <= 5*pi/4)
        image_angle(i,j,SIG)= 4*pi/4;
    elseif (temp(i,j) <= 6*pi/4)
        image_angle(i,j,SIG)= 5*pi/4;
    elseif (temp(i,j) <= 7*pi/4)
        image_angle(i,j,SIG)= 6*pi/4;
    elseif (temp(i,j) <= 8*pi/4)
        image_angle(i,j,SIG)= 7*pi/4;
    end
        end
    end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% discriptor generation]
row_count = 1;                % row_count for the keypoints
row_count1 = 1;               % row_count for the discriptor
temp_arr = zeros(16);         % the array that will carry the 16x16 neigbourhood preallocation
discriptor = zeros(size(keypoints1,1),128); % the discriptor preallocation
dis_count = 0;                % counter to put each discriptor of 4x4 into the 128 discriptor array
% histogram counter initialized to 0 
pi_0 = 0;
pi_1 = 0;
pi_2 = 0;
pi_3 = 0;
pi_4 = 0;
pi_5 = 0;
pi_6 = 0;
pi_7 = 0;
% getting the sigmas out of the keypoints into a single array to use in
% indexing without losing its real value
SIG = zeros(size(keypoints1,1),1);
SIG(:,1) = uint8( keypoints1(:,3)./sqrt(2));
      
% size of image 
size_8_2 = size(image_angle,1)-8;
size_8_1 = size(image_angle,2)-8;


while( keypoints1(row_count,1)~=0 && keypoints1(row_count,2)~=0 && SIG(row_count,1)~=0 )
    
    
     % bypass the keypoints that will not have 16x16 neighbourhood 
    if ( ( ( keypoints1(row_count,1) ) > 8 ) && ( keypoints1(row_count,1) < size_8_1  ) ) 
           if ( ( ( keypoints1(row_count,2) ) > 8 ) && ( keypoints1(row_count,2) < size_8_2 ) )
            
            % for each keypoint get the 16x16 neighbourhood around it and put in a
            % temorary variable
            for x = -7:1:8
                for y = -7:1:8
                    temp_arr(x+8,y+8) = image_angle( (x+keypoints1(row_count,2)) , (y+keypoints1(row_count,1)) ,SIG(row_count,1)); % temp will carry a temrory value of the 16x16 neighbourhood                         
                end
            end

            % getting the histogram of each 4x4 in the 16x16 neigboorhood 

            for x = 0 : 4 :12
                for y = 0 : 4 :12
                   % getting the discriptor of the each 4x4 neighboorhood 
                    for i = 1:1:4
                        for j = 1:1:4
                            switch temp_arr(i+x,j+y)
                                case 0
                                    pi_0 = pi_0 + 1;

                                case pi/4
                                    pi_1 = pi_1 + 1;

                                case 2*pi/4
                                    pi_2 = pi_2 + 1;

                                case 3*pi/4
                                    pi_3 = pi_3 + 1;

                                case 4*pi/4
                                    pi_4 = pi_4 + 1;

                                case 5*pi/4
                                    pi_5 = pi_5 + 1;

                                case 6*pi/4
                                    pi_6 = pi_6 + 1;

                                otherwise
                                    pi_7 = pi_7 + 1;

                            end 
                        end
                    end
                    % putting the genrated histogram of 4x4 neigboorhood into an array 
                    hist_angles = [ pi_0 pi_1 pi_2 pi_3 pi_4 pi_5 pi_6 pi_7 ];
                    % putting this array in the discriptor
                    for k = 1:1:8
                    discriptor( row_count1, k+dis_count ) = hist_angles(1,k) ;
                    end
                    % increment the offset for the next iteration 
                    dis_count = dis_count + 8;
                    % histogram counter reinitialized to 0 for next iteration 
                    pi_0 = 0;
                    pi_1 = 0;
                    pi_2 = 0;
                    pi_3 = 0;
                    pi_4 = 0;
                    pi_5 = 0;
                    pi_6 = 0;
                    pi_7 = 0;
                end
            end
            keypoints1(row_count,4)=row_count1;
            row_count1 = row_count1 + 1;
       end
    end
    dis_count = 0;                 % reset the dis_count
    row_count = row_count + 1;     % increment the row_count

end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getting the discriptor of image2 the same as we did for image1 but for
% keypoints2

% changing the image into double in order to be able to do operations on it
% freely 
image2=double(image2);


% putting the image in a bigger array for the convolution result and to be
% of equal size for logical indexing

image_inc8 = zeros(size(image2,1)+16,size(image2,2)+16);
for i = 1:1:size(image2,1)
    for j = 1:1:size(image2,2)
        image_inc8(i+8,j+8) = image2(i,j);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MAXS= 20;
% applying gaussian filter on the image with each of 20 SIG 
image_conv =zeros(size(image2,1),size(image2,2),MAXS);
for SIG = 2:1:MAXS
% convoluting the image with Gaussian filter of size HxH
    H = ((ceil(SIG*3)*2)+1);  % size of Gaussian filter 
   TEMP= conv2(image2,gaussian2d(H,SIG));  
% putting each o/p image in the array of images image_log
   for i=1:1:size(image2,1)                       
       for j=1:1:size(image2,2)
   image_conv (i,j,SIG) = TEMP(i+floor(H/2),j+floor(H/2)) ;  % getting an array of normalized images
       end 
   end
end

% conveluting the image with perwit operator tho get the ceta (angle)
image_prewitx =zeros(size(image2,1),size(image2,2),MAXS);
image_prewity =zeros(size(image2,1),size(image2,2),MAXS);
for SIG = 2:1:MAXS
% convoluting the image with 2D prewit operator
 Gy = conv2(image_conv(:,:,SIG),fspecial('prewitt'));
 Gx = conv2(image_conv(:,:,SIG),fspecial('prewitt')');
 
% putting each o/p image in the array of images image_prewit
   for i=1:1:size(image2,1)                       
       for j=1:1:size(image2,2)
   image_prewity (i,j,SIG) = Gy(i+2,j+2) ;  % getting an array of y edges
   image_prewitx (i,j,SIG) = Gx(i+2,j+2) ;  % getting an array of x edges
       end 
   end
end

% getting the angle of all the pixels in diffrent sigmas
image_angle = zeros(size(image2,1),size(image2,2),MAXS);
temp = zeros(size(image2,1),size(image2,2),MAXS);
for SIG = 2:1:MAXS
    for i = 1:1:size(image2,1)
        for j = 1:1:size(image2,2)
     temp(i,j) = atan2(image_prewity(i,j,SIG),image_prewitx(i,j,SIG))+pi;
    % quantizaing the angles into 8 levels
    if (temp(i,j) <= pi/4)
        image_angle(i,j,SIG)=0;
    elseif (temp(i,j) <= 2*pi/4)
        image_angle(i,j,SIG)= pi/4;
    elseif (temp(i,j) <= 3*pi/4)
        image_angle(i,j,SIG)= 2*pi/4;
    elseif (temp(i,j) <= 4*pi/4)
        image_angle(i,j,SIG)= 3*pi/4;
    elseif (temp(i,j) <= 5*pi/4)
        image_angle(i,j,SIG)= 4*pi/4;
    elseif (temp(i,j) <= 6*pi/4)
        image_angle(i,j,SIG)= 5*pi/4;
    elseif (temp(i,j) <= 7*pi/4)
        image_angle(i,j,SIG)= 6*pi/4;
    elseif (temp(i,j) <= 8*pi/4)
        image_angle(i,j,SIG)= 7*pi/4;
    end
        end
    end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% discriptor generation]
row_count = 1;                % row_count for the keypoints
row_count1 = 1;               % row_count for the discriptor
temp_arr = zeros(16);         % the array that will carry the 16x16 neigbourhood preallocation
discriptor2 = zeros(size(keypoints2,1),128); % the discriptor preallocation
dis_count = 0;                % counter to put each discriptor of 4x4 into the 128 discriptor array
% histogram counter initialized to 0 
pi_0 = 0;
pi_1 = 0;
pi_2 = 0;
pi_3 = 0;
pi_4 = 0;
pi_5 = 0;
pi_6 = 0;
pi_7 = 0;
% getting the sigmas out of the keypoints into a single array to use in
% indexing without losing its real value
SIG = zeros(size(keypoints2,1),1);
SIG(:,1) = uint8( keypoints2(:,3)./sqrt(2));
% enforcing the keypoints into uint8 to use in indexing 
        

while( keypoints2(row_count,1)~=0 && keypoints2(row_count,2)~=0 && SIG(row_count,1)~=0 )
    
    
     % bypass the keypoints that will not have 16x16 neighbourhood 
     if ( ( ( keypoints2(row_count,1) ) > 8 ) && ( keypoints2(row_count,1) < size_8_1  ) ) 
        if ( ( ( keypoints2(row_count,2) ) > 8 ) && ( keypoints2(row_count,2) < size_8_2 ) )
            
            % for each keypoint get the 16x16 neighbourhood around it and put in a
            % temorary variable
            for x = -7:1:8
                for y = -7:1:8
                    temp_arr(x+8,y+8) = image_angle( (x+keypoints2(row_count,2)) , (y+keypoints2(row_count,1)) ,SIG(row_count,1)); % temp will carry a temrory value of the 16x16 neighbourhood                         
                end
            end

            % getting the histogram of each 4x4 in the 16x16 neigboorhood 

            for x = 0 : 4 :12
                for y = 0 : 4 :12
                   % getting the discriptor of the each 4x4 neighboorhood 
                    for i = 1:1:4
                        for j = 1:1:4
                            switch temp_arr(i+x,j+y)
                                case 0
                                    pi_0 = pi_0 + 1;

                                case pi/4
                                    pi_1 = pi_1 + 1;

                                case 2*pi/4
                                    pi_2 = pi_2 + 1;

                                case 3*pi/4
                                    pi_3 = pi_3 + 1;

                                case 4*pi/4
                                    pi_4 = pi_4 + 1;

                                case 5*pi/4
                                    pi_5 = pi_5 + 1;

                                case 6*pi/4
                                    pi_6 = pi_6 + 1;

                                otherwise
                                    pi_7 = pi_7 + 1;

                            end 
                        end
                    end
                    % putting the genrated histogram of 4x4 neigboorhood into an array 
                    hist_angles = [ pi_0 pi_1 pi_2 pi_3 pi_4 pi_5 pi_6 pi_7 ];
                    % putting this array in the discriptor
                    for k = 1:1:8
                    discriptor2( row_count1, k+dis_count ) = hist_angles(1,k) ;
                    end
                    % increment the offset for the next iteration 
                    dis_count = dis_count + 8;
                    % histogram counter reinitialized to 0 for next iteration 
                    pi_0 = 0;
                    pi_1 = 0;
                    pi_2 = 0;
                    pi_3 = 0;
                    pi_4 = 0;
                    pi_5 = 0;
                    pi_6 = 0;
                    pi_7 = 0;
                end
            end
            keypoints2(row_count,4)=row_count1;
            row_count1 = row_count1 + 1;

        end
    end
    dis_count = 0;                 % reset the dis_count
    row_count = row_count + 1;     % increment the row_count

end
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% next we compare the two keypoints and find the Euclidean distance to
% stitch the two images

% comparing the two discriptors and finding the discriptors that matches
row_count=1;
row_count1=1;
row_count2=1;
euclidean = zeros ( 1,128);
euc = zeros(size(keypoints1,1),size(keypoints2,1));

% finding the eculidean distances between all the discriptors 
while( sum(discriptor(row_count1,:),2) ~= 0 )
    while( sum(discriptor2(row_count2,:),2) ~= 0 )
          for k = 1:128
            euclidean(1,k) = (discriptor(row_count1,k).^2) - (discriptor2(row_count2,k).^2) ;
          end
             euc(row_count1, row_count2) = sqrt(sum(abs(euclidean(1,:)),2));  
             row_count2 = row_count2 + 1; 
    end
    row_count = row_count2 ;
    row_count2 = 1;
    row_count1 = row_count1 + 1;
end
   

% finding the position of the matched discriptors  
count=1;
position_descrip = zeros (10,2); % will output the position of the two matched discriptors 
for i = 1:1:row_count1-1
    for j = 1:1:row_count-1
        if( euc(i,j) < 10)
            position_descrip(count,: ) = [ i j ];
            count= count + 1;
        end
    end
end


% finding the position of matched keypoints in the frist image
% Note: the row count of the discriptor is diffrent from the keypoints as we
%       bypassed the key points that have no 16x16 neighbourhood
row_count =  1;
P1 = zeros(size(position_descrip,1),2);
count = 1 ;
while ( keypoints1(row_count,1) ~=0 )
    for i = 1:1:size(position_descrip,1)
        if( (position_descrip(i,1) == keypoints1(row_count,4)) && (position_descrip(i,1) ~= 0) )
            P1(count,:) = [ keypoints1(row_count,2) keypoints1(row_count,1) ];
            count = count + 1 ;
        end
    end
row_count = row_count +1;
end
% finding the position of matched keypoints in the 2nd image
% Note: the row count of the discriptor is diffrent from the keypoints as we
%       bypassed the key points that have no 16x16 neighbourhood
row_count =  1;
P2 = zeros(size(position_descrip,1),2);
count = 1 ;
while ( keypoints2(row_count,1) ~=0 )
    for i = 1:1:size(position_descrip,1)
        if( (position_descrip(i,2) == keypoints2(row_count,4)) && (position_descrip(i,2) ~= 0) )
            P2(count,:) = [ keypoints2(row_count,2) keypoints2(row_count,1) ];
            count = count + 1 ;
        end
    end
row_count = row_count +1;
end
 
% an array of the final difrance in position between the two matched key
% points which is equivalent to the shift in the two images
  PF = P1-P2;
  shift_final=[0 0];

  % we take the average of the array to get the exact final shift
for i= 1:1:size(PF,1)
      shift_final = shift_final + PF(i,:);
end

  % the final shift 
  shift_final = round(shift_final ./ size(PF,1));
  
  
    

