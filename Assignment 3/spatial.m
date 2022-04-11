clc;
clear all;
close all;
x = load('Lena.mat');
I=  x.lena;
N11=I/255;
figure(1)
imshow(N11)
figure(2)
N = imnoise(N11,'gaussian',0.05);
imshow(N)
title("Lena image with 5dB gaussian noise");
snr1 = snr(var(N11),var(N11-N))


%%%%%%%%%%%%%%%%%%%%%%%%
f1=[1 1 1;1 1 1;1 1 1];
f2=[1 0 -1;1 0 -1;1 0 -1];
f3=[1 1 1;0 0 0;-1 -1 -1];
% -------filtering-----------%
% x1=N11(1:256,1:256);
% N1=conv2(N11,f1,'same');
% N2=conv2(N11,f2,'same');
% N3=conv2(N11,f3,'same');
% figure(3)
% 
% subplot(2,2,1);imshow(N11);title('IMAGE ')
% subplot(2,2,2);imshow(N1);title('f1- IMAGE ')
% subplot(2,2,3);imshow(N2);title('f2- IMAGE ')
% subplot(2,2,4);imshow(N3);title('f3-IMAGE ')






mask1 = ones(3,3)/9;
mask2 = [0,0.125,0;0.125,0.5,0.125;0,0.125,0];
mask3 = ones(4,4)/16;
N1= conv2(N,mask1,'same');
N2=conv2(N,mask2,'same');
N3=conv2(N,mask3,'same');

N12= conv2(N11,mask1,'same');
N22=conv2(N11,mask2,'same');
N32=conv2(N11,mask3,'same');
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
Hd = zeros(16,16);
Hd(5:12,5:12) = 1;
Hd(7:10,7:10) = 0;
w = [0:2:16 16:-2:0]/16;
h = fwind1(Hd,w);
colormap(parula(32))
freqz2(N2,[32 32]);
axis ([-1 1 -1 1 0 200])

% --------filter coeff.-----------%
