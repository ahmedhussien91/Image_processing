function [segmented_image] = segment (image, threshold)
for x = 1:1:size(image,1)
    for y = 1:1:size(image,2)
        if ( image(x,y) >= threshold)
            image(x,y) = 1;
        else
            image(x,y) = 0;
        end
    end
end
segmented_image = logical(image);