function [XData,ZData] = soleilbpms
%SOLEIBPMS - Gets horizontal and vertical orbit read into valid BPMS
% [x,z] = soleilbpms
%
% OUTPUTS
% 1. x - horizontal beam position
% 2. z - vertical beam position
%
% NOTES
% To be modified to get X and Z at once
% To get all bpm at once

%
% Written by Laurent S. Nadolski

BPMFamily = {gethbpmfamily, getvbpmfamily};

% %read horizontal orbit for status ==1 bpms
% TangoNames = getfamilydata('BPMx','Monitor','TangoNames');
% status     = find(getfamilydata('BPMx','Status'));
% x          = getam(char(TangoNames(status,:)));
% 
% %read horizontal orbit for status ==1 bpms
% TangoNames = getfamilydata('BPMz','Monitor','TangoNames');
% status     = find(getfamilydata('BPMz','Status'));
% z          = getam(char(TangoNames(status,:)));

GroupID = getfamilydata('BPMx','GroupId');
R = tango_group_read_attribute(GroupID, 'XPosSA', 0);

if tango_error
    tango_print_error_stack
    return;
end

for k = 1:length(R.replies)
    XData(k,1) = R.replies(k).value(1);
end
Status = getfamilydata(BPMFamily{1},'Status');
XData = XData(find(Status));

R = tango_group_read_attribute(GroupID, 'ZPosSA', 0);

if tango_error
    tango_print_error_stack
    return;
end

for k = 1:length(R.replies)
    ZData(k,1) = R.replies(k).value(1);
end

Status = getfamilydata(BPMFamily{2},'Status');
ZData = ZData(find(Status));
