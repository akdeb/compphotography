function im12 = hybridImage(im1, im2, low, high)
    im1blur = imgaussfilt(im1, low);
    im2blur = im2 - imgaussfilt(im2, high);
    figure(69); imshow(im1blur);  
    im12 = im1blur + im2blur;
end