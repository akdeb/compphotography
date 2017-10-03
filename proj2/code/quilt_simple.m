% overlapping patches function
%{
Function: quilt_simple()
This function takes the image sample, the output size and patchsize and
creates another image that looks like the sample but uses an overlapping
algorithm so edge artifacts do exist
%}

function imoverlap = quilt_simple(sample, outsize, patchsize, overlap, tol)
   %% init first random sample and other constants
   dim = size(sample);
   rand_y = randi(dim(1)-patchsize);
   rand_x = randi(dim(2)-patchsize);
   imoverlap = zeros(outsize, outsize, 3); % init output image as all zeros
   imoverlap(1:patchsize, 1:patchsize, 1:3) = sample(rand_y:rand_y+patchsize-1, rand_x:rand_x+patchsize-1,1:3);
   num_imoverlap = floor((outsize-patchsize)/(patchsize-overlap));
   
   %% horizontally fill out imoverlap
   % find template for each new patch
   % fixed mask for every new horizontal patch
   M = zeros(patchsize);
   M(1:patchsize, 1:overlap) = ones(patchsize, overlap);
   start_idx = patchsize-overlap+1;
   
   for i = 1:num_imoverlap
       T = imoverlap(1:patchsize, start_idx:start_idx+patchsize-1, 1:3);
       ssd = ssd_patch(sample, M, T);
       imoverlap(1:patchsize, start_idx:start_idx+patchsize-1, 1:3) = choose_sample(patchsize, sample, ssd, tol);
       start_idx = start_idx+patchsize-overlap;
   end
      
   %% vertically fill out imoverlap
   % find template for each new patch
   % fixed mask for every new vertical patch
   M = zeros(patchsize);
   M(1:overlap, 1:patchsize) = ones(overlap, patchsize);
   start_idx = patchsize-overlap+1;
   
   for i = 1:num_imoverlap
       T = imoverlap(start_idx:start_idx+patchsize-1, 1:patchsize, 1:3);
       ssd = ssd_patch(sample, M, T);
       imoverlap(start_idx:start_idx+patchsize-1, 1:patchsize, 1:3) = choose_sample(patchsize, sample, ssd, tol);
       start_idx = start_idx+patchsize-overlap;
   end
   
   %% run a for loop for remaining matrix which has a fixed mask too
   % each new patch will have a new template
   % fixed mask has both up and down overlap
   M = zeros(patchsize);
   M(1:patchsize, 1:overlap) = ones(patchsize, overlap);
   M(1:overlap, 1:patchsize) = ones(overlap, patchsize);
   start_row = patchsize-overlap+1;
   
   for i = 1:num_imoverlap
       start_col = patchsize-overlap+1;
       for j = 1:num_imoverlap
            T = imoverlap(start_row:start_row+patchsize-1, start_col:start_col+patchsize-1, 1:3);
            ssd = ssd_patch(sample, M, T);
            imoverlap(start_row:start_row+patchsize-1, start_col:start_col+patchsize-1, 1:3) = choose_sample(patchsize, sample, ssd, tol);
            start_col = start_col + patchsize-overlap;
       end
       start_row = start_row + patchsize-overlap;
   end
end