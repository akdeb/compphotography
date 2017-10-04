%{
Function: texture_transfer()
This function takes in two images and performs a transfer of texture from
one over to the other using the algorithm desribed in the efros et al.
paper. 
%}

function imtransfer = texture_transfer(imintensity, imtexture, patchsize, overlap, tol)
    %% init values to be used
    dim = size(imintensity);
    imtransfer = zeros(dim);
    imsmudged = imgaussfilt(imintensity, 3);
    % weight for ssd
    alpha = 0.1; 
    
    % calculate ssd_overlap
    T = imtransfer(1:patchsize, 1:patchsize, 1:3);
    M1 = zeros(patchsize);
    ssd_overlap = ssd_patch(imtexture, M1, T);
    
    % calculate ssd_transfer
    T = im2double(imsmudged(1:patchsize, 1:patchsize, 1:3));
    M2 = ones(patchsize);
    ssd_transfer = ssd_patch(imtexture, M2, T);
    
    % cost function and paste it in new position
    cost = alpha * ssd_overlap + (1-alpha) * ssd_transfer;
    rand_sample = choose_sample(patchsize, imtexture, cost, tol);
    imtransfer(1:patchsize, 1:patchsize, 1:3) = rand_sample; 
    
    % number of images horizontally and vertically
    numimages_v = floor((dim(1)-patchsize)/(patchsize-overlap));
    numimages_h = floor((dim(2)-patchsize)/(patchsize-overlap));

    %% fill out values vertically
    % calculate ssd_overlap
    % first calculate masks
    M1 = zeros(patchsize);
    M1(1:overlap, 1:patchsize) = ones(overlap, patchsize);
    M2 = ones(patchsize);

    % run loop for all vertical images
    start_idx = patchsize-overlap+1;
    for i = 1:numimages_v
        % calculate template and ssd_transfer
        T = im2double(imsmudged(start_idx:start_idx+patchsize-1, 1:patchsize, 1:3));
        ssd_transfer = ssd_patch(imtexture, M2, T);
        
        % calculate template and ssd_overlap
        T = imtransfer(start_idx:start_idx+patchsize-1, 1:patchsize, 1:3);
        ssd_overlap = ssd_patch(imtexture, M1, T);
        
        % calculate cost and sample from the image
        cost = alpha * ssd_overlap + (1-alpha) * ssd_transfer;
        sample = choose_sample(patchsize, imtexture, cost, tol);

        % everything else is the same for texture transfer
        % calc diff from existing and sampled patch
        % calculate sum of all channel errors ssd and send to cut function
        % using derek's cut dp algorithm
        existn_patch = T(1:overlap, 1:patchsize, 1:3);
        new_patch = sample(1:overlap, 1:patchsize, 1:3);
        diff = existn_patch - new_patch;
        errpatch = diff(:,:,1).^2 + diff(:,:,1).^2 + diff(:,:,1).^2;
        mask = cut(errpatch);

        % this needs to be done in versions of matlab below 2017 i presume
        mask3d = ones(overlap, patchsize, 3);
        for k=1:3
            mask3d(:,:,k) = mask;
        end

        existn_patch = existn_patch .* ~mask3d;
        new_patch = new_patch .* mask3d;
        sample(1:overlap, 1:patchsize, 1:3) = new_patch + existn_patch;
        
        % change the new sample according to seam found
        imtransfer(start_idx:start_idx+patchsize-1, 1:patchsize, 1:3) = sample;
        start_idx = start_idx+patchsize-overlap;
    end
    
    %% fill out values horizontally
    % calculate ssd_overlap
    % first calculate masks
    M1 = zeros(patchsize);
    M1(1:patchsize, 1:overlap) = ones(patchsize, overlap);
    M2 = ones(patchsize);

    % run loop for all horizontal images
    start_idx = patchsize-overlap+1;
    for i = 1:numimages_h
        % calculate template and ssd_transfer
        T = im2double(imsmudged(1:patchsize, start_idx:start_idx+patchsize-1, 1:3));
        ssd_transfer = ssd_patch(imtexture, M2, T);
        
        % calculate template and ssd_overlap
        T = imtransfer(1:patchsize, start_idx:start_idx+patchsize-1, 1:3);
        ssd_overlap = ssd_patch(imtexture, M1, T);
        
        % calculate cost and sample from the image
        cost = alpha * ssd_overlap + (1-alpha) * ssd_transfer;
        sample = choose_sample(patchsize, imtexture, cost, tol);

        % everything else is the same for texture transfer
        % calc diff from existing and sampled patch
        % calculate sum of all channel errors ssd and send to cut function
        % using derek's cut dp algorithm
        existn_patch = T(1:patchsize, 1:overlap, 1:3);
        new_patch = sample(1:patchsize, 1:overlap, 1:3);
        diff = existn_patch - new_patch;
        errpatch = diff(:,:,1).^2 + diff(:,:,1).^2 + diff(:,:,1).^2;
        mask = cut(errpatch')';

        % this needs to be done in versions of matlab below 2017 i presume
        mask3d = ones(patchsize, overlap, 3);
        for k=1:3
            mask3d(:,:,k) = mask;
        end

        existn_patch = existn_patch .* ~mask3d;
        new_patch = new_patch .* mask3d;
        sample(1:patchsize, 1:overlap, 1:3) = new_patch + existn_patch;
        
        % change the new sample according to seam found
        imtransfer(1:patchsize, start_idx:start_idx+patchsize-1, 1:3) = sample;
        start_idx = start_idx+patchsize-overlap;
    end
    
    %% fill out values diagonally - basically all the remaining ones
    % calculate ssd_overlap
    % first calculate masks
    M1 = zeros(patchsize);
    M1(1:patchsize, 1:overlap) = ones(patchsize, overlap);
    M1(1:overlap, 1:patchsize) = ones(overlap, patchsize);
    M2 = ones(patchsize);

    % run loop for all remaining images
    start_row = patchsize-overlap+1;
    for i = 1:numimages_v
        start_col = patchsize-overlap+1;
        for j = 1:numimages_h
            % calculate template and ssd_transfer
            T = im2double(imsmudged(start_row:start_row+patchsize-1, start_col:start_col+patchsize-1, 1:3));
            ssd_transfer = ssd_patch(imtexture, M2, T);
        
            % calculate template and ssd_overlap
            T = imtransfer(start_row:start_row+patchsize-1, start_col:start_col+patchsize-1, 1:3);
            ssd_overlap = ssd_patch(imtexture, M1, T);
        
            % calculate cost and sample from the image
            cost = alpha * ssd_overlap + (1-alpha) * ssd_transfer;
            sample = choose_sample(patchsize, imtexture, cost, tol);

            % calc diff from existing and sampled patch
            % calculate sum of all channel errors ssd and send to cut function
            % using derek's cut dp algorithm
            % calc for horizontal patch
            existn_patch1 = T(1:overlap, 1:patchsize, 1:3);
            new_patch1 = sample(1:overlap, 1:patchsize, 1:3);
            diff = existn_patch1 - new_patch1;
            errpatch = diff(:,:,1).^2 + diff(:,:,1).^2 + diff(:,:,1).^2;
            mask1 = cut(errpatch);
           
            % calc for vertical patch
            existn_patch2 = T(1:patchsize, 1:overlap, 1:3);
            new_patch2 = sample(1:patchsize, 1:overlap, 1:3);
            diff = existn_patch2 - new_patch2;
            errpatch = diff(:,:,1).^2 + diff(:,:,1).^2 + diff(:,:,1).^2;
            mask2 = cut(errpatch')';
            
            % combine masks 
            new_mask = ones(patchsize, patchsize);
            new_mask(1:overlap, 1:patchsize) = mask1; 
            new_mask(1:patchsize, 1:overlap) = new_mask(1:patchsize, 1:overlap) & mask2;
            
            % make 3d version of mask
            new_mask3d = ones(patchsize, patchsize, 3);
            for k=1:3
                new_mask3d(:,:,k) = new_mask;
            end
    
            % the patch we are going to use
            existn_patch = T .* ~new_mask3d;
            new_patch = sample .* new_mask3d;
           
            % change the new sample according to seam found
            imtransfer(start_row:start_row+patchsize-1, start_col:start_col+patchsize-1, 1:3) = new_patch + existn_patch;
            start_col = start_col + patchsize-overlap;
        end
        start_row = start_row+patchsize-overlap;
    end
end
