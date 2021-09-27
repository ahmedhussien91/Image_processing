function [filtered_image] = high_boost ( image, D0, A ,n)

% Convert t h e input to image floating point .
[ image , revertClass ] = tofloat(image) ;

% generating the low pass filter
Hlp = lpfilter('btw', size(image ,1), size(image,2), D0, n);

% generating the high pass filter
Hhp = 1 - Hlp;

% genereting the high-boost filter
H = (A-1) + Hhp;

% Obtain t h e FFT of t h e padded input .
image_F = fft2(image , size(H, 1) , size(H , 2));

% shifting the filter H and image output to display the output 
H = fftshift(H);
image_F = fftshift(image_F);

% displaying the image frequancy domain and the filter frequancy domain 
% imshow(abs(H))
% figure
% imshow(abs(image_F))
% figure


% Perform image filtering .
filtered_image = ifft2(H.*image_F);

% Crop to original size .
filtered_image = filtered_image(1:size(image , 1), 1:size(image , 2) ); % filtered_image is of class single here .

% Convert the output to the same class as the input 
filtered_image = abs(filtered_image);

