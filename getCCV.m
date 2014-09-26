%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ColorCoherenceVector
%====================
%
%Color Coherence Vector is a powerful color-based image retrieval 
%Based On This Paper : Comparing Images Using Color Coherence Vectors (1996) - http://goo.gl/LkWkbi -
%CCV = getCCV(img, coherentThreshold, numberOfPixels)
%getCCV function takes an image and return the Color Coherence Vector that describe this Image. You can compare images using this vector.
%
%Input:
%img : The Image (3-channel Image)
%
%Optional Input:
%coherentPrec: The percentage of the image size to consider a component's pixels are coherent (default = 1%)
%numberOfColors: The number of different colors in the Color Coherence Vector (default = 27 colors). 
%				Note it'll be changed a little bit to ensure the same different values for RGB channel
%
%Output :
%CCV: a (2*numberOfColors) matrix represents your image. This can be used for matching.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function CCV = getCCV(img,coherentPrec, numberOfColors)
    if ~exist('coherentPrec','var')
        coherentPrec = 1;
    end
    if ~exist('numberOfColors','var')
        numberOfColors = 27;
    end
    CCV = zeros(2,numberOfColors);
    
    Gaus = fspecial('gaussian',[5 5],2);
    img = imfilter(img,Gaus,'same');
    
    [img, updNumOfPix]= discretizeColors(img,numberOfColors);
    
    imgSize = (size(img,1)*size(img,2));
    thresh = int32((coherentPrec/100) *imgSize);
    
    parfor i=0:updNumOfPix-1
        BW = img==i;
        CC = bwconncomp(BW);
        compsSize = cellfun(@numel,CC.PixelIdxList);
        incoherent = sum(compsSize(compsSize>=thresh));
        CCV(:,i+1) = [incoherent; ...
            sum(compsSize) - incoherent];
    end
end

function [oneChannel, updatedNumC] = discretizeColors(img,numColors)

width = size(img,2);
height = size(img,1);
oneChannel = zeros(height,width);

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