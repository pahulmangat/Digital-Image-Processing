function y = countGL(im, v)
    %countGL accepts a uint8 image matrix, im, and a vector, v, of strictly
    %increasing gray-level values and returns a 1x(N-1) row vector, y, where
    %y(i) is the total number of pixels in im that satisfy v(i)=<im<v(i+1)

    N = length(v); %length of vector
    y = zeros(1,N-1);
    im_size = size(im); % size of image
    im_rows = im_size(1); % rows of image
    im_cols = im_size(2); % columns of image
    
    for i = 1:N-1 %iterate through the v and compare the GL with each pixel
        count = 0; % count tracks pixel count - resets every gray level
        for j = 1:im_rows 
            for k = 1:im_cols
                if (v(i)<=im(j,k)) && (im(j,k)<v(i+1)) % check condition
                    count = count + 1; %if above condition is true, increase count by 1
                end
            end
        end
        y(i) = count; %store countfor that to the value of y at the index of that gray level
    end
end
