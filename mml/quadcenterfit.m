function [XOffset, YOffset] = quadcenterfit(varargin)
%QUADCENTERFIT OR BBASEARCH - Model search method to find a quarupole center
%
%  This function is under development (Greg Portmann)

%  Written by Greg Portmann

global THERING


BPMxFamily = gethbpmfamily;
BPMyFamily = getvbpmfamily;


% Planes to fit
XFlag = 1;
YFlag = 1;

% Deltas for the gradient
DeltaBump1 = .002;
DeltaBump2 = 10 * DeltaBump1;


FileName = '';
if nargin >= 1
    FileName = varargin{1};
end

if isempty(FileName)
    %[FileName, PathName] = uigetfile('*.mat', 'Select a Quadrupole Center File', [getfamilydata('Directory','DataRoot'), 'QMS', filesep]);
    [FileName, PathName] = uigetfile('*.mat', 'Select a Quadrupole Center File');
    drawnow;
    if ~isstr(FileName)
        XOffset = [];
        YOffset = [];
        return
    else
        FileName = [PathName,FileName];
        load(FileName);
    end
else
    load(FileName);
end


if exist('QMS','var')

    QuadFamily = QMS.QuadFamily;
    QuadDev = QMS.QuadDev;
    QuadDelta = QMS.QuadDelta;
    BPMFamily = QMS.BPMFamily;
    BPMDev  = QMS.BPMDev;
    Orbit0 = QMS.Orbit0;
    iBPM = findrowindex(BPMDev, QMS.Orbit0.DeviceList);
    ModulationMethod = QMS.ModulationMethod;

    if nargin >= 2
        i = varargin{2};
    else
        % i = 3;
        for i = 1:size(QMS.x1,2)
            %[XOffset(i), YOffset(i)] = quadcenterfit(FileName, i);
            [XOffset(i), YOffset(i)] = feval(mfilename, FileName, i);
        end
        return;
    end

    if isfield(QMS, 'XOffsetOld')
        x0 = QMS.x0(:,i);
        y0 = QMS.y0(:,i);
    else
        if strcmpi(ModulationMethod, 'bipolar')
            x0 = (QMS.x1(:,i)+QMS.x2(:,i))/2;
            y0 = (QMS.y1(:,i)+QMS.y2(:,i))/2;
        else
            x0 = QMS.x1(:,i);
            y0 = QMS.y1(:,i);
        end
    end
    x1 = QMS.x1(:,i);
    x2 = QMS.x2(:,i);

    y1 = QMS.y1(:,i);
    y2 = QMS.y2(:,i);

    MeasData = [QMS.x2(:,i)-QMS.x1(:,i)  QMS.y2(:,i)-QMS.y1(:,i)];

    fprintf('   Bow tie method offset %s(%d,%d)= %f (%s)\n',  QMS.BPMFamily, QMS.BPMDev, QMS.Center, FileName);

    % Note: this must be the offset when the data was taken
    if isfield(QMS, 'XOffsetOld')
        XOffsetOld = QMS.XOffsetOld; %QMS.x0(iBPM) - QMS.Xerr; %getoffset(BPMxFamily, BPMDev);
        YOffsetOld = QMS.YOffsetOld; %QMS.y0(iBPM) - QMS.Yerr; %QMS.OldCenter; %getoffset(BPMyFamily, BPMDev);
    else
        XOffsetOld = QMS.x0(iBPM) - QMS.Xerr; %getoffset(BPMxFamily, BPMDev);
        YOffsetOld = QMS.y0(iBPM) - QMS.Yerr; %QMS.OldCenter; %getoffset(BPMyFamily, BPMDev);
    end

else
    
    %load QF71test1
    %load QF71simxbump
    %load QF71simybump

    %QuadFamily = 'QF';
    %QuadDev = [7 1];
    %BPMFamily = BPMxFamily;
    %BPMDev  = [7 2];
    Orbit0 = y00;
    BPMDevTotal = y00.DeviceList;
    iBPM = findrowindex(BPMDev, y00.DeviceList);

    i = 3;
    %Yavg = (y2(iBPM,i)+y1(iBPM,i))/2;
    MeasData = [x2(:,i)-x1(:,i)  y2(:,i)-y1(:,i)];
    x0 = x0(:,i);
    y0 = y0(:,i);
    x1 = x1(:,i);
    y1 = y1(:,i);
    x2 = x2(:,i);
    y2 = y2(:,i);

    % Note: this must be the offset when the data was taken
    XOffsetOld = getoffset(BPMxFamily, BPMDev);
    YOffsetOld = getoffset(BPMyFamily, BPMDev);
    
end

% Model index
ATIndexQuad = family2atindex(QuadFamily, QuadDev);
ATIndexBPM  = family2atindex(BPMxFamily, BPMDev);
s = getspos(Orbit0);


% Reset the model
setsp('HCM', 0, 'Physics', 'Model');
setsp('VCM', 0, 'Physics', 'Model');
setshift(ATIndexQuad, 0, 0);
PolynomA = THERING{ATIndexQuad}.PolynomA;
PolynomB = THERING{ATIndexQuad}.PolynomB;
K = THERING{ATIndexQuad}.K;
THERING{ATIndexQuad}.PolynomA(1) = 0;
THERING{ATIndexQuad}.PolynomB(1) = 0;


% Add any known orbit change to the model
if exist('QMS','var')
    if strcmpi(ModulationMethod, 'sweep')
        % One directional sweep of the quadrupole
        stepsp(QuadFamily, QuadDelta * (i-1), QuadDev, 0, 'Model');
    end


    % 1-magnet "bump"
    stepsp(QMS.CorrFamily, -QMS.CorrDelta, QMS.CorrDevList, 0, 'Model');

    % Corrector step size
    N = abs(round(QMS.NumberOfPoints));
    CorrStep = 2 * QMS.CorrDelta / (N-1);
    stepsp(QMS.CorrFamily, CorrStep*(i-1), QMS.CorrDevList, 0, 'Model');

    % Starting Quadrupole displacement
    XBump = 0; %x0(iBPM) - XOffsetOld;
    YBump = 0; %y0(iBPM) - YOffsetOld;

else

    if i > 1
        % Local bump
        %[OCS, RF, OCS0] = setorbitbump(BPMxFamily, [7 2], .5*(i-1), 'HCM', [-2 -1 1 2], 4, 'Model', 'NoDisplay');
        [OCS, RF, OCS0] = setorbitbump(BPMyFamily, [7 2], .5*(i-1), 'VCM', [-2 -1 1 2], 4, 'Model', 'NoDisplay');

        % Starting Quadrupole displacement
        XBump = 0; %x0(iBPM) - XOffsetOld;
        YBump = 0; %y0(iBPM) - YOffsetOld;
    else
        % Starting Quadrupole displacement
        XBump = x0(iBPM) - XOffsetOld;
        YBump = y0(iBPM) - YOffsetOld;
    end
end

% Starting model orbit
XStart = getx(BPMDev, 'Model')-getoffset(BPMxFamily, BPMDev);
YStart = gety(BPMDev, 'Model')-getoffset(BPMyFamily, BPMDev);

fprintf('       XOffsetOld = %7.4f   YOffsetOld = %7.4f\n', XOffsetOld, YOffsetOld);

j = 0;
XBumpOld = Inf;
YBumpOld = Inf;
XQuadShift = 0;
YQuadShift = 0;
while (XFlag==1 && abs(XBump-XBumpOld)>.0005) || (YFlag==1 && abs(YBump-YBumpOld)>.0005)
    j = j + 1;
    
    if XFlag
        % Shift the quadrupole without changing the orbit (-shift is up)
        XQuadShift = -DeltaBump2/2 - DeltaBump1/2 + XBump;
        setshift(ATIndexQuad, -XQuadShift/1000, -YQuadShift/1000);
        THERING{ATIndexQuad}.PolynomB(1) = THERING{ATIndexQuad}.PolynomB(2) * (-XQuadShift/1000);
        THERING{ATIndexQuad}.PolynomA(1) = THERING{ATIndexQuad}.PolynomB(2) * (-YQuadShift/1000);
        [MeritXa, MeritYa] = bbaquadchangemodel(QuadFamily, QuadDelta, QuadDev, MeasData, ModulationMethod);
        xa = XQuadShift;

        % Shift the quadrupole without changing the orbit (-shift is up)
        XQuadShift = -DeltaBump2/2 + DeltaBump1/2 + XBump;
        setshift(ATIndexQuad, -XQuadShift/1000, -YQuadShift/1000);
        THERING{ATIndexQuad}.PolynomB(1) = THERING{ATIndexQuad}.PolynomB(2) * (-XQuadShift/1000);
        THERING{ATIndexQuad}.PolynomA(1) = THERING{ATIndexQuad}.PolynomB(2) * (-YQuadShift/1000);
        [MeritXb, MeritYb] = bbaquadchangemodel(QuadFamily, QuadDelta, QuadDev, MeasData, ModulationMethod);
        xb = XQuadShift;


        % Shift the quadrupole without changing the orbit (-shift is up)
        XQuadShift = DeltaBump2/2 - DeltaBump1/2 + XBump;
        setshift(ATIndexQuad, -XQuadShift/1000, -YQuadShift/1000);
        THERING{ATIndexQuad}.PolynomB(1) = THERING{ATIndexQuad}.PolynomB(2) * (-XQuadShift/1000);
        THERING{ATIndexQuad}.PolynomA(1) = THERING{ATIndexQuad}.PolynomB(2) * (-YQuadShift/1000);
        [MeritXc, MeritYc, xm1, xm2, ym1, ym2] = bbaquadchangemodel(QuadFamily, QuadDelta, QuadDev, MeasData, ModulationMethod);
        xc = XQuadShift;

        % Shift the quadrupole without changing the orbit (-shift is up)
        XQuadShift = DeltaBump2/2  + DeltaBump1/2 + XBump;
        setshift(ATIndexQuad, -XQuadShift/1000, -YQuadShift/1000);
        THERING{ATIndexQuad}.PolynomB(1) = THERING{ATIndexQuad}.PolynomB(2) * (-XQuadShift/1000);
        THERING{ATIndexQuad}.PolynomA(1) = THERING{ATIndexQuad}.PolynomB(2) * (-YQuadShift/1000);
        [MeritXd, MeritYd] = bbaquadchangemodel(QuadFamily, QuadDelta, QuadDev, MeasData, ModulationMethod);
        xd = XQuadShift;

        m1 = (MeritXb - MeritXa) / (xb-xa);
        m2 = (MeritXd - MeritXc) / (xd-xc);
        DelSlope = (m2-m1) / ((xc+xd)/2 - (xa+xb)/2);

        XBumpOld = XBump;
        XBump = XBump - (m1+m2)/2 / DelSlope;
    end

    if YFlag
        % Shift the quadrupole without changing the orbit (-shift is up)
        YQuadShift = -DeltaBump2/2 - DeltaBump1/2 + YBump;
        setshift(ATIndexQuad, -XQuadShift/1000, -YQuadShift/1000);
        THERING{ATIndexQuad}.PolynomB(1) = THERING{ATIndexQuad}.PolynomB(2) * (-XQuadShift/1000);
        THERING{ATIndexQuad}.PolynomA(1) = THERING{ATIndexQuad}.PolynomB(2) * (-YQuadShift/1000);
        [MeritXa, MeritYa] = bbaquadchangemodel(QuadFamily, QuadDelta, QuadDev, MeasData, ModulationMethod);
        ya = YQuadShift;

        % Shift the quadrupole without changing the orbit (-shift is up)
        YQuadShift = -DeltaBump2/2 + DeltaBump1/2 + YBump;
        setshift(ATIndexQuad, -XQuadShift/1000, -YQuadShift/1000);
        THERING{ATIndexQuad}.PolynomB(1) = THERING{ATIndexQuad}.PolynomB(2) * (-XQuadShift/1000);
        THERING{ATIndexQuad}.PolynomA(1) = THERING{ATIndexQuad}.PolynomB(2) * (-YQuadShift/1000);
        [MeritXb, MeritYb] = bbaquadchangemodel(QuadFamily, QuadDelta, QuadDev, MeasData, ModulationMethod);
        yb = YQuadShift;


        % Shift the quadrupole without changing the orbit (-shift is up)
        YQuadShift = DeltaBump2/2 - DeltaBump1/2 + YBump;
        setshift(ATIndexQuad, -XQuadShift/1000, -YQuadShift/1000);
        THERING{ATIndexQuad}.PolynomB(1) = THERING{ATIndexQuad}.PolynomB(2) * (-XQuadShift/1000);
        THERING{ATIndexQuad}.PolynomA(1) = THERING{ATIndexQuad}.PolynomB(2) * (-YQuadShift/1000);
        [MeritXc, MeritYc, xm1, xm2, ym1, ym2] = bbaquadchangemodel(QuadFamily, QuadDelta, QuadDev, MeasData, ModulationMethod);
        yc = YQuadShift;

        % Shift the quadrupole without changing the orbit (-shift is up)
        YQuadShift = DeltaBump2/2 + DeltaBump1/2 + YBump;
        setshift(ATIndexQuad, -XQuadShift/1000, -YQuadShift/1000);
        THERING{ATIndexQuad}.PolynomB(1) = THERING{ATIndexQuad}.PolynomB(2) * (-XQuadShift/1000);
        THERING{ATIndexQuad}.PolynomA(1) = THERING{ATIndexQuad}.PolynomB(2) * (-YQuadShift/1000);
        [MeritXd, MeritYd] = bbaquadchangemodel(QuadFamily, QuadDelta, QuadDev, MeasData, ModulationMethod);
        yd = YQuadShift;

        m1 = (MeritYb - MeritYa) / (yb-ya);
        m2 = (MeritYd - MeritYc) / (yd-yc);
        DelSlope = (m2-m1) / ((yc+yd)/2 - (ya+yb)/2);

        YBumpOld = YBump;
        YBump = YBump - (m1+m2)/2 / DelSlope;
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get the merit function at the predicted minimum %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Shift the quadrupole without changing the orbit (-shift is up)
    XQuadShift = XBump;
    YQuadShift = YBump;
    setshift(ATIndexQuad,  -XQuadShift/1000, -YQuadShift/1000);
    THERING{ATIndexQuad}.PolynomB(1) = THERING{ATIndexQuad}.PolynomB(2) * (-XQuadShift/1000);
    THERING{ATIndexQuad}.PolynomA(1) = THERING{ATIndexQuad}.PolynomB(2) * (-YQuadShift/1000);
    [MeritX, MeritY, xm1, xm2, ym1, ym2] = bbaquadchangemodel(QuadFamily, QuadDelta, QuadDev, MeasData, ModulationMethod);

    Merit(:,j) = [MeritX; MeritY];
    Bumps(:,j) = [XBump; YBump];


    if XFlag
        XOffset = XBump + XStart - (x0(iBPM)-XOffsetOld) + XOffsetOld;
    else
        XOffset = XOffsetOld;
    end
    if YFlag
        YOffset = YBump + YStart - (y0(iBPM)-YOffsetOld) + YOffsetOld;
    else
        YOffset = YOffsetOld;
    end

    fprintf('   %d.  XOffsetNew = %7.4f   YOffsetNew = %7.4f   XMerit = %.5g   YMerit = %.5g\n', j, XOffset, YOffset, Merit(1,j), Merit(2,j));

end
fprintf('        New - Old = %7.4f    New - Old = %7.4f\n', XOffset-XOffsetOld, YOffset-YOffsetOld);



% Reset the model
setsp('HCM', 0, 'Physics', 'Model');
setsp('VCM', 0, 'Physics', 'Model');
setshift(ATIndexQuad, 0, 0);
THERING{ATIndexQuad}.PolynomA = PolynomA;
THERING{ATIndexQuad}.PolynomB = PolynomB;
THERING{ATIndexQuad}.K = K;
%THERING{ATIndexQuad}.PolynomA(1) = 0;
%THERING{ATIndexQuad}.PolynomB(1) = 0;


% Find the average orbit change at the quadrupole
[xAT,yAT] = modeltwiss('x','All','All');
yQF = 1000*(yAT(ATIndexQuad)+yAT(ATIndexQuad+1))/2;

[mux,muy] = modeltwiss('Phase','All','All');
BPM2QuadPhase = 180*( (muy(ATIndexQuad)+muy(ATIndexQuad+1))/2 - muy(ATIndexBPM)) /pi;  % phase in degrees
fprintf('   BPM2QuadPhase=%.3f [degrees]\n\n', BPM2QuadPhase);


% figure(1);
% clf reset
% %plot(s, y2-y1, '.-');
% plot(s, y2-y1, '.-');
% hold on;

%fprintf('   YBump    = %f\n', YBump);
%fprintf('   Yoffset = %f\n', Yoffset);
%fprintf('   Y0      = %f\n', y0.Data(iBPM));




function [Meritx, Merity, x1, x2, y1, y2] = bbaquadchangemodel(Family, Delta, DeviceList, MeasData, ModulationMethod)



if strcmpi(lower(ModulationMethod), 'sweep')
    % One directional sweep of the quadrupole
    x1 = getx('Model');
    y1 = gety('Model');
    stepsp(Family, Delta, DeviceList, 0, 'Model');
    x2 = getx('Model');
    y2 = gety('Model');
    stepsp(Family,-Delta, DeviceList, 0, 'Model');
elseif strcmpi(lower(ModulationMethod), 'bipolar')
    % Modulate the quadrupole
    stepsp(Family, Delta, DeviceList, 0, 'Model');
    x1 = getx('Model');
    y1 = gety('Model');
    stepsp(Family, -2*Delta, DeviceList, 0, 'Model');
    x2 = getx('Model');
    y2 = gety('Model');
    stepsp(Family, Delta, DeviceList, 0, 'Model');
elseif strcmpi(lower(ModulationMethod), 'unipolar')
    % Modulate the quadrupole
    x1 = getx('Model');
    y1 = gety('Model');
    stepsp(Family, Delta, DeviceList, 0, 'Model');
    x2 = getx('Model');
    y2 = gety('Model');
    stepsp(Family, -Delta, DeviceList, 0, 'Model');
end


Meritx = sum((MeasData(:,1) - (x2-x1)).^2);
Merity = sum((MeasData(:,2) - (y2-y1)).^2);



