function  [xmean,ymean,Xsigma,Ysigma,XYsigma,Area] = image_rms(CleanedImg)

CleanedImg = double(CleanedImg);
[Ylength Xlength]=size(CleanedImg);
Xaxis=1:Xlength;
Yaxis=1:Ylength;
Area=sum(sum(CleanedImg));

Xprof=sum(CleanedImg);
Yprof=sum(CleanedImg,2)';

if  Area==0
    xmean=NaN;
    ymean=NaN;
    Xsigma=NaN;
    Ysigma=NaN;
    XYsigma=NaN;
    Area=NaN;
else
    xmean=(1/Area)*sum(Xaxis.*Xprof);
    ymean=(1/Area)*sum(Yaxis.*Yprof);
    Xsigma=sqrt((1/Area)*sum(Xprof.*(Xaxis-xmean).^2));
    Ysigma=sqrt((1/Area)*sum(Yprof.*(Yaxis-ymean).^2));
    
    XaxisCentered=Xaxis-xmean;
    YaxisCentered=Yaxis-ymean;
    CorrImg = double(CleanedImg) .* (YaxisCentered'*XaxisCentered);
    XYsigma=sqrt((1/Area)*sum(sum(CorrImg)));
end