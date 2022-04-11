close all 
clear all

s = load('boat.mat');
I=  s.boat;
I1=I/255;


edge11 = edge(I1,'Sobel',0.04);
edge12 = edge(I1,'Sobel',0.06);
edge13 = edge(I1,'Canny',0.2);
edge14 = edge(I1,'Canny',0.09);
figure(1)
subplot(1,3,1)
imshow(I1);
title("Original Image")
subplot(1,3,2)
imshow(edge11);
title("Sobel: 0.04");
subplot(1,3,3)
imshow(edge12);
title("Sobel: 0.06");

subplot(1,3,1)
imshow(I1);
title("Original Image")
subplot(1,3,2)
imshow(edge13);
title("Canny: 0.2");
subplot(1,3,3)
imshow(edge14);
title("Canny: 0.09");
% figure(1)
% montage({I1, edge11, edge12}, 'Size', [1 3])
% title("Original image        sobel:0.04            sobel:0.06")
% figure(2)
% montage({I1, edge13, edge14}, 'Size', [1 3])
% title("Original image         Canny:0.2            Canny:0.09")