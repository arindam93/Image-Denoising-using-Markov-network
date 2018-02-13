%% PGM homework 1 (Image Denoising using Markov Network)
%  Arindam Duttagupta

clc;
clear all;
close all;

load('hw1_images.mat');

%% Constants initialized
h = 1;
beta = 4;
v = 2;

[m, n] = size(noisyImg);

ImageZ = noisyImg;
flips = 1;
iter = 0;
ImageZ = padarray(ImageZ,[1 1]);
noisyImg = padarray(noisyImg,[1 1]);

while flips > 0
    flips = 0;
    
    for i = 2:m+1
        for j = 2:n+1
            
            curr_pixel_X = noisyImg(i,j);
            curr_pixel_Z = ImageZ(i,j);
            
                                      
            energy = h*curr_pixel_Z - beta*((ImageZ(i,j-1) + ImageZ(i-1,j) + ImageZ(i,j+1) + ImageZ(i+1,j))*ImageZ(i,j)) - v*curr_pixel_Z*curr_pixel_X;
            
            if energy > 0
                
                ImageZ(i,j) = - curr_pixel_Z;
                flips = flips + 1;
            end
        end
    end
    fprintf('Count of total flips: %f\n',flips);
    
    iter = iter + 1;
end

fprintf('Number of iterations over the noisy image: %d\n',iter);

ImageZ = ImageZ(2:end-1,2:end-1);
noisyImg = noisyImg(2:end-1,2:end-1);

denoised_im = ImageZ;
figure, imshow(noisyImg), title('Noisy Image');
figure, imshow(denoised_im), title('Denoised Image');

%% Error rate

sub_im = origImg-denoised_im;
z = nnz(sub_im);
error_rate = z/(m*n);
fprintf('Final error rate percentage: %f\n',100*error_rate);


