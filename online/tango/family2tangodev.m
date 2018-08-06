function [TangoNames, ErrorFlag] = family2tangodev(Family, DeviceList, Field);
%FAMILY2TANGODEV - Converts a Family with device list to TANGO device names
% [TangoNames, ErrorFlag] = family2tangodev(Family, Field, DeviceList)
%
% INPUTS  
% 1. Family = Family Name 
%             Data Structure
%             Accelerator Object
%             Cell Array
% 2. DeviceList ([Sector Device #] or [element #])
% 
% OUTPUTS 
% 1. TangoNames = Tango device name corresponding to the Family, Field, and DeviceList
%
% NOTES
% 1. If Family is a cell array, then DeviceList and Field must also be a cell arrays
% 2. Returns only status 1 devices -- See StatusFlag
%
% EXAMPLES 
% 1. family2tangodev('BPMx'[1 1])
% 2. family2tangodev({'HCOR','VCOR'},{[1 1],[1 2]})
%
% See also family2tango, tango2family

% 
% Written by Laurent S. Nadolski

% Status input
StatusFlag = 1;  % Only return good status devices

if nargin == 0
    error('Must have at least one input (''Family'')!');
end

if isstruct(Family)
    if isfield(Family,'FamilyName') 
        % For data structures (as returned by getpv)
        InputStruct = Family;
        if nargin > 1
            warning('DeviceList inputs are ignored for data structure inputs');
        end
        if isfield(InputStruct,'FamilyName')
            % Data structure
            Family = InputStruct.FamilyName;   
        else
            error('Family input of unknown type');
        end
        
        if isfield(InputStruct,'DeviceList')
            DeviceList = InputStruct.DeviceList;
        else
            error('DeviceList not in the data structure');
        end
    end
end

if iscell(Family)
    if nargin >= 2
        if ~iscell(DeviceList)
            error('If Family is a cell array, then DeviceList must be a cell array.');
        end
        if length(Family) ~= length(DeviceList)
            error('Family and DeviceList must be the same size cell arrays.');
        end
    end
    
    for i = 1:length(Family)
        if nargin == 1
            [TangoNames{i}, ErrorFlag{i}] = family2tangodev(Family{i});
        else            
            [TangoNames{i}, ErrorFlag{i}] = family2tangodev(Family{i}, DeviceList{i});
        end
    end
    return    
end

if nargin <1
    error('Must have at least two inputs (''Family'')!');
end

if nargin < 2
    [TangoNames, ErrorFlag] = getfamilydata(Family, 'DeviceName');
else
    [TangoNames, ErrorFlag] = getfamilydata(Family, 'DeviceName', DeviceList);
end

if (StatusFlag)
    if ~exist('DeviceList') 
        Status = getfamilydata(Family,'Status');
    else
        Status = getfamilydata(Family,'Status', DeviceList);
    end
    if ~iscell(TangoNames)
        TangoNames = {TangoNames};
    end
    TangoNames = TangoNames(find(Status)); 
end
