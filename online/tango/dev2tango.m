function [TangoNames, ErrorFlag] = dev2tango(Family, DeviceList, Field)
%DEV2TANGO - Converts a device list to TANGO names
% [TangoNames, ErrorFlag] = dev2tango(Family, Field, DeviceList)
%
% INPUTS  
% 1. Family = Family Name 
%             Data Structure
%             Accelerator Object
%             Cell Array
% 2. DeviceList ([Sector Device #] or [element #])
% 3. Field = Accelerator Object field name ('Monitor', 'Setpoint', etc) {'Monitor'}
% 
% OUTPUTS 
% 1. TangoNames = Channel name corresponding to the Family, Field, and DeviceList
%
% NOTES
% 1. If Family is a cell array, then DeviceList and Field must also be a cell arrays
% 2. Returns only status 1 devices -- See StatusFlag
%
% EXAMPLES 
% 1. dev2tango('BPMx','Monitor',[1 1])
% 2. dev2tango({'HCOR','VCOR'},{'Monitor','Monitor'},{[1 1],[1 2]})
%
% See also family2tango, tango2family

% 
% Written by Laurent S. Nadolski

if nargin <= 1
    error('Must have at least two inputs (''Family'', (''devicelist'')!');
end

if nargin < 3
    Field = 'Monitor';
end

[TangoNames, ErrorFlag] = family2tango(Family, Field, DeviceList);
