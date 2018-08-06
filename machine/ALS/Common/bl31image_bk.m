function bl31image(N)

if nargin < 1
    N = 100;
end

CAMonitorFlag = 0;

Cam.Name = 'BL31';

% Protect the network but get the rate you need
% Bytes/sec   FrameRate   FramePeriod
%    89e6  ->  30.0 Hz
%    80e6  ->  27.0 Hz
%    75e6  ->  25.3 Hz
%    50e6  ->  16.8 Hz
%    25e6  ->   8.4 Hz
%    10e6  ->   3.7 Hz     .27 seconds    (was 9 MB/s on apex network monitor)             
%     5e6  ->   1.7 Hz
%     1e6  ->   0.34 Hz    2.9 seconds
setpvonline([Cam.Name, ':cam1:PSByteRate'], 80e6, 'double', 1);


Cam.Cols          = getpv([Cam.Name, ':cam1:ArraySizeX_RBV']);  % or cam1:SizeX_RBV
Cam.Rows          = getpv([Cam.Name, ':cam1:ArraySizeY_RBV']);  % or cam1:SizeY_RBV
Cam.ColOffset     = getpv([Cam.Name, ':cam1:MinX_RBV']) - 1;
Cam.RowOffset     = getpv([Cam.Name, ':cam1:MinY_RBV']) - 1;
Cam.ImageNumber   = getpv([Cam.Name, ':cam1:ArrayCounter_RBV']);
Cam.Gain          = getpvonline([Cam.Name, ':cam1:Gain_RBV']);
Cam.AcquireTime   = getpvonline([Cam.Name, ':cam1:AcquireTime_RBV']);
Cam.AcquirePeriod = getpvonline([Cam.Name, ':cam1:AcquirePeriod_RBV']);
Cam.Trigger       = getpvonline([Cam.Name, ':cam1:TriggerMode_RBV']);
Cam.DataType      = getpvonline([Cam.Name, ':cam1:DataType_RBV'],'char');
Cam.ImageNumber   = getpv([Cam.Name, ':cam1:ArrayCounter_RBV']);
[Cam.Data, tout, DataTime] = getpvonline([Cam.Name, ':image1:ArrayData'],'native',Cam.Rows*Cam.Cols);
Cam.DataTime = labca2datenum(DataTime);

figure(1);
clf reset
if strcmpi(Cam.DataType, 'UInt8')
    % UInt8
    h = imagesc(reshape(Cam.Data, Cam.Cols, Cam.Rows)', [0 2^8]);
else
    % UInt16
    h = imagesc(reshape(Cam.Data, Cam.Cols, Cam.Rows)', [0 2^12]);
    %h = imagesc(reshape(Cam.Data, Cam.Cols, Cam.Rows)', [0 2^8]);   % ????
end
colormap(gray);
%colormap(hot);
axis image
htitle = title('BL 3.1');
set(htitle, 'FontSize', 16);

% Start monitor
if CAMonitorFlag
    lcaSetMonitor([Cam.Name, ':cam1:ArrayCounter_RBV']);
    lcaSetMonitor([Cam.Name, ':image1:ArrayData']);
end

for i = 1:N
    if CAMonitorFlag
        while ~lcaNewMonitorValue([Cam.Name, ':cam1:ArrayCounter_RBV'])
            pause(.05);
        end
    end
    
    Cam.ImageNumber = getpv([Cam.Name, ':cam1:ArrayCounter_RBV']);
    [Cam.Data, tout, DataTime] = getpvonline([Cam.Name, ':image1:ArrayData'], 'native', Cam.Rows*Cam.Cols);
    Cam.DataTime = labca2datenum(DataTime);

    DataImage = reshape(Cam.Data, Cam.Cols, Cam.Rows)';
    set(h,'CData', DataImage);
    
    % Full screen projection
    Cam.XProjection = sum(DataImage, 1) / size(DataImage, 1);
    Cam.YProjection = sum(DataImage, 2) / size(DataImage, 2);
    
    Cam = imagegaussianfit(Cam);
    
   % set(htitle,'string', sprintf('Image Number %d   %s',Cam.ImageNumber, datestr(Cam.DataTime, 'HH:MM:SS.FFF')));
    set(htitle,'string', sprintf('Image Number %d    \\sigma_x=%8.1f    \\sigma_y=%8.1f     Xoffset=%8.1f    Yoffset=%8.1f  %s',Cam.ImageNumber, Cam.SigmaX, Cam.SigmaY, Cam.OffsetX, Cam.OffsetY, datestr(Cam.DataTime, 'HH:MM:SS.FFF')));
    drawnow;
end


% Stop monitor
if CAMonitorFlag
    lcaClear([Cam.Name, ':cam1:ArrayCounter_RBV']);
    lcaClear([Cam.Name, ':image1:ArrayData']);
end



function Cam = imagegaussianfit(Cam)

% Gaussian fit
try
    XProjection = Cam.XProjection;
   %XLim = [1 Cam.Cols]; 
    XLim = [350 950]; 
    
    xx = XLim(1):XLim(2);
    [SigmaX, CentroidX, AmpX, OffsetX, xx, yy] = GaussianFitFS(xx(:), XProjection(xx));
    
    %[SigmaX, CentroidX, AmpX, OffsetX, r, yy] = beam_fit_gaussian(xx(:), XProjection(:));
    
    %Xoff = min(XProjection);
    %XProjection = XProjection - Xoff;
    %xx = XLim(1):XLim(2);
    %[Xmax, ii] = max(XProjection);
    %x_reduced = find(XProjection > Xmax/2);
    %f = fit(xx(x_reduced)', XProjection(x_reduced)', 'gauss1');
    %yy = f.a1 .* exp(-1*((xx-f.b1) ./ f.c1).^2) + Xoff;
    %SigmaX = f.c1/sqrt(2);
    
    %set(handles.profxzoom(2), 'XData', xx, 'YData', yy);
    %set(handles.HorizontalProjectionText, 'String', {'Projection onto the Horizontal Plane', sprintf('Sigma=%.3f  Centroid=%.3f  Amp=%.3f  Offset=%.3f', SigmaX, CentroidX, AmpX, OffsetX)});
catch
    SigmaX=NaN; CentroidX=NaN; OffsetX=NaN;
    %set(handles.HorizontalProjectionText, 'String', {' ','Projection onto the Horizontal Plane'});
    %set(handles.profxzoom(2), 'XData', [NaN NaN], 'YData', [NaN NaN]);
end

try
    YProjection = Cam.YProjection;
   %YLim = [1 Cam.Rows];
    YLim = [150 750]; 

    xx = YLim(1):YLim(2);
    [SigmaY, CentroidY, AmpY, OffsetY, xx, yy] = GaussianFitFS(xx, YProjection(xx));
    
    %[SigmaY, CentroidY, AmpY, OffsetY, r, yy] = beam_fit_gaussian(xx(:), YProjection(:));
    %set(handles.profyzoom(2), 'XData', xx, 'YData', yy);
    %set(handles.VerticalProjectionText, 'String', {'Projection onto the Vertical Plane', sprintf('Sigma=%.3f  Centroid=%.3f  Amp=%.3f  Offset=%.3f', SigmaY, CentroidY, AmpY, OffsetY)});
catch
    AmpX=NaN; AmpY=NaN; SigmaY=NaN; CentroidY=NaN; OffsetY=NaN;
    %set(handles.VerticalProjectionText, 'String', {'  ','Projection onto the Vertical Plane'});
    %set(handles.profyzoom(2), 'XData', [NaN NaN], 'YData', [NaN NaN]);
end

Cam.SigmaX    = SigmaX;
Cam.CentroidX = CentroidX;
Cam.OffsetX   = OffsetX;
Cam.SigmaY    = SigmaY;
Cam.CentroidY = CentroidY;
Cam.OffsetY   = OffsetY;


% Add logic for extra PV writes:
% if strcmpi(getfamilydata('Machine'),'APEX')
%     %if strcmpi(Cam.Image.Name, 'LCam1') && ~isnan(AmpX)
%     setpvonline([Cam.Image.Name, ':Stat:AmplitudeX'], AmpX);
%     setpvonline([Cam.Image.Name, ':Stat:SigmaX'],     SigmaX);
%     setpvonline([Cam.Image.Name, ':Stat:CentroidX'],  CentroidX);
%     setpvonline([Cam.Image.Name, ':Stat:OffsetX'],    OffsetX);
%     %setpvonline([Cam.Image.Name, ':Stat:ResidualX'],  ResidualX);
%
%     setpvonline([Cam.Image.Name, ':Stat:AmplitudeY'], AmpY);
%     setpvonline([Cam.Image.Name, ':Stat:SigmaY'],     SigmaY);
%     setpvonline([Cam.Image.Name, ':Stat:CentroidY'],  CentroidY);
%     setpvonline([Cam.Image.Name, ':Stat:OffsetY'],    OffsetY);
%     %setpvonline([Cam.Image.Name, ':Stat:ResidualY'],  ResidualY);
%     %end
% end


% Fernando's Gaussian Fit (UNDER TEST!!!)
function [Sigma, Centroid, Amp, Offset, xg, yg]=GaussianFitFS(x,y)
x = x(:)';
y = y(:)';
nx=size(x);
ny=size(y);
jj=0.;
PeakPercent=0.6;
try
    if nx==ny
        % First fit cycle is used for calculating the actual offset
        y0=0;
        y0=min(y);
        yred=y-y0;
        ym=max(yred);
        yh=0.;
        xh=0.;
        jj=0;
        for i=1:nx(2)
            if yred(i)>PeakPercent*ym
                jj=jj+1;
                yh(jj)=yred(i);
                xh(jj)=x(i);
            end
        end
        w=log(yh);
        p=polyfit(xh,w,2);
        Sigma=sqrt(-1./2./p(1));
        Centroid=-p(2)/2/p(1);
        Amp=exp(p(3)-p(2)^2/4./p(1));
        xg=x;
        yg=y0+Amp*exp(-(xg-Centroid).^2/2/Sigma^2);
        yh1=mean(y-yg);
        
        y0=y0+yh1;% Actual offset value
        Offset=y0;
        
        % Second fit cycle calculate the Gaussian fit values other than offset
        yred=y-y0;
        ym=max(yred);
        yh=0.;
        xh=0.;
        jj=0;
        for i=1:nx(2)
            if yred(i)>PeakPercent*ym
                jj=jj+1;
                yh(jj)=yred(i);
                xh(jj)=x(i);
            end
        end
        w=log(yh);
        p=polyfit(xh,w,2);
        Sigma=sqrt(-1./2./p(1));
        Centroid=-p(2)/2/p(1);
        Amp=exp(p(3)-p(2)^2/4./p(1));
        xg=x;
        yg=y0+Amp*exp(-(xg-Centroid).^2/2/Sigma^2);
    else
        ['ERROR: input variables have different size']
    end
catch
    ['ERROR: the fit was not executed']
end
% End Fernando's Fit



function [Sigmahat, bhat, Ahat, Offsethat, r, yhat] = beam_fit_gaussian(x, y)

PlotFlag = 1;
MaxIter = 4;

if nargin < 2
    A = 2.1234;
    Sigma = .25;
    b = 3.1;
    Offset = .01;
    x = (0:.01:7)';
    y = A * exp(-1*(x-b).^2 / (2*Sigma^2)) + Offset;
end

% ln(y-Offset) = ln A - (x-b)^2 /(2 sigma^2)
% ln(y-Offset) = ln A - (x^2-2xb+b^2) /(2 sigma^2)
% ln(y-Offset) =  (-1/(2 sigma^2)) * x^2 + (b/sigma^2) * x + ln A - b^2/(2 sigma^2)

if 1
    % Matlab curve fit
    Offsethat = min(y);
    y = y - Offsethat;
    %xx = XLim(1):XLim(2);
    [ymax, ii] = max(y);
    x_reduced = find(y > ymax/4);
    f = fit(x(x_reduced), y(x_reduced), 'gauss1');

    yhat = f.a1 .* exp(-1*((x-f.b1) ./ f.c1).^2) + Offsethat;
    
    Sigmahat = f.c1/sqrt(2);
    bhat = f.b1;
    Ahat = f.a1;
    r = NaN;
else
    if PlotFlag
        figure(1);
        clf reset
        plot(x, y);
    end
    
    
    % Starting point
    Offsethat = min(y);
    [Sigmahat, bhat, Ahat, yhat] = LSFit(x, y - Offsethat, PlotFlag);
    yhat = Ahat * exp(-1*(x-bhat).^2 / (2*Sigmahat^2)) + Offsethat;
    r = sum(abs(y-yhat));
    
    for i = 1:MaxIter
        % Compute Jacobian
        Delta = (max(y)-min(y))/10000;
        [Sigmahat1, bhat1, Ahat1, yhat1] = LSFit(x, y - (Offsethat+Delta), 0);
        yhat1 = Ahat1 * exp(-1*(x-bhat1).^2 / (2*Sigmahat1^2)) + (Offsethat+Delta);
        r1 = sum(abs(y-yhat1));
        
        J = (r1-r) / Delta;
        dOffset = -1*r / J;
        Offsethat = Offsethat + dOffset;
        
        [Sigmahat, bhat, Ahat, yhat] = LSFit(x, y - Offsethat, PlotFlag);
        yhat = Ahat * exp(-1*(x-bhat).^2 / (2*Sigmahat^2)) + Offsethat;
        r = sum(abs(y-yhat));
    end
end

%for i = 1:1
%   r1 = LSFit(x, y);
%end


function [Sigmahat, bhat, Ahat, yhat] = LSFit(x, y, PlotFlag)

% First cut the data so small numbers don't dominate the fit
logy = log(y);
ii = find(logy > -2.0);
logy = logy(ii);
x = x(ii);

X = [ones(length(x),1) x x.^2];

b = inv(X'*X)*X' * logy;
lnyhat = X * b;
yhat = exp(lnyhat);

Sigmahat = sqrt(-1 / (2*b(3)));
bhat     = b(2) *Sigmahat^2;
Ahat     = exp(b(1) + bhat^2/(2*Sigmahat^2));

if PlotFlag
    hold on
    plot(x, yhat, '--', 'color', nxtcolor);
    hold off
end

%Res = sum(y-yhat)/length(y)
%Res = sum(abs(lnyhat-log(y)))


