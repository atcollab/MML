function [AM, tout, DataTime, ErrorFlag] = getbpmgroup(varargin)
%GETBPMGROUP - Gets vertical orbit read into valid BPMS using TANGO groups
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

GroupID = getfamilydata('BPMx', 'GroupId');

R = tango_group_read_attributes(GroupID, {'XPosSA', 'ZPosSA'}, 0);

if tango_error
    tango_print_error_stack;
    ErrorFlag = 1;
    tout = etime(clock, t0);
    return;
else
    if R.has_failed > 0
        ErrorFlag = 1;
        for k=1:length(R.dev_replies),
            if R.dev_replies(k).hasfailed
                fprintf('BPM %s has failed \n', R.dev_replies(k).dev_name)
            end
        end
        ErrorFlag = 1;
        tout = etime(clock, t0);
        return;
    end
end

% construct data
for k = 1:length(R.dev_replies),
    AM(k,1) = R.dev_replies(k).attr_values(1).value(1);
end

tout = etime(clock, t0);
DataTime = R.dev_replies(1).attr_values(1).time; %time when data was measured accordint to Tango system
Status = findrowindex(DeviceList, DeviceListTotal);
AM = AM(Status);
