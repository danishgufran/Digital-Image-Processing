clear;
clc;
close all;
clear all;
%% start
n = 8;
s = load('Peppers.mat');
% Extract the first image and display it.
p1 = s.peppers;
imshow(uint8(p1));
I = imread('Peppers.png');
I = im2gray(I);
I = flip(I, 2);
I = im2double(I);
%% 2d dct of 16x16 blocks
D = dctmtx(size(I,1));
dct1 = D*I*D';
figure

imshow(dct1);           %dct of blocks
%dct of entire img
title('DCT without non overlapping block');
T = dctmtx(n);
dct = @(block_struct) T*block_struct.data*T';
B = blockproc(I,[n n],dct);
figure
position =  [1 50];

caption2= sprintf('\nblock size = (%d)-------', n);
value = [caption2];
% text(10, 10, caption, 'FontSize', 30);
b1 = insertText(B,position,value,'FontSize', 20,'AnchorPoint','LeftBottom');
imshow(b1);           %dct of blocks
title('DCT with 16X16 blocks');

%% criteria
absB = abs(B);
maskedB = absB(1:n,1:n);
sizeB = [size(B,1)/n size(B,2)/n];
BEnergy = sum(abs(B(1:n,1:n)),'all');
d = zeros(n);  

for i=1:n
    for j=1:n
        if sum(maskedB(1:i,1:j),'all') >= 95/100*BEnergy
            d(i,j) = 1;
        end
    end
end
d = flip(d,1);
d = flip(d,2);
%% masking

mask = d;
B2 = blockproc(B,[n n],@(block_struct) mask .* block_struct.data);
figure
position =  [1 50];

caption2= sprintf('\nblock size = (%d)-------', n);
value = [caption2];
% text(10, 10, caption, 'FontSize', 30);
b2 = insertText(B2,position,value,'FontSize', 20,'AnchorPoint','LeftBottom');
imshow(b2);           %dct of blocks
   
%dct of blocks after mask
title('DCT after applying energy threshold on 16X16 blocks');
%% invrdct

invdct = @(block_struct) T' * block_struct.data * T;
I2 = blockproc(B2,[n n],invdct);
figure
imshow(I)
title('The Original Pepper Image');
var1 =var(I);
err=I-I2;
var2= var(err);
div = var1/var2; 
SNR1 = 10*log10(div)
% snr = 10*Log;
% SNR1= snr(I,I2I)
disp(SNR1)
position =  [1 50];
caption = sprintf('SNR = (%f)-------', SNR1);
caption2= sprintf('\nblock size = (%d)-------', n);
value = [caption  caption2];
% text(10, 10, caption, 'FontSize', 30);
R = insertText(I2,position,value,'FontSize', 20,'AnchorPoint','LeftBottom');
figure
imshow(R)
title('The compressed image');
figure
histogram(I2)
title('histogram for 16X16 peppers image');

[c,s]=dbaux(I);
[H2,V2,D2] = detcoef2('all',c,s,2);
A2 = appcoef2(c,s,'haar',2);

V2img = wcodemat(V2,255,'mat',1);
H2img = wcodemat(H2,255,'mat',1);
D2img = wcodemat(D2,255,'mat',1);
A2img = wcodemat(A2,255,'mat',1);

figure
subplot(2,2,1)
imagesc(A2img)
colormap pink(255)
title('Approximation Coef. of Level 2')

subplot(2,2,2)
imagesc(H2img)
title('Horizontal Detail Coef. of Level 2')

subplot(2,2,3)
imagesc(V2img)
title('Vertical Detail Coef. of Level 2')

subplot(2,2,4)
imagesc(D2img)
title('Diagonal Detail Coef. of Level 2')
