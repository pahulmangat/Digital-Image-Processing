function thres = intermeans(im)
%intermeans finds the optimal normalized threshold to binarize an image
    h = imhist(im); %Get image histogram
    thres = round(mean2(im)); %Calculate initial threshold value
    
    %Calculate new threshold value
    thres_prev = thres + 1; 
    while thres_prev ~= thres
        thres_prev = thres;
        D = 0:thres_prev;
        meanLow = sum (D.*transpose(h([1:thres_prev+1],:)))/ sum(h([1:thres_prev+1],:));
        D_h = thres_prev+1:255;
        meanHi = sum (D_h.*transpose(h([thres_prev+2:256],:)))/ sum (h([thres_prev+2:256],:));
        thres = round((meanLow + meanHi)/2);
    end
    
    thres = thres/255; % Normalize threshold
end