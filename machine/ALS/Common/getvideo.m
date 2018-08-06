function [AM, tout, DataTime, ErrorFlag] = getvideo(Family, Field, DeviceList, varargin)
% [AM, tout, DataTime, ErrorFlag] = getvideo(Family, Field, DeviceList, t, FreshDataFlag, TimeOutPeriod)
%

VideoNames = family2channel('TV', 'Video');
DeviceListTotal = family2dev('TV');

AM = zeros(size(VideoNames,1),1);

SubMachine = getfamilydata('SubMachine');
if strcmpi(SubMachine, 'GTB')
    MUX_Name = 'ltb_video_mux';
elseif strcmpi(SubMachine, 'Booster')
    MUX_Name = 'br_video_mux';
elseif strcmpi(SubMachine, 'BTS')
    MUX_Name = 'br_video_mux';
elseif strcmpi(SubMachine, 'StorageRing')
    MUX_Name = 'br_video_mux';
else
    error('SubMachine type unknown');
end
[Video, tout, DataTime, ErrorFlag] = getpv(MUX_Name, 'char');

if length(Video) < 7
    Video(7) = ' ';
end

i = findrowindex(Video, VideoNames);

AM(i) = 1;

ii = findrowindex(DeviceList, DeviceListTotal);

AM = AM(ii);
