function [BPM, tout, DataTime, ErrorFlag] = getbpmspear(MeasType, DeviceList)
%  BPM = getbpmspear(MeasType, DeviceList)
%
%  INPUTS
%  1. MeasType = 'Horizontal', 'Vertical', 'Sum', 'Q', 'All', 'Voltage'
%                (not case sensitive)
%  2. DeviceList - BPM device list
%
%  OUTPUTS
%  1. BPM - BPM data (1 row per BPM)
%           for 'All', each column corresponds to 'Horizontal', 'Vertical', 'Sum', 'Q'
%           for 'Voltage', each column corresponds to Button 1, Button 2, Button 3, Button 4 voltage
%
%  Writen by Greg Portmann


if nargin < 1
    MeasType = 'horizontal';
end
if nargin < 2
    DeviceList = family2dev('BPMx');
end
    
mml2fofb_index_def;

[BPM1, tout, DataTime, ErrorFlag] = getpv('116-BPM:orbit');
BPM1 = reshape(BPM1, 4, length(BPM1)/4);
BPM2 = getpv('132-BPM:orbit');
BPM2 = reshape(BPM2, 4, length(BPM2)/4);
%BPM = [BPM2(:,36:61)  BPM1(:,1:end) BPM2(:,1:30)];
BPMfofb = [BPM2 BPM1]; 
BPM = BPMfofb(:,mml2fofbi);

switch lower(MeasType)
case 'horizontal'
    BPM = BPM(1,:);  
case 'vertical'
    BPM = BPM(2,:);
case 'sum'
    BPM = BPM(3,:);
case 'q'
    BPM = BPM(4,:);
case 'all'
    BPM = BPM;
case {'voltage','volts','volt'}
    BPM1 = BPM(1,:)/14.0;
    BPM2 = BPM(2,:)/16.6;
    BPM3 = BPM(3,:);
    BPM4 = BPM(4,:);
    a = ( BPM1(1,:).*BPM3(1,:) + BPM2(1,:).*BPM3(1,:)  +  BPM3(1,:) + BPM4(1,:).*BPM3(1,:) ) / 4 / 1000;
    b = (-BPM1(1,:).*BPM3(1,:) + BPM2(1,:).*BPM3(1,:)  +  BPM3(1,:) - BPM4(1,:).*BPM3(1,:) ) / 4 / 1000;
    c = (-BPM1(1,:).*BPM3(1,:) - BPM2(1,:).*BPM3(1,:)  +  BPM3(1,:) + BPM4(1,:).*BPM3(1,:) ) / 4 / 1000;
    d = ( BPM1(1,:).*BPM3(1,:) - BPM2(1,:).*BPM3(1,:)  +  BPM3(1,:) - BPM4(1,:).*BPM3(1,:) ) / 4 / 1000;
    BPM = [a;b;c;d];
otherwise
    error('BPM measurement unknown');
end


BPM = BPM';
i = findrowindex(DeviceList, family2dev('BPMx',0));
BPM = BPM(i,:);

