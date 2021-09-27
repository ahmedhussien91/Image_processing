function [rotated_image_nearest_neighbour,croped_image] = rotate( image, ceta)
% function take the image array + ceta and return the image rotated by ceta by two methods 1-image_rotated(caluclated by linear interpoation) 2-rotated_image_nearest_neighbour 
% ceta will be in degree 
% the program will return the full image by only for values of ceta between
% 0 and 90 degrees other values for ceta is not granted

image0=zeros(2*size(image,1),2*size(image,2));
rotated_image_nearest_neighbour = zeros(2*size(image,1),2*size(image,2)); %intializing the rotated_image_linear with zeros for preallocation

T=[cos((ceta/180)*pi) -sin((ceta/180)*pi);sin((ceta/180)*pi) cos((ceta/180)*pi)]; % transforamation function 

%putting the image in a bigger image for rotation without croping any part
%of the image
for x=1:size(image,1)
    for y=1:size(image,2)
        image0(x+size(image,1)/4,y+size(image,2)/4)=image(x,y);
    end
end

% linear image and nearest neighbour 
for  X_new=1:2*size(image,1)
    for Y_new=1:2*size(image,2)
        if ceta < 45                                                              % this condition is for determining the offset of the image for angles between 0 and 90
            X  = (inv(T) * [X_new ; Y_new])+[-3*ceta;3*ceta]  ;                   %offsets are chosen by trial and error there's no special formula 
        elseif ceta >= 45 && ceta <= 90 
            X  = (inv(T) * [X_new ; Y_new])+[-2*(ceta);4.5*ceta]  ;               %offsets are chosen by trial and error there's no special formula  
        else
            if X_new ==1 && Y_new == 1
                disp('valid range is from 0 to 90 image will not be mostly displayed because the offset is not calculated right ')
                X  = (inv(T) * [X_new ; Y_new])+[-2*(ceta);4.5*ceta]  ;
            else
                X  = (inv(T) * [X_new ; Y_new])+[-2*(ceta);4.5*ceta]  ;
            end
        end
        
        
        X=round(X);
        X=uint16(X);
        if X(1) > 0 && X(1) < size(image0,1) && X(2) > 0 && X(2) < size(image0,1)
            rotated_image_nearest_neighbour(X_new , Y_new) = image0 ( X(1)  ,X(2) );                                                      % nearest_neigbour equation 
        else
        end
    end
end

%changing type of rotating image
rotated_image_nearest_neighbour=uint8(rotated_image_nearest_neighbour);



%croping the rotated image ( linear interpolation )

%cutting the upper edge and lower edge
countx=1;                               % this counter is to count the new size of the x (no. of rows )
for x=1:2*size(image,1)
    for y=1:2*size(image,2)
        if( (rotated_image_nearest_neighbour(x,y)==0) )                  %by passing the rows that contain 0 values only
            continue;
        else
            croped_image1(countx,:)=rotated_image_nearest_neighbour(x,:);                             %taking the rows that contain other values into a new array
            countx=countx+1;
            break;
        end
    end
end

%cutting the right and left side 
county=1;              % this counter is to count the new size of the y (no. of colums )         
for y=1:2*size(image,2)
    for x=1:2*size(image,1)
        if( (rotated_image_nearest_neighbour(x,y)==0)  )                %by passing the colums that contain 0 values only
            continue;
        else
            croped_image(:,county)=croped_image1(:,y);                                 %taking the colums that contain other values into a new array
            county=county+1;
            break;
        end
    end
end 

