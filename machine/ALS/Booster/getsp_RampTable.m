function [AM, tout, DataTime, ErrorFlag] = getsp_RampTable(Family, Field, DeviceList, varargin)
% [AM, tout, DataTime, ErrorFlag] = getsp_RampTable(Family, Field, DeviceList, t, FreshDataFlag, TimeOutPeriod)
%
tout = 0; 
DataTime = clock;
ErrorFlag = 0;

if strcmpi(Family, 'QF')
    FileName = '/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_current/RampTableQF.txt';
else
    FileName = '/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_current/RampTableQD.txt';
end

fid = fopen(FileName,'r');
if fid == -1
    fprintf('   File open error.\n');
    return;
end

Freq = fscanf(fid, '%f\n', 1);
Gain = fscanf(fid, '%f\n', 1);
Offset = fscanf(fid, '%f', 1);
AM = fscanf(fid, '%f', [1 inf]);
fclose(fid);

AM = AM(:)';

