function [rotated_image,croped_image] = rotate( image, ceta)
% function take the image array + ceta and return the image rotated by ceta by two methods 1-image_rotated(caluclated by linear interpoation) 2-rotated_image_nearest_neighbour 
% ceta will be in degree 
% the program will return the full image by only for values of ceta between
% 0 and 90 degrees other values for ceta is not granted

image0=zeros(2*size(image,1),2*size(image,2));
rotated_image=zeros(2*size(image,1),2*size(image,2)); %intializing the rotated_image with zeros for preallocation 

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
        
        
        % calculating the values used in the interpolation equation  (l,k)
        % (a,b)
        l=floor(X(1));
        k=floor(X(2));
        l=uint16(l);
        k=uint16(k);
        a=X(1)-l;
        b=X(2)-k;
        if k > 0 && l > 0 && k<size(image0,1) && l< size(image0,2)
            rotated_image(X_new , Y_new) = (1-a)*(1-b)*image0(l,k) + a*(1-b)*image0(l+1,k) + b*(1-a)*image0(l,k+1) + a*b*image0(1+l,1+k); %linear interpolation equation 
        else
        end
    end
end

%changing type of rotating image
rotated_image=uint8(rotated_image);



%croping the rotated image ( linear interpolation )

%cutting the upper edge and lower edge
countx=1;                               % this counter is to count the new size of the x (no. of rows )
for x=1:2*size(image,1)
    for y=1:2*size(image,2)
        if( (rotated_image(x,y)==0) )                  %by passing the rows that contain 0 values only
            continue;
        else
            croped_image1(countx,:)=rotated_image(x,:);                             %taking the rows that contain other values into a new array
            countx=countx+1;
            break;
        end
    end
end

%cutting the right and left side 
county=1;              % this counter is to count the new size of the y (no. of colums )         
for y=1:2*size(image,2)
    for x=1:2*size(image,1)
        if( (rotated_image(x,y)==0)  )                %by passing the colums that contain 0 values only
            continue;
        else
            croped_image(:,county)=croped_image1(:,y);                                 %taking the colums that contain other values into a new array
            county=county+1;
            break;
        end
    end
end 

