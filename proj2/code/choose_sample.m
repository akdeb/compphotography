%{
Function: choose_sample()
This function takes the ssd image produced in the ssd_patch function and
select a patch with low cost so it looks most similar to the overlapping
patch.
%}

function impatch = choose_sample(patchsize, sample, ssd)
    % calculate dimensions of score/cost matrix and find min pixel
    dim = size(sample);
    minmat = ssd((patchsize+1)/2:dim(1)-(patchsize-1)/2, (patchsize+1)/2:dim(2)-(patchsize-1)/2);
    [y, x] = find(minmat==min(min(minmat)));
    
    % gives vectors for min pixels
    % select any point from these min points
    rand_idx = randi(size(x,1));
    
    % points on sample
    half = (patchsize-1)/2;
    rand_y = y(rand_idx)+half; 
    rand_x = x(rand_idx)+half;
    
    % find value of impatch and return
    impatch = sample(rand_y-half:rand_y+half, rand_x-half:rand_x+half , 1:3);
end