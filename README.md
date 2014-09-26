ColorCoherenceVector
====================

Color Coherence Vector is a powerful color-based image retrieval 
Based On This Paper : Comparing Images Using Color Coherence Vectors (1996) - http://goo.gl/LkWkbi -
CCV = getCCV(img, coherentThreshold, numberOfPixels)
getCCV function takes an image and return the Color Coherence Vector that describe this Image. You can compare images using this vector.

Input:
img : The Image (3-channel Image)

Optional Input:

coherentPrec: The percentage of the image size to consider a component's pixels are coherent (default = 1%)

numberOfColors: The number of different colors in the Color Coherence Vector (default = 27 colors). 
		Note it'll be changed a little bit to ensure the same different values for RGB channel

Output :
CCV: a (2*numberOfColors) matrix represents your image. This can be used for matching.

