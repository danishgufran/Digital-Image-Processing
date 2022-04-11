close all 
clear all

s = load('Lena.mat');
I=  s.lena;
p1 = s.lena;
I= uint8(p1);
p1=p1-min(p1(:));
p1=p1/max(p1(:));

v=var(p1(:))/sqrt(10);


N=imnoise(p1,'salt & pepper',0.1);
N11=imnoise(p1,'salt & pepper',0.2);
figure(1)
subplot(1,3,1)

imshow(p1);
title("Original Image")
subplot(1,3,2)
imshow(N);
title(["Image with d=0.1"]);
subplot(1,3,3)
imshow(N11);
title(["Image with d=0.2"]);
mask1 = ones(3,3)/9;
mask2 = [0,0.125,0;0.125,0.5,0.125;0,0.125,0];
mask3 = ones(4,4)/16;
N1= medfilt2(N,[3 3]);
N2=medfilt2(N,[5 5]);
N3=medfilt2(N,[7 7]);

N12= medfilt2(N11,[3 3]);
N22=medfilt2(N11,[5 5]);
N32=medfilt2(N11,[7 7]);
var1 =var(N);
err=N-N1;
vare = var(err);
% var2= var(N1);
% div = var1/var2; 
% Log = log10(div);
% snr = 10*Log;
snr1= snr(var1,vare);
snr2= snr(var1,var(N-N2));
snr3= snr(var1,var(N-N3));
snr12= snr(var(N11),var(N11-N12));
snr22= snr(var(N11),var(N11-N22));
snr32= snr(var(N11),var(N11-N32));
figure(2)
subplot(2,2,1)
imshow(N);
title({["Original Image  d=0.1"]})
subplot(2,2,2)
imshow(N1);
title({["3x3 Mask "] ['SNR: ',num2str(snr1)]})
subplot(2,2,3)
imshow(N2);
title({["5X5 Mask "] ['SNR: ',num2str(snr2)]})
subplot(2,2,4)
imshow(N3);
title({["7X7 Mask "] ['SNR: ',num2str(snr3)]})

figure(3)
subplot(2,2,1)
imshow(N11);
title({["Original Image  d=0.2"]})
subplot(2,2,2)
imshow(N12);
title({["3x3 Mask "] ['SNR: ',num2str(snr12)]})
subplot(2,2,3)
imshow(N22);
title({["5X5 Mask "] ['SNR: ',num2str(snr22)]})
subplot(2,2,4)
imshow(N32);
title({["7X7 Mask "] ['SNR: ',num2str(snr32)]})



