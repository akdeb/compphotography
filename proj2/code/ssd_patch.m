%{
Function: ssd_patch()
This function takes the mask, the sample (the image), the template and 
returns the ssd cost image to the calling function quilt_simple.
%}

function imcost = ssd_patch(I, M, T)
    r_ssd = imfilter(I(:,:,1).^2, M) -2*imfilter(I(:,:,1), M .* T(:,:,1)) + sum(sum((M .* T(:,:,1)).^2));
    g_ssd = imfilter(I(:,:,2).^2, M) -2*imfilter(I(:,:,2), M .* T(:,:,2)) + sum(sum((M .* T(:,:,2)).^2));
    b_ssd = imfilter(I(:,:,3).^2, M) -2*imfilter(I(:,:,3), M .* T(:,:,3)) + sum(sum((M .* T(:,:,3)).^2));
    imcost = r_ssd + g_ssd + b_ssd;
end