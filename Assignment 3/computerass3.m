close all 
clear all

s = load('Pepsi.mat');
% Extract the first image and display it.
p1 = s.pepsi;
histp1 = imhist(p1);

% adj= imadjust(p1);
J = histeq(p1,7);
J1 = histeq(p1,255);

histJ=imhist(J);
figure(1)
subplot(1,3,1)

imshow(p1);
title("Original Image")
subplot(1,3,2)
imshow(J);
title("Constrast enhancement with 7 bins")
subplot(1,3,3)
imshow(J1);
title("Constrast enhancement with 255 bins")
sgtitle("Contrast Enhancement using histogram ")
figure(2)
%subplot(1,3,1)
title("")
imhist(p1);
title("Histogram of original image")

figure(3)
%subplot(1,3,2)
imhist(J);
title("Histogram of bins with 7 bins")

figure(4)
%subplot(1,3,3)
imhist(J1);
title("Histogram of bins with 255 bins")