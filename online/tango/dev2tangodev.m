function [TangoNames, ErrorFlag] = dev2tangodev(Family, DeviceList)
%DEV2TANGODEV - Converts a device list to TANGO device names
%  [TangoNames, ErrorFlag] = dev2tangodev(Family, DeviceList)
%
%  INPUTS  
%  1. Family = Family Name 
%             Data Structure
%             Accelerator Object
%             Cell Array
%  2. DeviceList ([Sector Device #] or [element #])
% 
%  OUTPUTS 
%  1. TangoNames = Device name  corresponding to the Family, and DeviceList
%
%  NOTES
%  1. If Family is a cell array, then DeviceList and Field must also be a cell arrays
%  2. Returns only status 1 devices -- See StatusFlag
%
%  EXAMPLES 
%  1. dev2tangodev('BPMx','Monitor',[1 1])
%  2. dev2tangodev({'HCOR','VCOR'},{'Monitor','Monitor'},{[1 1],[1 2]})
%
%  See Also family2tangodev, tango2family

% 
% Written by Laurent S. Nadolski

if nargin <= 1
    error('Must have at least two inputs (''Family'', (''devicelist'')!');
end

[TangoNames, ErrorFlag] = family2tangodev(Family, DeviceList);
