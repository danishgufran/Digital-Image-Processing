close all 
clear all
 
% Extract the first image and display it.
s = load('Pepsi.mat');
p1 = s.pepsi;
histp1 = imhist(p1);
figure(1);
imshow(p1)
figure(2);
imhist(p1);
a=size(p1);
 
 
p2 = imread('Pepsi.jpg');
grey = rgb2gray(p2);
histp2 = imhist(grey);
figure(3);
imshow(p2)
figure(4);
imhist(grey);
 
    
adj= imadjust(grey);
% J = imhistmatch(p1,adj,30);
J = histeq(p1,255);
J1 = imhistmatch(J,grey,255);
 
histJ=imhist(J);
figure(5)
subplot(1,3,1)
 
imshow(p1);
title("Original Image")
subplot(1,3,2)
imshow(J);
title("Equalized Image")
subplot(1,3,3)
imshow(J1);
title("Specification Image")
sgtitle("Histogram Specification ")
figure(6)
subplot(1,3,1)
title("")
imhist(p1);
title("Histogram of original image")
subplot(1,3,2)
imhist(J);
title("Histogram of Equalized image")
subplot(1,3,3)
imhist(J1);
title("Histogram of Specification Image")
