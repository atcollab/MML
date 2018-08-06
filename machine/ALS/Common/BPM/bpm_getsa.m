function SA = bpm_getsa(Prefix, t, FigNum)
% BPM_GETSA

% Written by Greg Portmann

if isempty(Prefix)
    Prefix = 'SR01C:BPM4';
end
if nargin < 2 || isempty(t)
    t = 0;
end
if nargin < 3 || isempty(FigNum)
    FigNum = 200;
end

if Prefix(end) ~= ':'
    Prefix = [Prefix, ':'];
end


% A=c3  B=c1  C=c2  D=c0
RFPV = [ 
    [Prefix,'SA:X             ']
    [Prefix,'SA:Y             ']
    [Prefix,'SA:Q             ']
    [Prefix,'SA:S             ']
 
    [Prefix,'ADC3:rfMag       ']
    [Prefix,'ADC1:rfMag       ']
    [Prefix,'ADC2:rfMag       ']
    [Prefix,'ADC0:rfMag       ']
    
    [Prefix,'ADC3:ptLoMag     ']
    [Prefix,'ADC1:ptLoMag     ']
    [Prefix,'ADC2:ptLoMag     ']
    [Prefix,'ADC0:ptLoMag     ']
    
    [Prefix,'ADC3:ptHiMag     ']
    [Prefix,'ADC1:ptHiMag     ']
    [Prefix,'ADC2:ptHiMag     ']
    [Prefix,'ADC0:ptHiMag     ']
    
    [Prefix,'ADC3:gainFactor  ']
    [Prefix,'ADC1:gainFactor  ']
    [Prefix,'ADC2:gainFactor  ']
    [Prefix,'ADC0:gainFactor  ']
    
    [Prefix,'AFE:1:temperature']
    [Prefix,'AFE:2:temperature']
    [Prefix,'AFE:3:temperature']
    [Prefix,'AFE:4:temperature']
    [Prefix,'AFE:5:temperature']
    [Prefix,'AFE:6:temperature']
    [Prefix,'AFE:7:temperature']
    ];

RFPV = strvcat(RFPV, 'cmm:beam_current');
RFPV = strvcat(RFPV, 'SR01C___FREQB__AM00');


[tmp, SA.tout, Ts] = getpvonline(RFPV, t);

SA.X = tmp(1,:);
SA.Y = tmp(2,:);
SA.Q = tmp(3,:);
SA.S = tmp(4,:);
%SA.TsXYQS = linktime2datenum(Ts);
tmp(1:4,:) = [];
%Ts(1:4,:) = [];

SA.A = tmp(1,:);
SA.B = tmp(2,:);
SA.C = tmp(3,:);
SA.D = tmp(4,:);
tmp(1:4,:) = [];
%Ts(1:4,:) = [];

SA.PTLoA = tmp(1,:);
SA.PTLoB = tmp(2,:);
SA.PTLoC = tmp(3,:);
SA.PTLoD = tmp(4,:);
tmp(1:4,:) = [];
%Ts(1:4,:) = [];

SA.PTHiA = tmp(1,:);
SA.PTHiB = tmp(2,:);
SA.PTHiC = tmp(3,:);
SA.PTHiD = tmp(4,:);
tmp(1:4,:) = [];
%Ts(1:4,:) = [];
 
SA.GainA = tmp(1,:);
SA.GainB = tmp(2,:);
SA.GainC = tmp(3,:);
SA.GainD = tmp(4,:);
tmp(1:4,:) = [];
%Ts(1:4,:) = [];

SA.AFETemp = tmp(1:7,:);
tmp(1:7,:) = [];
%Ts(1:7,:) = [];

SA.DCCT   = tmp(1,:);
SA.t_DCCT = Ts(end,:);
tmp(1,:)  = [];
Ts(end,:) = [];

SA.RF     = tmp(1,:);
SA.t_RF   = Ts(end,:);
tmp(1,:)  = [];
Ts(end,:) = [];

SA.Ts = linktime2datenum(Ts);
%SA.TsStr  = datestr(SA.Ts(1),  'yyyy-mm-dd HH:MM:SS.FFF');

% Arc BPM gain factors on a curved section Bergoz card are X: 0.1613 V/% and Y: 0.1629 V/%
% Xgain = 16.13;
% Ygain = 16.29;
% 
% SA.s = SA.a + SA.b + SA.c + SA.d;
% SA.x = Xgain * (SA.a - SA.b - SA.c + SA.d ) ./ SA.s;  % mm
% SA.y = Ygain * (SA.a + SA.b - SA.c - SA.d ) ./ SA.s;  % mm
% 
% SA.pts = SA.pta + SA.ptb + SA.ptc + SA.ptd;
% SA.ptx = Xgain * (SA.pta - SA.ptb - SA.ptc + SA.ptd ) ./ SA.pts;  % mm
% SA.pty = Ygain * (SA.pta + SA.ptb - SA.ptc - SA.ptd ) ./ SA.pts;  % mm

if ~isempty(FigNum) && FigNum
    getbpm_plotsa(SA, FigNum);
end
