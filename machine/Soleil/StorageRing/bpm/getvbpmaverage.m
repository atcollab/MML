function [AM, tout, DataTime, ErrorFlag] = getvbpmaverage(varargin)
%GETHBPMGROUP - Gets horizontal orbit read into valid BPMS using TANGO groups
%
%  INPUTS
%  1. Familyname
%  2. Field
%  3. DeviceList - BPM devicelist
%  4. time
%
%  OUTPUTS
%  1. AM - horizontal beam position
%
% NOTES
% First shot


%
% Written by Laurent S. Nadolski

t0 = clock;  % starting time for getting data
DataTime = 0;
ErrorFlag = 1;
Field = 'Monitor';
DeviceListTotal = family2dev('BPMz');

if isempty(varargin)
    DeviceList = DeviceListTotal;
else
    DeviceList = varargin{3};
end


R = tango_read_attribute2('ANS/DG/BPM-MANAGER', 'zMeanOrbit');

% x = zeros(120,1);
% for k=1:50,
%     x = x + getz;
% end
% AM = x /50;


% construct data
AM(:,1) = R.value;

tout = etime(clock, t0);
DataTime = R.time; %time when data was measured accordint to Tango system
Status = findrowindex(DeviceList, DeviceListTotal);
AM = AM(Status);
