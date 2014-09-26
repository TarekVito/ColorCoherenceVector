%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ColorCoherenceVector
%====================
%
%An Improved Color Coherence Vector is a powerful color-based image retrieval. Basically it adds max-connected pixels’ spatial information 
%Parallel implementation based on this paper : An Improved Color Coherence Vector Method for CBIR - http://goo.gl/FjXHje -
%ICCV = getICCV(img, coherentThreshold, numberOfPixels)
%getICCV function takes an image and return the Color Coherence Vector that describe this Image. You can compare images using this vector.
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
%ICCV: a (4*numberOfColors) matrix represents your image. This can be used for matching.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ICCV = getICCV(img,coherentPrec, numberOfColors)
    if ~exist('coherentPrec','var')
        coherentPrec = 1;
    end
    if ~exist('numberOfColors','var')
        numberOfColors = 27;
    end
    ICCV = zeros(4,numberOfColors);
    
    Gaus = fspecial('gaussian',[5 5],2);
    img = imfilter(img,Gaus,'same');
    
    [img, updNumOfPix]= discretizeColors(img,numberOfColors);
    
    imgSize = (size(img,1)*size(img,2));
    thresh = int32((coherentPrec/100) *imgSize);
    
    for i=0:updNumOfPix-1
        BW = img==i;
        CC = bwconncomp(BW);
        compsSize = cellfun(@numel,CC.PixelIdxList);
        [~,idx] = max(compsSize);
        if isempty(idx)==0
            [subI, subJ] = ind2sub(size(img),CC.PixelIdxList{idx});
            meanPos = uint32(mean([subI subJ],1));
        else
            meanPos = [0 0];
        end
        incoherent = sum(compsSize(compsSize>=thresh));
        ICCV(:,i+1) = [incoherent; ...
            sum(compsSize) - incoherent;meanPos'];
    end
end
