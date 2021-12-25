function im2 = myequalize(im)
% myequalize equalizies the histogram of a inoput image, im and produces an
% output image, im2

[h,D] = imhist(im);   %getting histogram parameters
HaDa = cumsum(h); %getting cumalative sum along h column

A0 = sum(h);  %Total number of pixels
Dm = 255;   % Max graylevel value
Db = round((Dm/A0) * HaDa);  % Applying histogram equalization formula for discrete images
[im_size_x, im_size_y] = size(im); %getting the size of the input image       

    for i = 1:im_size_x %Re-creating the output image
        for j = 1:im_size_y
            im2(i,j) = Db(im(i,j)+1);
        end
    end
end
