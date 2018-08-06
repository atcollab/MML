function [AM, tout, DataTime, ErrorFlag] = getam_DVM(Family, Field, DeviceList, varargin)
% [AM, tout, DataTime, ErrorFlag] = getam_DVM(Family, Field, DeviceList, t, FreshDataFlag, TimeOutPeriod)
%


%FileName = '/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_current/BEND_QF_QD.txt';
%Directory = '/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_current/';
% Directory = '/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20070707/';
% Directory = '/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20070910_higher_energy/';
Directory = '/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20071031/';

d = dir(Directory);
d(1:2) = [];
for i = 1:length(d)
    DataTime(i) = datenum(d(i).date);
end
[tmp,i]=max(DataTime);
FileName = [Directory d(i).name];

fprintf('  Getting %s data from %s\n', Family, FileName);



fid = fopen(FileName,'r');
if fid == -1
    fprintf('   File open error.\n');
    return;
end
f = fscanf(fid, '%f\n', 1);
N = fscanf(fid, '%f\n', 1);
Data = fscanf(fid, '%f %f %f', [3 inf]);
fclose(fid);

Data = Data';

%QF   =  60 * Data(:,1);  %  60->New Quad, 48->Old Quad
%QD   =  60 * Data(:,2);  %  60->New Quad, 48->Old Quad
%BEND = 125 * Data(:,3);  % 125->New BEND, 80->Old BEND
if strcmpi(Family, 'QF')
    AM =  60 * Data(:,3);
elseif strcmpi(Family, 'QD')
    AM =  60 * Data(:,2) * 10 / 2.14;
elseif strcmpi(Family, 'BEND')
    AM = 80 * Data(:,1);
else
   error('Unknown family');
end

AM = AM(:)';


tout = 0;
DataTime =  datenum(clock);
ErrorFlag = 0;

