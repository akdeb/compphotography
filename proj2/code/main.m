%{
The following code has been written by Akashdeep Deb (deb2)
Each part has been modularized and can be run by pressing Ctrl+Enter while 
in each part. 
Please use odd values for patchsize as the code does not handle even values
currently.

1. Randomly Sampled Texture (10 pts)
2. Overlapping Patches (30 pts)
3. Seam Finding (20 pts)
4. Texture Transfer (30 pts)
5. Quality of results (10 pts) 
%}

%% 1. Randomly Sampled Texture (10 pts)
% read image into imsample and call quilt_random function
im2sample = im2single(imread('./../sample/feynman.tiff'));
imrandom = quilt_random(im2sample, 400, 50);
figure;
imshow(imrandom);

%% 2. Overlapping Patches (30 pts)
% read image in imsample and call quilt_simple function
% use only odd positive integers for patchsize for now
im2sample = im2single(imread('./../sample/tmt1.jpg'));
imoverlap = quilt_simple(im2sample, 800, 25, 4, 0.01);
figure;
imshow(imoverlap);

%% 3. Seam finding (20 pts)
% use cut.m to find a cut in the image and combine both images  
% use this method to combine two overlapping images
im2sample = im2single(imread('./../sample/breads.jpg'));
imoverlap = quilt_cut(im2sample, 400, 25, 5, 0.01);
figure;
imshow(imoverlap);

%% 4. Texture Transfer (30 pts)
% use quilt_cut.m and the texture_transfer algorithm 
% function imtransfer = texture_transfer(imintensity, imtexture, outsize, patchsize, overlap, tol)

% this is for gray only - comment this is image being loaded is alreay rgb
%{
im = imread('./../sample/sketch.tiff');
dim = size(im);
newim = ones(dim(1), dim(2), 3);
for i=1:3
    newim(:,:,i) = im;
end
imintensity = im2single(newim);
%}

imintensity = im2single(imread('./../sample/feynman.tiff'));
imtexture = im2single(imread('./../sample/paint.jpg'));
imtransfer = texture_transfer(imintensity, imtexture, 35, 4, 0.01);
figure;
imshow(imtransfer);
