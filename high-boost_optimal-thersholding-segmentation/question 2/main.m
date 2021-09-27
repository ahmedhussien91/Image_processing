image = imread('Water.jpg');
threshold = optimal_threshold(image);
% segmented_image
segmented_image = segment(image, threshold);
imwrite(segmented_image, 'Water_seg.jpg')
fileID = fopen('threshold.txt','wt');
fprintf(fileID,'threashold = %8.3f', threshold);
fclose(fileID);