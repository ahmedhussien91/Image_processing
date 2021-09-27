
image2=imread('Louvre2.jpg');
image1=imread('Louvre1.jpg');
threshold=0.1;
MAXS=20;
%apply the sift algorithim untill finding the keypoints1 of image1
[output_image,conv_image_1sig,conv_image_5sig,keypoints1]=sift(image1,MAXS,threshold);
%apply the sift algorithim untill finding the keypoints2 of image2
[output_image2,conv_image_1sig,conv_image_5sig,keypoints2]=sift(image2,MAXS,threshold);
% take the two keypoints and two images and return the final shift between
%the two images it returns the PF which contian the diffrance between all
%the keypoints position
[shift_final,PF]=stitch2(keypoints1,keypoints2,image1,image2);
% stitch the two images using the final shift and the two images
[stitched_image] = conc( shift_final, image1, image2);