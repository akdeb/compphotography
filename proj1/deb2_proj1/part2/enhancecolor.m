im = imread('../../enhance/snow.jpg');
im = im2double(im);

% process of histogram equalization (for hue)
imgray = rgb2gray(im);
[v,s,h] = rgb2hsv(im);

hgram = hist(v(:), 0:1/255:1);
cmltv = cumsum(hgram);

new_val = cmltv(uint16(v*255)+1)/numel(v);

new_img = hsv2rgb(new_val*0.5+v*0.5,s,h);
figure(69);
imshow(new_img);
figure(68);
imshow(im);

% histogram equalization (for value/intensity)
imgray = rgb2gray(im);
[h,s,v] = rgb2hsv(im);

hgram = hist(v(:), 0:1/255:1);
cmltv = cumsum(hgram);

new_val = cmltv(uint16(v*255)+1)/numel(v);

new_img = hsv2rgb(h,s,new_val*0.5+v*0.5);
figure(70);
imshow(new_img);
figure(71);
imshow(im);