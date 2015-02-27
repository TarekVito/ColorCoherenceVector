%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function discretize the color to numColors and converts the RGB Image to one channel image 
% The idea is to find equal number of unique colors in each channel so that the total conbination
% becomes ~numColors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [oneChannel, updatedNumC] = discretizeColors(img,numColors)

width = size(img,2);
height = size(img,1);
oneChannel = zeros(height,width);

% We have 3 channels. For each channel we have V unique values. 
% So we want to find the value of V given that V x V x V ~= numColors
numOfBins = floor(pow2(log2(numColors)/3));
numOfBinsSQ = numOfBins*numOfBins;
img = floor((img/(256/numOfBins)));
for i=1:height
    for j=1:width
        oneChannel(i,j) = img(i,j,1)*numOfBinsSQ ...
            + img(i,j,2)*numOfBins + img(i,j,3);
    end
end
updatedNumC = power(numOfBins,3);

end
