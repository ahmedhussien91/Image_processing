image = imread('Moon.jpg');
%1
D0 = 50;
A = 1.5;
n=1;
[filtered_image] = high_boost(image, D0,A,n); 
imwrite(abs(filtered_image),'MoonHB_1.jpg');
%2
A = 2;
[filtered_image] = high_boost(image, D0,A,n); 
imwrite(abs(filtered_image),'MoonHB_2.jpg');
%3
n=2;
[filtered_image] = high_boost(image, D0,A,n); 
imwrite(abs(filtered_image),'MoonHB_3.jpg');