function [threshold] = optimal_threshold(image)

image = double(image);
% 4 corner pixels are considered background
background_sum = (image(1,1) + image( size(image,1),1) + image(1,size(image,2)) + image(size(image,1),size(image,2)));
background_count = 4;
background_mean = background_sum / background_count;

% intial values for the threshold and threshold_old to start the loop
threshold = 0;
threshold_old = 1;

% calculating the sum of all the pixels in the picture
total_sum = 0;
for x = 1:1:size(image,1)
   for y = 1:1:size(image,2)
        total_sum = total_sum + image(x,y);
    end
end

% subtracting the background from the total sum
object_mean = (total_sum - background_sum)/(size(image,1)*size(image,2)-background_count);

% iterations untill a two equivalent thresholds is found 
while (threshold ~= threshold_old)

    % getting threshold_old and threshold to compare them 
    threshold_old = threshold;
    threshold = (object_mean + background_mean) / 2 ;
    
    % getting the background_mean
    background_sum = 0;
    background_count = 0;
    for x = 1:size(image,1)
        for y = 1:size(image,2)
            if ( image(x,y)< threshold)
                background_sum = background_sum + image(x,y);
                background_count = background_count + 1;
            end
        end
    end
    background_mean = background_sum / background_count ;
            
    % subtracting the background from the total sum
    object_mean = (total_sum - background_sum)/(size(image,1)*size(image,2)-background_count);
    
end