% create random_image using quilt_random function
function random_image = quilt_random(sample, outsize, patchsize)
    dim = size(sample);
    num = int16(outsize/patchsize);
    imrand = zeros(outsize, outsize, 3);
    for i = 1:num
        for j = 1:num
            rand_y = randi(dim(1)-patchsize);
            rand_x = randi(dim(2)-patchsize);
            imrand((i-1)*patchsize+1:i*patchsize, (j-1)*patchsize+1:j*patchsize, 1:3) = sample(rand_y:rand_y+patchsize-1, rand_x: rand_x+patchsize-1, 1:3);
        end
    end
    random_image = imrand;
end