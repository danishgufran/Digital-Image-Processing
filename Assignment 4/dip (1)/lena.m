close all 
clear all

s = load('Lena.mat');
I=  s.lena;
p1 = s.lena;
I= uint8(p1);
p1=p1-min(p1(:));
p1=p1/max(p1(:));

v=var(p1(:))/sqrt(10);


N=imnoise(p1,'gaussian',0,v);
figure(1)
subplot(1,2,1)

imshow(p1);
title("Original Image")
subplot(1,2,2)
imshow(N);
snrN = snr(var(p1),var(p1-N));
title(["Image with SNR: 5"]);

mask1 = ones(3,3)/9;
mask2 = [0,0.125,0;0.125,0.5,0.125;0,0.125,0];
mask3 = ones(4,4)/16;
N1=imfilter(N,mask1,'conv');
N2=imfilter(N,mask2,'conv');
N3=imfilter(N,mask3,'conv');
var1 =var(N);
err=N-N1;
% var2= var(N1);
% div = var1/var2; 
% Log = log10(div);
% snr = 10*Log;
snr1= snr(var(N),var(N-N1));
snr2= snr(var(N),var(N-N2));
snr3= snr(var(N),var(N-N3));

% figure(2)
% subplot(2,2,1)
% imshow(N);
% title({["Original Image"]})
% subplot(2,2,2)
% imshow(N1);
% title({["Mask1 "] ['SNR: ',num2str(snr1)]})
% subplot(2,2,3)
% imshow(N2);
% title({["Mask2 "] ['SNR: ',num2str(snr2)]})
% subplot(2,2,4)
% imshow(N3);
% title({["Mask3 "] ['SNR: ',num2str(snr3)]})

figure(3)
subplot(1,3,1)
imshow(p1);
title("Original Image")
subplot(1,3,2)
imshow(N);
title("Noisy Image")
subplot(1,3,3)
imshow(N2);
title({["De-noise image using Spatial filter "] ['SNR:13.33 ']})


