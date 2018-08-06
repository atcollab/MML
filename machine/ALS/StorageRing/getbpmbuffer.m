function [bpmdataX, bpmdataY, T, TimeStamp] = getbpmbuffer(DeviceList);
%  BPM = getbpmbuffer(DeviceList)
%

if nargin < 1
    %DeviceList = family2dev('BPMx');
    DeviceList = [
    12 9
    1 2
    1 10
    2 1
    2 9
    3 2
    3 10
    3 11
    3 12
    4 1 
    4 10
    5 1
    5 10
    6 1
    6 10
    7 1
    7 10
    8 1
    8 10
    9 1
    9 10
    10 1
    10 10
    10 11
    10 12
    11 1
    11 10
    12 1
    ];
end
T = 1/1111;
TimeStamp = clock;

Error = 0;
if nargin == 0
    DeviceList = family2dev('BPMx');
end


% Check if on or open
FFBON = getpv('SR01____FFBON__BM00');
if FFBON==0
    error('FFB is off.  Set to open or on.');
end

% Trigger BPMs to get fresh data
setpv('SR01____FFBLOG_BC00', 1);

FileName = '/home/physdata/matlab/srdata/orbitfeedback_fast/log/SR12bpm.log';

fprintf('Hit return when FFB data is ready...\n');
pause

d = importdata(FileName);
bpmdata = d.data;
bpmdataX = bpmdata(:,2:2:end-1)';
bpmdataY = bpmdata(:,3:2:end-1)';



