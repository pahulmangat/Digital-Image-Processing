function [im2, a] = autolevel( fname )
% Automatically levels background of an input image, fname, 
% im2 is the levelled image
%a is a vector of the 6 unknown coefficients

im = imread( fname ); % read input image
imshow(im); % display input image

% M,N are the dimensions of the small squares
M = 16;
N = 16;
MN_cell = mat2cell(im,repelem(M,N),repelem(M,N)); % Divide the image into small squares

%defining the x,y,I arrays
x = [];     
y = [];
I = [];

for i = 1:M   % iterate through the small squares
    for j = 1:N
        [min_val,idx]=min(MN_cell{i,j}(:)); % Get minimum value of each small square
        [row,col]=ind2sub(size(MN_cell{i,j}),idx); % Get the corresponsing row and column value
        x = [x;col+ (M*(j-1))]; % Map each value for big image
        y = [y;row+ (N*(i-1))];
        I = [I;double(min_val)];
    end
end


% Plot points
hold on; plot(x, y, 'y+'); hold off
%plot(x, y, 'y+');
% Fit data at selected points to background function
% Solve least-squares problem: [C]{a} = {k} using the \ operator, i.e., {a} = [C]\{k}
%  First, compute elements of the matrix [C]
N = length(x);
Sx = sum(x);
Sy = sum(y);
Sxx = sum(x.*x);
Syy = sum(y.*y);
Sxy = sum(x.*y);
Sxxx = sum(x.^3);
Sxxy = sum(x.*x.*y);
Sxyy = sum(x.*y.*y);
Syyy = sum(y.^3);
Sxxxx = sum(x.^4);
Sxxxy = sum(y.*x.^3);
Sxxyy = sum(x.*x.*y.*y);
Sxyyy = sum(x.*y.^3);
Syyyy = sum(y.^4);
C = [N    Sx  Sy   Sxx   Syy   Sxy;
    Sx   Sxx Sxy  Sxxx  Sxyy  Sxxy;
    Sy   Sxy Syy  Sxxy  Syyy  Sxyy;
    Sxx Sxxx Sxxy Sxxxx Sxxyy Sxxxy;
    Syy Sxyy Syyy Sxxyy Syyyy Sxyyy;
    Sxy Sxxy Sxyy Sxxxy Sxyyy Sxxyy];
% Construct {k} 
SI = sum(I);
SxI = sum(x.*I);
SyI = sum(y.*I);
SxxI = sum(x.*x.*I);
SyyI = sum(y.*y.*I);
SxyI = sum(x.*y.*I);
k = [SI SxI SyI SxxI SyyI SxyI]';
% Solve
a = C\k;

% Remove background
% First compute background image
[rows, cols] = size(im);
[x, y] = meshgrid( 1:cols, 1:rows );
back = a(1) + a(2)*x + a(3)*y + a(4)*x.*x + a(5)*y.*y +a(6)*x.*y;
im2 = double(im) - back;
im2 = mat2gray(im2); % Convert matrix of type double to image of type double
im2 = im2uint8(im2); % Convert to uint8 image