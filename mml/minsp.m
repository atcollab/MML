function [Data, ErrorFlag] = minsp(varargin)
%MINSP - Minimum value of the setpoint
%
%  FamilyName/DeviceList Method
%  SPmin = maxsp(Family, DeviceList)
%  SPmin = maxsp(DataStructure)
%
%  ChannelName Method
%  SPmin = maxsp(ChannelNames)
%
%  INPUTS
%  1. Family - Family Name 
%              Data Structure
%              Accelerator Object
%  2. DeviceList - [Sector Device #] or [element #] list {Default or empty list: whole family}
%
%  OUTPUTS
%  1. SPmin - Minimum setpoint of the device
%
%  NOTES
%  1. If Family is a cell array, then DeviceList and Field can also be a cell arrays
%
%  See also maxsp, minpv

%  Written by Greg Portmann

[Data, ErrorFlag] = minpv(varargin{:});