function [BPM, tout, DataTime, ErrorFlag] = getbpmmls(MeasType, DeviceList)
%  BPM = getbpmmls(MeasType, DeviceList)
%
%  INPUTS
%  1. MeasType = 'Horizontal', 'Vertical', 'Cross', 'Sum', 'All',
%                'Status', 'dacrb', 'SigmaX', 'SigmaY'
%                (not case sensitive)
%  2. DeviceList - BPM device list
%
%  OUTPUTS
%  1. BPM - BPM data (1 row per BPM)
%           for 'All', each column corresponds to 'Horizontal', 'Vertical', 'Cross', 'Sum',
%                                                       'Status', 'dacrb', 'SigmaX', 'SigmaY'

%  Writen by Rainer Goergen / GP


if nargin < 1
    MeasType = 'horizontal';
end
if nargin < 2
    DeviceList = family2dev('BPMx');
end
    

[BPM1, tout, DataTime, ErrorFlag] = getpv('BPMZ1X003GP:rdBufBpm');
BPM1 = reshape(BPM1, length(BPM1)/8, 8);
BPM = BPM1';

switch lower(MeasType)
case 'horizontal'
    BPM = BPM(1,:);  
case 'vertical'
    BPM = BPM(2,:);
case 'cross'
    BPM = BPM(3,:);
case 'sum'
    BPM = BPM(4,:);
case 'status'
    BPM = BPM(5,:);
case 'dacrb'
    BPM = BPM(6,:);
case 'sigmax'
    BPM = BPM(7,:);  
case 'sigmay'
    BPM = BPM(8,:);
case 'all'
    BPM = BPM;
otherwise
    error('BPM measurement unknown');
end

BPM = BPM';
i = findrowindex(DeviceList, family2dev('BPMx',0));
BPM = BPM(i,:);
