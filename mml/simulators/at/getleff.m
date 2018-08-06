function Length = getleff(Family, varargin)
%GETLEFF - Returns the magnet length as in the AT deck [meters]
%  Leff = getleff(Family, DeviceList)
%
%  INPUTS
%  1. Family = Family Name 
%              Accelerator Object
%              Cell Array of Accelerator Objects or Family Names
%              AT FamName
%  2. DeviceList = [Sector Device #] or [element #] list {default or empty list: whole family}
%
%  NOTES
%  1. If Family is a cell array, then DeviceList must also be a cell array
%  2. If using AT FamName, then DeviceList is index vector, ie,
%              Length = THERING{ATIndexList}.Length(DeviceList)

%  Written by Greg Portmann

global THERING

if nargin == 0,
    error('Must have at least one input (Family or Channel Name).');
end

ATIndexList = getfamilydata(Family, 'AT', 'ATIndex', varargin{:});

if isempty(ATIndexList)
    % Try an AT family
    ATIndexList = findcells(THERING, 'FamName', Family);
    ATIndexList = ATIndexList(:);
    if nargin >= 2
        ATIndexList = ATIndexList(varargin{2});
    end
end

for i=1:size(ATIndexList,1)
    Length(i,1) = 0;
    for j=1:size(ATIndexList,2)
        Length(i,1) = Length(i,1) + THERING{ATIndexList(i,j)}.Length;
    end
end
