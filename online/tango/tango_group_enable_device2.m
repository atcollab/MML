function tango_group_enable_device2(group_id, dev_name, forward)
%TANGO_GROUP_ID Disables a device in the group.
%
%  INPUTS
%  1. group_id - Tango group id
%  2. dev_name - tango device list
%  3. forward - for nested group (Default: 0)
%
% See also tango_group_disable_device2

%
%  Written by Laurent S. Nadolski

if nargin < 3
   forward = 0;
end

if ~iscell(dev_name)
    dev_name = {devname};
end

for k= 1:size(dev_name,1),
    result = tango_group_enable_device(group_id, dev_name{k}, forward);
    if result == -1
        fprintf('Error when enabling device %s \n',dev_name{k});
    end
end