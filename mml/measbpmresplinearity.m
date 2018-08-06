function measbpmresplinearity(CMFamily, mm, CMDeviceList, XAxisFlag)
% MEASBPMRESPLINEARITY - Compute BPMlinearity
% 
%  INPUTS
%  1. CMFamily - Corrector Magnet Family {Default: 'HCOR'}
%  2. mm - Vector of given amplitude {Default: mm = [.5 1 1.5 2 2.5 3 3.5 4]; 
%  3. CMDeviceList - BPM DeviceListe {Default: [1 1]}
%  4. XaxisFlag - 'meters' or 'Phase' {Defaults: 'meters'}
%
%  NOTES
%  1. Data saved in bpmresplinearitydata

%  Written by Greg Portmann
%  MOdified by Laurent S. Nadolski

if nargin < 1
    CMFamily = gethcmfamily;
end
if nargin < 2
    mm = [];
end
if isempty(mm)
    mm = [.05 .25 .5 .75 1 1.25 1.5 1.75 2];
    %mm = [.25 .5 .75 1 1.25 1.5 1.75 2];
    %mm = [.1 .2 .3 .4 .5 .6 .7 .8 .9 1]; 
    mm = [.5 1 1.5 2 2.5 3 3.5 4]; 
end
if nargin < 3
    CMDeviceList = [];
end
if isempty(CMDeviceList)
    CMDeviceList = family2dev(CMFamily);
end
if nargin < 4
    XAxisFlag = 'meters';
end
CMDeviceList = CMDeviceList(1,:);

Fig = gcf;

% X-axis
if strcmpi(XAxisFlag, 'Phase')
    [BPMxspos, BPMyspos, Sx, Sy, Tune] = modeltwiss('Phase', gethbpmfamily, [], getvbpmfamily, []);
    BPMxspos = BPMxspos/2/pi;
    BPMyspos = BPMyspos/2/pi;
    XLabel = 'BPM Phase';
else
    BPMxspos = getspos(gethbpmfamily);
    BPMyspos = getspos(getvbpmfamily);
    XLabel = 'BPM Position [meters]';
end

% BPM plane
if ~isempty(findstr(upper(CMFamily),'H')) || ~isempty(findstr(upper(CMFamily),'X'))
    BPMFamily = gethbpmfamily;
    BPMspos = BPMxspos;
elseif ~isempty(findstr(upper(CMFamily),'V')) || ~isempty(findstr(upper(CMFamily),'Y')) || ...
        ~isempty(findstr(upper(CMFamily),'Z'))
    BPMFamily = getvbpmfamily;
    BPMspos = BPMyspos;
else
    error('Not sure if corrector family is horizontal or vertical.');
end
BPMDeviceList = family2dev(BPMFamily);


mm = mm(:)';
Amps = mm2amp(CMFamily, mm, CMDeviceList);


% Get data
x0 = getam(BPMFamily, 'struct');
SP0 = getsp(CMFamily, CMDeviceList, 'struct');

% if strcmpi(getmode('HCM'), 'Online')
%     Amps0 = mm2amps(CMFamily, .250, CMDeviceList);
% 
% else
%     Amps0 = mm2amps(CMFamily, .025, CMDeviceList);
% end
% 
% setsp(CMFamily, SP0 + Amps0, CMDeviceList, -2);
% BPMResp0 = (getam(BPMFamily, BPMDeviceList) - x0.Data) / Amp0;
    
for i = 1:length(Amps)
    setsp(CMFamily, SP0.Data + Amps(i), CMDeviceList, -2);
    %x(:,i) = (getam(BPMFamily, BPMDeviceList) - x0.Data) / Amps(i);
    x(:,i) = (getam(BPMFamily, BPMDeviceList) - x0.Data);
end
setsp(CMFamily, SP0.Data, CMDeviceList, -2);


C = getfamilydata('Circumference');

save bpmresplinearitydata

figure(Fig);
clf reset
h1 = subplot(3,1,1);
plot(BPMspos, x, '.-');
ylabel(sprintf('%s [%s]', BPMFamily, x0.UnitsString));
title(sprintf('BPM linearity using storage Ring Orbit Response for %s(%d,%d)', CMFamily, CMDeviceList(1,1), CMDeviceList(1,2)));
if ~isempty(C)
    xaxis([0 C]);
end

for i = 1:size(x,2)
    x(:,i) = x(:,i)/Amps(i);
end

h2 = subplot(3,1,2);
plot(BPMspos, x, '.-');
ylabel(sprintf('%s [%s/%s]', BPMFamily, x0.UnitsString, SP0.UnitsString));

x00 = x(:,1);
for i = 1:size(x,2)
    x(:,i) = x(:,i) - x00;
end

h3 = subplot(3,1,3);
plot(BPMspos, x, '.-');
xlabel(XLabel);
ylabel(sprintf('Response Matrix Differences'));

linkaxes([h1 h2 h3],'x')
set([h1 h2 h3],'XGrid','On','YGrid','On');

addlabel(1, 0, datestr(clock,0));
