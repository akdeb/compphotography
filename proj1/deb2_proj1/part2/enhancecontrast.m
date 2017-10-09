im = imread('../../enhance/trek.jpg');
im = im2double(im);

%% color rebalance

mn = mean(im(:));
alpha_values = mn ./ [mean(im(:,:,1)) mean(im(:,:,2)), mean(im(:,:,3))];
bal_im = cat(3, alpha_values(1)*im(:,:,1), alpha_values(2)*im(:,:,2), alpha_values(2)*im(:,:,3));

%{
figure(69); imshow(bal_im);
hold on;
subplot(1,2,1); imshow(im);
subplot(1,2,2); imshow(bal_im);
%}

%% gamma correction for improved contrast
im = imread('../../enhance/trek.jpg');
im = im2double(im);
gamma = 1.6
img = im .^ gamma;

figure;
imshow(img);

