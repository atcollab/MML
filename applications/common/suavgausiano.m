function [COUNTSn] =  suavgausiano(COUNTS,w);
%This function implements the gaussian smooth for an histogram an then it
%can be used to find the thershold. It uses the COUNTS variable that is
%returned by the imhist funcion an w is the size of the window that you
%want to use. It has to be a odd number. if not, the funcion will not run
%properly.
%Typical application:
%           I=imread('blood1','tiff');
%           [COUNTS,x]=imhist(I);
%           COUNTSn=suavgausiano(COUNTS,3);
%Where COUNTSn is the new COUNTS variable that is smoothed using the
%suavgausiano function with a window of size 3.
%To run this function you wont need the Image Processing Toolbox, but
%you'll need it when you want to read the image and try to get its
%histogram.
%I hope this code can help you.
ng=[0.2261 0.5478 0.2261];
tamw=(w-1)/2;
if (w>3)
    for i=1:tamw-1
        ng=conv(ng,ng);
    end
end
lng=length(ng);
limite=(lng+1)/2;
lc=length(COUNTS);
for i=limite:lc-limite
    COUNTSint=0;
    for k=1:length(ng)-1
        COUNTSint=(ng(k)*COUNTS(i-limite+k))+COUNTSint;
    end
    COUNTS(i)=COUNTSint;
end
COUNTSn=COUNTS;