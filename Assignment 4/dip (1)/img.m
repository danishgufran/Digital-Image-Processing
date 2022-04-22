close all 
clear all

S = imread('lena.jpg');
I = im2double(S);
I=  rgb2gray(I);
% Extract the first image and display it.
% I = s.lena;
% I=I/255;
% figure;imshow(I);title('Original Image');

%%%% blurred image %%%%
LEN = 21;
THETA = 11;
PSF = fspecial('motion',21,11);
Blurred = imfilter(I,PSF,'circular','conv');
figure(1);
imshow(Blurred);
title("Lena Image after b");

%%%% noisy image %%%%

noise =  awgn(I,15,'measured');
snr1=snr(var(I),var(I-noise));

figure(4);
imshow(noise);
title('Noisy Image SNR:5');

%%%% Noise algorithm %%%%

noisyvar=abs(var(noise(:)));
normvar =abs(var(I(:)));

diffvar= noisyvar-normvar;

%%%% Add Filter %%%%

[wnr3,vnoise] = wiener2(noise,[5,5]);
figure(5);
imshow(wnr3);
title('Denoised image using wiener fiter');
 
%%% blurred_noisy image %%%%
blurred = imfilter(I,PSF,'conv','circular');

noise_mean = 0;
noise_var = 0.0001;
blurred_noisy = imnoise(blurred,'gaussian',noise_mean,noise_var);

% snr1=snr(I,(I-noise));
% 
% figure(6);
% imshow(blurred_noisy);
% title('Blurred Noisy Image SNR:5');
signal_var = var(I(:));

[wnr7,vnoise] = wiener2(blurred_noisy,[3,3]);
NSR = vnoise / signal_var;
wnr4 = deconvwnr(blurred_noisy,PSF,NSR);
figure(7);
imshow(wnr4);
title('Restoration of Blurred Noisy Image (Estimated NSR)')

%%%% display image %%%%
snr1= snr(var(noise),var(noise-wnr3));
wnr1 = deconvwnr(Blurred,PSF);
figure(3);
subplot(1,3,1);
imshow(I);
title("Original Image");
subplot(1,3,2);
imshow(blurred_noisy);
title("Noisy Image");
figure(4);
imshow(wnr4);
str = sprintf('De-noised Image with SNR = 18.15', snr1)
title(str)