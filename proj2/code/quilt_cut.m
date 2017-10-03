% uses seam finding to find the minimum boundary cut
function imoverlap = quilt_cut(sample, outsize, patchsize, overlap, tol)
   % init first random sample and other constants
   dim = size(sample);
   rand_y = randi(dim(1)-patchsize);
   rand_x = randi(dim(2)-patchsize);
   imoverlap = zeros(outsize, outsize, 3); % init output image as all zeros
   imoverlap(1:patchsize, 1:patchsize, 1:3) = sample(rand_y:rand_y+patchsize-1, rand_x:rand_x+patchsize-1,1:3);
   num_imoverlap = floor((outsize-patchsize)/(patchsize-overlap));
   
   % vertically fill out imoverlap
   % find template for each new patch
   % fixed mask for every new vertical patch
   M = zeros(patchsize);
   M(1:overlap, 1:patchsize) = ones(overlap, patchsize);
   start_idx = patchsize-overlap+1;
   
   for i = 1:num_imoverlap
       T = imoverlap(start_idx:start_idx+patchsize-1, 1:patchsize, 1:3);
       ssd = ssd_patch(sample, M, T);
       sample = choose_sample(patchsize, sample, ssd);
       
       % calc diff from existing and sampled patch
       % calculate sum of all channel errors ssd and send to cut function
       diff = T(patchsize-overlap+1:patchsize, 1:patchsize, 1:3) - sample(1:overlap, 1:patchsize, 1:3);
       errpatch = diff(:,:,1).^2 + diff(:,:,1).^2 + diff(:,:,1).^2;
       mask = cut(errpatch);
       figure(i);
       imshow(mask);
       
       % uncomment this line later - use the mask to decide which pixels go
       % where according to the seam
       % imoverlap(start_idx:start_idx+patchsize-1, 1:patchsize, 1:3) = ;
       start_idx = start_idx+patchsize-overlap;
   end
end