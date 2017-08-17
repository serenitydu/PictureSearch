function [Hist]=getImageHists(imagePath)
% read RGB data:
RGB=imagePath;
if RGB==3
    RGB = rgb2gray(imagePath);
end

% get image size:
[M,N] = size(RGB);

range =256;

Hist = zeros(range,1);

for (i=1:M)
    for (j=1:N)
        nn = double(RGB(i,j))+1;        
        Hist(nn) = Hist(nn)+1;
    end
end
Hist = Hist / (M*N);

save mydata Hist