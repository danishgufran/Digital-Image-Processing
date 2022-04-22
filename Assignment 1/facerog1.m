%%% Computer Assignment 1  %%%
%%% Danish Gufran %%%


% function [recognized_img]=facerecog(datapath,testimg)

% In this part of function, we align a set of face images (the training set x1, x2, ... , xM )
%
% This means we reshape all 2D images of the training database
% into 1D column vectors. Then, it puts these 1D column vectors in a row to 
% construct 2D matrix 'X'.
%  
%
%          datapath   -    path of the data images used for training
%               X     -    A 2D matrix, containing all 1D image vectors.
%                                        Suppose all P images in the training database 
%                                        have the same size of MxN. So the length of 1D 
%                                        column vectors is MxN and 'X' will be a (MxN)xP 2D matrix.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
%%%%%%%%%  finding number of training images in the data path specified as argument  %%%%%%%%%%
datapath="C:\Users\hp\Desktop\CSU\ECE - 513\computer assignment 1\new";
D = dir(datapath);  % D is a Lx1 structure with 4 fields as: name,date,byte,isdir of all L files present in the directory 'datapath'
imgcount = 0;
for i=1 : size(D,1)
    if not(strcmp(D(i).name,'.')|strcmp(D(i).name,'..')|strcmp(D(i).name,'Thumbs.db'))
        imgcount = imgcount + 1; % Number of all images in the training database
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%  creating the image matrix X  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%imgcount=15
X = [];
figure;
for i = 1 : imgcount
    str = strcat(datapath,'\',int2str(i),'.gif');
    img = imread(str);
    subplot(10,11,i),imshow(img)
  %  img = rgb2gray(img);
    [r c] = size(img);
    
    temp = reshape(img,r*c,1);
    %% Reshaping 2D images into 1D image vectors
                               %% here img' is used because reshape(A,M,N) function reads the matrix A columnwise
                               %% where as an image matrix is constructed with first N pixels as first row,next N in second row so on
    X = [X temp];                %% X,the image matrix with columnsgetting added for each image
end
sgtitle('Original faces')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Now we calculate m, A and eigenfaces.The descriptions are below :
%
%          m           -    (MxN)x1  Mean of the training images
%          A           -    (MxN)xP  Matrix of image vectors after each vector getting subtracted from the mean vector m
%     eigenfaces       -    (MxN)xP' P' Eigenvectors of Covariance matrix (C) of training database X
%                                    where P' is the number of eigenvalues of C that best represent the feature set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% calculating mean image vector %%%%%

m = mean(X,2); % Computing the average face image m = (1/P)*sum(Xj's)    (j = 1 : P)
figure;
hold on;
imshow(mat2gray(reshape(m,r,c)));

title('Mean faces');
imgcount = size(X,2);

%%%%%%%%  calculating A matrix, i.e. after subtraction of all image vectors from the mean image vector %%%%%%
figure;
A = [];
for i=1 : imgcount
    temp = double(X(:,i)) - m;
    A = [A temp];
     subplot(10,11,i),imshow(mat2gray(reshape(A(:,i),r,c)))
end
sgtitle('Zero mean faces')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CALCULATION OF EIGENFACES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  we know that for a MxN matrix, the maximum number of non-zero eigenvalues that its covariance matrix can have
%%%  is min[M-1,N-1]. As the number of dimensions (pixels) of each image vector is very high compared to number of
%%%  test images here, so number of non-zero eigenvalues of C will be maximum P-1 (P being the number of test images)
%%%  if we calculate eigenvalues & eigenvectors of C = A*A' , then it will be very time consuming as well as memory.
%%%  so we calculate eigenvalues & eigenvectors of L = A'*A , whose eigenvectors will be linearly related to eigenvectors of C.
%%%  these eigenvectors being calculated from non-zero eigenvalues of C, will represent the best feature sets.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
L= A' * A;
[V,D]=eig(L);  %% V : eigenvector matrix  D : eigenvalue matrix

%%%% again we use Kaiser's rule here to find how many Principal Components (eigenvectors) to be taken
%%%% if corresponding eigenvalue is greater than 1, then the eigenvector will be chosen for creating eigenface

L_eig_vec = [];
for i = 1 : size(V,2) 
%     if( D(i,i) > 1 )
        L_eig_vec = [L_eig_vec V(:,i)];
%     end
end

%%% finally the eigenfaces %%%
eigenfaces = A * L_eig_vec;
[a,b]=size(eigenfaces);
for i=1:b
    subplot(10,11,i),imshow(mat2gray(reshape(eigenfaces(:,i),r,c)))
end
sgtitle('Eigen faces')

%% Reconstruction


V = A*V*(abs(D))^-0.5;

% figure(1)
% imshow(eigenfaces(reshape(V(:,imgcount),r,c)))
% figure(2)
% imshow(eigenfaces(reshape(V(:,imgcount-1),r,c)))
% figure(3)
% plot(diag(D))
% num_eigenfaces = imgcount;
% V = V(:,1:num_eigenfaces);
% Vpca=[];
%% KL coeffecient
KLC = A'*V; %%KL coeefficient
% image_index = 1;
%% Reconstruction

i=1;
reconst = V*KLC';
figure;
hold on;
count = 0 ;
for image_index = 1:1:imgcount
    if count<10
       
        diff = abs(reconst(:,image_index) - A(:,image_index));
        snr = mean(uint8(A(:,image_index))./uint8(reconst(:,image_index)));
        subplot(10,11,i),imshow(mat2gray(reshape(m+A(:,image_index), r,c)));
        title('Original Image')
        subplot(10,11,i+1),imshow(mat2gray(reshape(m+reconst(:,image_index),r,c)))
        title(['Reconstructed Image SNR:',num2str(snr)]);
        i=i+2;
        count = count+1;
    else 
        break
    end
end

%In this part of recognition, we compare two faces by projecting the images into facespace and 
% measuring the Euclidean distance between them.
%
%            recogimg           -   the recognized image names
%             testimg           -   the path of test image
%                m              -   mean image vector
%                A              -   mean subtracted image vector matrix
%           eigenfaces          -   eigenfaces that are calculated from eigenface function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% finding the projection of each image vector on the facespace (where the eigenfaces are the co-ordinates or dimensions) %%%%%

projectimg = [ ];  % projected image vector matrix
for i = 1 : size(eigenfaces,2)
    temp = eigenfaces' * A(:,i);
    projectimg = [projectimg temp];
end

%%%%% extractiing PCA features of the test image %%%%%
for z=15 : 16
    disp(z)
    testimg = strcat("C:\Users\hp\Desktop\CSU\ECE - 513\computer assignment 1\new",'\',int2str(z),'.gif');
    test_image = imread(testimg);
    %test_image = test_image(1,1,4);

    [r c] = size(test_image);
    temp = reshape(test_image',r*c,1); % creating (MxN)x1 image vector from the 2D image
    temp = double(temp)-m; % mean subtracted vector
    projtestimg = eigenfaces'*temp; % projection of test image onto the facespace
    


%%%%% calculating & comparing the euclidian distance of all projected trained images from the projected test image %%%%%
    euclide_dist = [ ];
    for i=1 : size(eigenfaces,2)
        temp = (norm(projtestimg-projectimg(:,i)))^2;
        euclide_dist = [euclide_dist temp];
    end

    [euclide_dist_min recognized_index] = min(euclide_dist);
    recognized_img = strcat(datapath,'\',num2str(z),'.gif');
    snr = mean2(uint8(A(:,image_index))./uint8(reconst(:,recognized_index)));
    figure,imshow(recognized_img)
    title(['Test Image SNR:',num2str(snr)]);
    recognized_index = recognized_index+1;
end  
