 image=imread('Fish.jpg');
 MAXS=20;
 threshold=0;
 [output_image,conv_image_1sig,conv_image_5sig,keypoints]=sift(image,MAXS,threshold);
 imwrite(output_image,'Fish_0.jpg');
 imwrite(conv_image_1sig,'Fish_S1.jpg');
 imwrite(conv_image_5sig,'Fish_S5.jpg');
 
 threshold=0.01;
 [output_image,conv_image_1sig,conv_image_5sig,keypoints]=sift(image,MAXS,threshold);
 imwrite(output_image,'Fish_01.jpg');
 
 threshold=0.05;
 [output_image,conv_image_1sig,conv_image_5sig,keypoints]=sift(image,MAXS,threshold);
 imwrite(output_image,'Fish_05.jpg');